class Midas < Formula
  desc "Modern data acquisition system developed at PSI and TRIUMF"
  homepage "https://daq00.triumf.ca/MidasWiki/index.php/Main_Page"
  url "https://bitbucket.org/tmidas/midas.git",
    tag:      "midas-2022-05-c",
    revision: "fbd06ad9d665b1341bd58b0e28d6625877f3cbd0"
  version "midas-2022-05-c"
  license "GPL-1.0-only"

  bottle do
    root_url "https://github.com/guiguem/homebrew-tap/releases/download/midas-midas-2022-05-c"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "981480434116056535c7aee074b7214637d6bb12827ecf4df542a8d2b3d1de68"
    sha256 cellar: :any,                 ventura:      "e9a98b74308fc432da2eeb0532be4f8bfff341ac598f36e0ce7019fc07206c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a8017fee562a8d931497ba95755f8adf1904ee747626fa4e9ca88fbc77259ba3"
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
