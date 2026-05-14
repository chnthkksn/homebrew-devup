class Devup < Formula
  desc "Local-first remote development CLI for VPS workflows"
  homepage "https://github.com/chnthkksn/homebrew-devup"
  url "https://github.com/chnthkksn/homebrew-devup/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9a50134993beffd78946b1351df52e15daf5831db6d05138a056428d82170bc1"
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
