class Devup < Formula
  desc "Local-first remote development CLI for VPS workflows"
  homepage "https://github.com/chnthkksn/homebrew-devup"
  url "https://github.com/chnthkksn/homebrew-devup/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f1b286f613fc9398c5b6e2028a5ea19612c0fddca090ff25210e345eac1497fa"
  license "MIT"

  depends_on "go" => :build
  depends_on "mutagen-io/mutagen/mutagen"

  def install
    system "go", "build", *std_go_args(output: bin/"devup"), "./cmd/devup"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/devup 2>&1", 2)
  end
end
