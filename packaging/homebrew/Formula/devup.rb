class Devup < Formula
  desc "Local-first remote development CLI for VPS workflows"
  homepage "https://github.com/chnthkksn/devup"
  url "https://github.com/chnthkksn/devup/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a768de5ce61112b9815fafaa09adb3215be396dcdb3b73f1959964d6cfc24122"
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

