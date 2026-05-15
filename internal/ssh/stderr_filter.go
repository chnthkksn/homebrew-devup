package ssh

import (
	"bytes"
	"fmt"
	"io"
	"strings"
	"sync"
)

const refusedForwardFragment = "open failed: connect failed: Connection refused"

type stderrFilter struct {
	out io.Writer

	mu          sync.Mutex
	buf         bytes.Buffer
	suppressed  int
	warnPrinted bool
}

func NewStderrFilter(out io.Writer) io.WriteCloser {
	return &stderrFilter{out: out}
}

func (f *stderrFilter) Write(p []byte) (int, error) {
	f.mu.Lock()
	defer f.mu.Unlock()

	if _, err := f.buf.Write(p); err != nil {
		return 0, err
	}

	for {
		line, ok := f.nextLine()
		if !ok {
			break
		}
		if err := f.handleLine(line); err != nil {
			return 0, err
		}
	}

	return len(p), nil
}

func (f *stderrFilter) Close() error {
	f.mu.Lock()
	defer f.mu.Unlock()

	if f.buf.Len() > 0 {
		line := strings.TrimRight(f.buf.String(), "\r\n")
		f.buf.Reset()
		if line != "" {
			if err := f.handleLine(line); err != nil {
				return err
			}
		}
	}
	return f.flushSuppressed()
}

func (f *stderrFilter) nextLine() (string, bool) {
	data := f.buf.Bytes()
	i := bytes.IndexByte(data, '\n')
	if i < 0 {
		return "", false
	}
	line := string(bytes.TrimRight(data[:i], "\r"))
	f.buf.Next(i + 1)
	return line, true
}

func (f *stderrFilter) handleLine(line string) error {
	if strings.Contains(line, refusedForwardFragment) {
		f.suppressed++
		if !f.warnPrinted {
			f.warnPrinted = true
			_, err := fmt.Fprintln(f.out, "[WARN] Remote forwarded port refused connections; suppressing repeated SSH channel errors")
			return err
		}
		return nil
	}

	if err := f.flushSuppressed(); err != nil {
		return err
	}
	_, err := fmt.Fprintln(f.out, line)
	return err
}

func (f *stderrFilter) flushSuppressed() error {
	if f.suppressed == 0 {
		return nil
	}
	_, err := fmt.Fprintf(f.out, "[WARN] Suppressed %d repeated SSH forward refusal errors\n", f.suppressed)
	f.suppressed = 0
	return err
}
