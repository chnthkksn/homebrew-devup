package mutagen

import (
	"os"
	"path/filepath"
	"reflect"
	"testing"
)

func TestBuildIgnoresWithoutGitignore(t *testing.T) {
	dir := t.TempDir()
	got, err := BuildIgnores(dir)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !reflect.DeepEqual(got, DefaultIgnores) {
		t.Fatalf("ignores mismatch: got %#v want %#v", got, DefaultIgnores)
	}
}

func TestBuildIgnoresWithGitignore(t *testing.T) {
	dir := t.TempDir()
	content := "# comment\n\nnode_modules\n.DS_Store\n*.log\n!important.log\n"
	if err := os.WriteFile(filepath.Join(dir, ".gitignore"), []byte(content), 0o644); err != nil {
		t.Fatalf("write .gitignore: %v", err)
	}

	got, err := BuildIgnores(dir)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	want := append([]string{}, DefaultIgnores...)
	want = append(want, ".DS_Store", "*.log")
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("ignores mismatch: got %#v want %#v", got, want)
	}
}
