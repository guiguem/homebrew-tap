class Midas < Formula
  desc "Modern data acquisition system developed at PSI and TRIUMF"
  homepage "https://daq00.triumf.ca/MidasWiki/index.php/Main_Page"
  url "https://bitbucket.org/tmidas/midas.git",
    tag: "midas-2022-05-c"
  version "midas-2022-05-c"
  sha256 "788b05d43b28c4459028df75f6f786170e6d59f820994d9c1b17405731fffa62"
  license "GNU General Public License"

  depends_on "cmake" => :build
  depends_on "gcc" => :build

  def install

    args = std_cmake_args + %w[
      -D CMAKE_POSITION_INDEPENDENT_CODE=ON
      -D NO_ROOT=1
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
    system "false"
  end
end
