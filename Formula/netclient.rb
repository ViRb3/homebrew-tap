class Netclient < Formula
  desc "Automate fast, secure, and distributed virtual networks using WireGuard"
  homepage "https://netmaker.io"
  url "https://github.com/gravitl/netmaker/archive/v0.15.2.tar.gz"
  sha256 "227dd17ce9ba4fdf17ae3d3774d93bbcb749a4df7f93dc0259949fa96ae815a0"
  license "SSPL-1.0"
  head "https://github.com/gravitl/netmaker.git", branch: "master"

  bottle do
    root_url "https://github.com/ViRb3/homebrew-tap/releases/download/netclient-0.15.2"
    sha256 cellar: :any_skip_relocation, monterey:     "8fa5c6671253b4544a702312651e151d95a65538714de7a7a986d9ea7d3fc1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f1a8db3e0bb2ddb959f6b506bb43698920d98777f0e2de9fbe3bb3452444cc9"
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
