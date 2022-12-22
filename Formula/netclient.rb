class Netclient < Formula
  desc "Automate fast, secure, and distributed virtual networks using WireGuard"
  homepage "https://netmaker.io"
  url "https://github.com/gravitl/netmaker/archive/v0.17.1.tar.gz"
  sha256 "034d99514fb5100d0584129a5e4cdcc3b7d4b4f85d39244aebb8c9566f791f05"
  license "SSPL-1.0"
  head "https://github.com/gravitl/netmaker.git", branch: "master"

  bottle do
    root_url "https://github.com/ViRb3/homebrew-tap/releases/download/netclient-0.17.1"
    sha256 cellar: :any_skip_relocation, monterey:     "cd91b8b4636fab5e7ebeff38a56951952ec611877af57c8841a7ef922f4707a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f4fe4454f6d6b45f6267d8bd8953d521bcea1abbf3b412f74c7639821a696947"
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
