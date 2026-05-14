class Devup < Formula
  desc "Local-first remote development CLI for VPS workflows"
  homepage "https://github.com/chnthkksn/devup"
  url "https://github.com/chnthkksn/devup/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
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

