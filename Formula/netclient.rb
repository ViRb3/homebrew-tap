class Netclient < Formula
  desc "Automate fast, secure, and distributed virtual networks using WireGuard"
  homepage "https://netmaker.io"
  url "https://github.com/gravitl/netmaker/archive/v0.17.0.tar.gz"
  sha256 "f05cddc1f9102514fc1a08c99fae19f0d1dec6d2dddad30d29dea4a747456e35"
  license "SSPL-1.0"
  head "https://github.com/gravitl/netmaker.git", branch: "master"

  bottle do
    root_url "https://github.com/ViRb3/homebrew-tap/releases/download/netclient-0.17.0"
    sha256 cellar: :any_skip_relocation, monterey:     "9740693b3e60b904cb660593b4cb634eb0c14999b2380f2e210d9c4cc29c179e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d63dc51abcf2afc9e0ef571b69c01491944940b12d4eb7aa55e631f5bec85d51"
  end

  depends_on "go" => :build
  depends_on "wireguard-tools"

  def install
    system "go", "build", *std_go_args(ldflags: "-X 'main.version=v#{version}'"), "netclient/main.go"
  end

  plist_options startup: true
  service do
    run [opt_bin/"netclient", "daemon"]
    keep_alive true
    environment_variables PATH: std_service_path_env
  end

  test do
    output = shell_output("#{bin}/netclient 2>&1", 1)
    assert_match "This program must be run with elevated privileges", output
  end
end
