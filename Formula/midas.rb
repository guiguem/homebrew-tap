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
    rebuild 3
    sha256 cellar: :any, arm64_sequoia: "bf101b4fa2a9c37551424a01ffde4802af82d71728e26fdbf9184c073f7be62f"
    sha256 cellar: :any, arm64_sonoma:  "df3778b4ba6a99fac744961d20e09f4903a99f0afde12de48cf027a981f22a63"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "mariadb"
  depends_on "openssl@3"
  depends_on "postgresql@14"
  depends_on "root"
  depends_on "sqlite"
  depends_on "unixodbc"
  depends_on "zlib"
  depends_on "zstd"

  def install
    ENV["ROOTSYS"] = Formula["root"].opt_prefix

    # Ensure CMake knows exactly where ROOT is
    root_prefix = Formula["root"].opt_prefix

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
      where myexpt is the name of your experiment.
      You should also set the MIDASSYS variable so that other projects can find this version of midas:
        export MIDASSYS=$(brew --prefix midas)
    EOS
  end

  test do
    system "#{bin}/odbedit", "--help"
  end
end
