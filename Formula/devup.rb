class Devup < Formula
  desc "Local-first remote development CLI for VPS workflows"
  homepage "https://github.com/chnthkksn/homebrew-devup"
  url "https://github.com/chnthkksn/homebrew-devup/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "e6644460aaeeda5184dd47badd094cd3829621d4221e38ead9aa4d28ca80810d"
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
