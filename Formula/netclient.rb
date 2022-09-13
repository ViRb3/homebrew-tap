class Netclient < Formula
  desc "Automate fast, secure, and distributed virtual networks using WireGuard"
  homepage "https://netmaker.io"
  url "https://github.com/gravitl/netmaker/archive/v0.15.1.tar.gz"
  sha256 "849e0b039b2e8c9167596ee44bfd707b0dafd06a27852d50d87d86c9177b151c"
  license "SSPL-1.0"
  head "https://github.com/gravitl/netmaker.git", branch: "master"

  bottle do
    root_url "https://github.com/ViRb3/homebrew-tap/releases/download/netclient-0.15.1"
    sha256 cellar: :any_skip_relocation, monterey:     "172d956951888b6a79ec807ed46cab62728444cfba237afb03bd57dadb303b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "68d11e73c4293067ace922d40be88ee91cdd56d5b45f88db98a9bd6575eebea1"
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
