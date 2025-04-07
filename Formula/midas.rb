class Midas < Formula
  desc "Modern data acquisition system developed at PSI and TRIUMF"
  homepage "https://daq00.triumf.ca/MidasWiki/index.php/Main_Page"
  url "https://gitlab.in2p3.fr/hk/clocks/midas.git",
    tag:      "midas-mod-2025-04-a",
    revision: "58b0f9f5d5d962f0957843c4a84b35f0d4eae25b"
  version "midas-mod-2025-04-a"
  license "GPL-1.0-only"

  bottle do
    root_url "https://github.com/guiguem/homebrew-tap/releases/download/midas-midas-mod-2025-04-a"
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma: "4f27d688fb1223aa3453a1c0e4ee5b1434a47798f87d11fdd1740e4770cc9bd5"
    sha256 cellar: :any,                 ventura:      "7e95a2ae31fe5e53fcc7782ae1e8abc87b66cccdab4d514aebc9788d7362bdd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d18b15d5ab9df34b2905336818cac45640890ab96e7df09e5e18b2ae4915db29"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "mysql"
  depends_on "openssl@3"
  depends_on "root"
  depends_on "unixodbc"
  depends_on "zlib"
  depends_on "zstd"

  def install
    args = std_cmake_args + %w[
      -D CMAKE_POSITION_INDEPENDENT_CODE=ON
      -D NO_ROOT=0
      -D CMAKE_CXX_STANDARD=17
    ]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      You still need to define the exptab file and export the MIDAS_EXPTAB environment variable to use the midas executables correctly.
      For bash users, you can run for example
         export MIDAS_EXPTAB=$HOME/online/exptab
      The exptab file (defined by $MIDAS_EXPTAB) can be produced for the first time via
         echo "myexpt $HOME/online $USER" > $MIDAS_EXPTAB
    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test midas`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/odbedit", "--help"
  end
end
