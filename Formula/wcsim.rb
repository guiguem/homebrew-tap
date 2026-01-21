# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Wcsim < Formula
  desc "The WCSim GEANT4 application"
  homepage "https://github.com/WCSim/WCSim"
  url "https://github.com/WCSim/WCSim.git",
    tag:      "v1.12.29",
    revision: "43b3dae41cdc6cdb6676956d44ae474b2fb88959"
  sha256 "91324149a0bceb96b87ee7b26c4b31b52a200b32d2cf7d89e61137095687bd4e"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "geant4@10.3"
  depends_on "root"


  # Additional dependency
  # resource "" do
  #   url ""
  #   sha256 ""
  # end

  def install
    # Remove unrecognized options if they cause configure to fail
    # https://docs.brew.sh/rubydoc/Formula.html#std_configure_args-instance_method

    inreplace "src/WCSimRootGeom.cc", '#include "WCSimRootGeom.hh"', "#include \"WCSimRootGeom.hh\"\n#include \"TMath.h\""
    # inreplace "CMakeLists.txt", "git describe --always --long --tags --dirty", "v1.12.29"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test WCSim`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end
