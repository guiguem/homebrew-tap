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
    sha256 cellar: :any,                 ventura:      "3a219f0b8d4e301cee603240a83c71ce99f3b9df3cbb12894d53ec0e27f1095f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "97c5f4db0015620a66e9521653cc60bbbf9a53dc9b18cd5c3f4a5d7b67710b46"
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
