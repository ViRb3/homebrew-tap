class Netclient < Formula
  desc "Automate fast, secure, and distributed virtual networks using WireGuard"
  homepage "https://netmaker.io"
  url "https://github.com/gravitl/netmaker/archive/v0.16.1.tar.gz"
  sha256 "fb95defcb86ef2b9d0c523cbce343c13a3a6579a8be7a4e475f4f176c9681d63"
  license "SSPL-1.0"
  head "https://github.com/gravitl/netmaker.git", branch: "master"

  bottle do
    root_url "https://github.com/ViRb3/homebrew-tap/releases/download/netclient-0.16.1"
    sha256 cellar: :any_skip_relocation, monterey:     "1738ef5a475b04d5b6d24e50c58d9fe9d784cc10b9fb6d604ce3ae8d919cf6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "092473f675ae46d1a62ed76ec913383ad1519c0ac626413b203447f4d7ea9b73"
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
