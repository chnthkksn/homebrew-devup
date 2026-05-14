class Devup < Formula
  desc "Local-first remote development CLI for VPS workflows"
  homepage "https://github.com/chnthkksn/devup"
  url "https://github.com/chnthkksn/devup/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "7b64f66b6092217ca82bae6b6d07546c6bab751b9bb12b6552008162ec40409a"
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

