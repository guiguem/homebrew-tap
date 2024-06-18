class Midas < Formula
  desc "Modern data acquisition system developed at PSI and TRIUMF"
  homepage "https://daq00.triumf.ca/MidasWiki/index.php/Main_Page"
  url "https://bitbucket.org/tmidas/midas.git",
    tag:      "midas-2022-05-c",
    revision: "fbd06ad9d665b1341bd58b0e28d6625877f3cbd0"
  version "midas-2022-05-c"
  license "GPL-1.0-only"

  bottle do
    sha256 arm64_sonoma:   "52ebc420074f1a2ed7b30f8368cac429a8a67a1fd426cc2a3768c5d63c521464"
    sha256 sonoma:         "936e4d4a64495017bfa149f974c6e3017433fe4638989e20ede886fc232c3c70"
    sha256 x86_64_linux:   "795b59b8f4ed714b3d8b91ea8b3a235c8771779897d9b49331f4f0a2b36f0c8b"
  end

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
