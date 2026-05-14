package mutagen

import (
	"fmt"
	"os"
	"os/exec"

	"devup/internal/parser"
)

var DefaultIgnores = []string{".git", "node_modules", ".next", ".dist", "coverage"}

func CreateSession(name, local string, t parser.Target, ignores []string) error {
	args := []string{"sync", "create", "--name", name}
	for _, ig := range ignores {
		args = append(args, "--ignore="+ig)
	}
	args = append(args, local, fmt.Sprintf("%s:%s", t.Host, t.RemotePath))
	cmd := exec.Command("mutagen", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func TerminateSession(name string) {
	_ = exec.Command("mutagen", "sync", "terminate", name).Run()
}

