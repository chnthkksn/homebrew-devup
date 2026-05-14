package deps

import "fmt"

func Check(required []string, lookup func(string) (string, error)) error {
	for _, bin := range required {
		if _, err := lookup(bin); err != nil {
			return fmt.Errorf("missing dependency %q in PATH", bin)
		}
	}
	return nil
}

