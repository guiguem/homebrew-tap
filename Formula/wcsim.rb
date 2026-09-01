class Wcsim < Formula
  desc "GEANT4 application"
  homepage "https://github.com/WCSim/WCSim"
  url "https://github.com/WCSim/WCSim.git",
    tag:      "v1.12.29",
    revision: "43b3dae41cdc6cdb6676956d44ae474b2fb88959"
  license "MIT"

  bottle do
    root_url "https://github.com/guiguem/homebrew-tap/releases/download/wcsim-1.12.29"
    rebuild 2
    sha256 cellar: :any, arm64_sequoia: "17ed308dd26f8703e8a8b374c5082e08d5f0478c55f94b2055e733bcc4152407"
    sha256 cellar: :any, arm64_sonoma:  "05cc67261487313c408779755e3335c65cf81dfeffbd0f0515e9b1aefc12ccc0"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "geant4@10.3"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "root"

  def install
    inreplace "src/WCSimRootGeom.cc", '#include "WCSimRootGeom.hh"',
"#include \"WCSimRootGeom.hh\"\n#include \"TMath.h\""

    formula_opt_prefix("geant4@10.3")

    std_cmake_args

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Create the libexec directory
    (prefix/"libexec").mkpath

    # Move the files from bin to libexec
    # We use 'prefix' and 'bin' helpers which point to the Cellar paths shown in your logs
    mv bin/"this_wcsim.sh", prefix/"libexec/"
    mv bin/"rootwc-files", prefix/"libexec/"
  end

  def caveats
    <<~EOS
      To use WCSim, you may need to source the setup script:
        source #{opt_libexec}/this_wcsim.sh
    EOS
  end

  test do
    "true"
    #   g4_prefix = Formula["guiguem/tap/geant4@10.3"].opt_prefix

    #   # We wrap the call in a bash shell (-c) to allow sourcing
    #   system "bash", "-c", "source #{g4_prefix}/bin/geant4.sh && #{bin}/WCSim --help"
  end
end
