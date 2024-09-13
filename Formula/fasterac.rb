class Fasterac < Formula
  desc "Minimal analysis library in C for FASTER DAQ System"
  homepage "https://faster.in2p3.fr"
  url "https://github.com/guiguem/homebrew-tap/releases/download/fasterac-2-20-src/fasterac-2.20.1.tar.gz"
  sha256 "f15a41b2fb41ad417ed20126c2f93178aa526f526932c29c82b8064245be42a4"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/guiguem/homebrew-tap/releases/download/fasterac-2.20.1"
    sha256 arm64_sonoma: "300a375bc6acfede59b212bfba54c957a9562fdf0c4dcd8afa995dc0c1d46145"
    sha256 x86_64_linux: "2e2fd835377a023289515d6be434e933a2a3e59aaedbbccd03f9943cb8441a96"
  end

  depends_on "gcc" => :build
  depends_on "pkg-config" => :build
  depends_on "zlib"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["fasterac"].opt_libexec/"lib/pkgconfig"
  end

  # test do
  #   # `test do` will create, run in and delete a temporary directory.
  #   #
  #   # This test will fail and we won't accept that! For Homebrew/homebrew-core
  #   # this will need to be a test that verifies the functionality of the
  #   # software. Run the test with `brew test fasterac`. Options passed
  #   # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
  #   #
  #   # The installed folder is not in the path, so use the entire path to any
  #   # executables being tested: `system bin/"program", "do", "something"`.
  #   system "#{bin}/faster_disfast", "--help"
  # end
end
