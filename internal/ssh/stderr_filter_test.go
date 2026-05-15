package ssh

import (
	"bytes"
	"strings"
	"testing"
)

func TestStderrFilterSuppressesRepeatedRefusals(t *testing.T) {
	var out bytes.Buffer
	f := NewStderrFilter(&out)

	_, _ = f.Write([]byte("channel 3: open failed: connect failed: Connection refused\n"))
	_, _ = f.Write([]byte("channel 4: open failed: connect failed: Connection refused\n"))
	_, _ = f.Write([]byte("welcome\n"))
	if err := f.Close(); err != nil {
		t.Fatalf("close error: %v", err)
	}

	got := out.String()
	if !strings.Contains(got, "[WARN] Remote forwarded port refused connections; suppressing repeated SSH channel errors") {
		t.Fatalf("missing initial warning: %q", got)
	}
	if !strings.Contains(got, "[WARN] Suppressed 2 repeated SSH forward refusal errors") {
		t.Fatalf("missing suppression summary: %q", got)
	}
	if !strings.Contains(got, "welcome\n") {
		t.Fatalf("missing passthrough line: %q", got)
	}
}

func TestStderrFilterFlushesOnClose(t *testing.T) {
	var out bytes.Buffer
	f := NewStderrFilter(&out)

	_, _ = f.Write([]byte("channel 3: open failed: connect failed: Connection refused\n"))
	if err := f.Close(); err != nil {
		t.Fatalf("close error: %v", err)
	}

	got := out.String()
	if !strings.Contains(got, "[WARN] Suppressed 1 repeated SSH forward refusal errors") {
		t.Fatalf("missing close-time summary: %q", got)
	}
}
