class Midas < Formula
  desc "Modern data acquisition system developed at PSI and TRIUMF"
  homepage "https://daq00.triumf.ca/MidasWiki/index.php/Main_Page"
  url "https://bitbucket.org/tmidas/midas.git", branch: "develop"
  version "2026-08"
  license "GPL-1.0-only"

  bottle do
    root_url "https://github.com/guiguem/homebrew-tap/releases/download/midas-2026-08"
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "f6c3d01df07ef9e68c040e3c1d4dbebaaf878c9d5f97c92efa44c025714325f8"
    sha256 cellar: :any, arm64_sonoma:  "0886a486911d80317943e9e79b7b90f64110a27250138fc59f71f201245dadf0"
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

  # Prevents simultaneous linking with 'ModMidas'
  conflicts_with "modmidas", because: "both install the same binaries and headers"

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

    cmake_dir = lib/"cmake/midas"
    cmake_dir.mkpath
    Dir["#{lib}/*.cmake"].each do |file|
      mv file, cmake_dir
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
