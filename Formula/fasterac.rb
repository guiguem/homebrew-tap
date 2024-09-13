class Fasterac < Formula
  desc "Minimal analysis library in C for FASTER DAQ System"
  homepage "https://faster.in2p3.fr/index.php/installation/fasterac-package"
  url "https://faster.in2p3.fr/index.php/download/category/2-software?download=28:fasterac-2-20-tar-gz"
  sha256 "f15a41b2fb41ad417ed20126c2f93178aa526f526932c29c82b8064245be42a4"
  license "GPL-3.0-or-later"

  depends_on "gcc" => :build
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test fasterac`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "#{bin}faster_disfast", "--help"
  end
end
