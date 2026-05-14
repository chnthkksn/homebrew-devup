class Devup < Formula
  desc "Local-first remote development CLI for VPS workflows"
  homepage "https://github.com/chnthkksn/devup"
  url "https://github.com/chnthkksn/devup/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a0758c968d00b8c490fb0c7f7a56e34094010d54101f83f58602142bfa812988"
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

