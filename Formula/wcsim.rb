class Wcsim < Formula
  desc "GEANT4 application"
  homepage "https://github.com/WCSim/WCSim"
  url "https://github.com/WCSim/WCSim.git",
    tag:      "v1.12.29",
    revision: "43b3dae41cdc6cdb6676956d44ae474b2fb88959"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "geant4@10.3"
  depends_on "root"

  def install
    inreplace "src/WCSimRootGeom.cc", '#include "WCSimRootGeom.hh"',
"#include \"WCSimRootGeom.hh\"\n#include \"TMath.h\""

    Formula["geant4@10.3"].opt_prefix

    std_cmake_args

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Instead of moving everything to bin, move the offending files to libexec
    libexec.install "bin/this_wcsim.sh", "bin/rootwc-files"
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
