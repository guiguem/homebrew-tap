class Midas < Formula
  desc "Modern data acquisition system developed at PSI and TRIUMF"
  homepage "https://daq00.triumf.ca/MidasWiki/index.php/Main_Page"
  url "https://gitlab.in2p3.fr/hk/clocks/midas.git", branch: "develop"
  version "2026-08"
  license "GPL-1.0-only"

  bottle do
    root_url "https://github.com/guiguem/homebrew-tap/releases/download/midas-2026-08"
    sha256 cellar: :any, arm64_sequoia: "7480ff17486b05be2b4dccb93b0e1a8c634116dc8f6286f95d4d75393efa3053"
    sha256 cellar: :any, arm64_sonoma:  "e7f134a444f313a624308333fe8c92257790e23ca682f3d3a27d4b35a68b5b46"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "mariadb"
  depends_on "openssl@3"
  depends_on "root"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "zlib"
  depends_on "zstd"

  def install
    ENV["ROOTSYS"] = formula_opt_prefix("root")

    # Ensure CMake knows exactly where ROOT is
    root_prefix = formula_opt_prefix("root")

    args = std_cmake_args + %W[
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON
      -DNO_PGSQL=1
      -DNO_ROOT=0
      -DCMAKE_CXX_STANDARD=17
      -DROOT_DIR=#{root_prefix}/cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Fix broken CMake export paths if they exist
    cmake_files = Dir["#{lib}/**/*manalyzer*.cmake"]
    cmake_files.each do |file|
      if File.read(file).match?(%r{/private/tmp/midas-[^/"]+})
        inreplace file, %r{/private/tmp/midas-[^/"]+},
prefix.to_s
      end
      inreplace file, %r{/tmp/midas-[^/"]+}, prefix.to_s if File.read(file).match?(%r{/tmp/midas-[^/"]+})
    end
    cmake_files = Dir["#{lib}/**/*midas*.cmake"]
    cmake_files.each do |file|
      if File.read(file).match?(%r{/private/tmp/midas-[^/"]+})
        inreplace file, %r{/private/tmp/midas-[^/"]+},
prefix.to_s
      end
      inreplace file, %r{/tmp/midas-[^/"]+}, prefix.to_s if File.read(file).match?(%r{/tmp/midas-[^/"]+})
    end

    # Only wrap binaries if they exist in source tree
    if (buildpath/"bin").exist?
      libexec.install Dir["bin/*"]
      bin.env_script_all_files libexec, PATH: "#{opt_bin}:$PATH"
    end
  end

  def caveats
    <<~EOS
      You still need to define the exptab file and export the MIDAS_EXPTAB environment variable to use the midas executables correctly.
      For bash users, you can run for example
         export MIDAS_EXPTAB=$HOME/online/exptab
      The exptab file (defined by $MIDAS_EXPTAB) can be produced for the first time via
         echo "myexpt $HOME/online $USER" > $MIDAS_EXPTAB
      You should also set the MIDASSYS variable so that other projects can find this version of midas:
        export MIDASSYS=$(brew --prefix midas)
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
