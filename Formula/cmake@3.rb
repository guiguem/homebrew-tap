class CmakeAT3 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "http://cmake.org/files/v3.31/cmake-3.31.10.tar.gz"
  mirror "https://github.com/Kitware/CMake/releases/download/v3.31.10/cmake-3.31.10.tar.gz"
  sha256 "cf06fadfd6d41fa8e1ade5099e54976d1d844fd1487ab99942341f91b13d3e29"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/guiguem/homebrew-tap/releases/download/cmake@3-3.31.10"
    # The previously published arm64_sequoia / arm64_sonoma bottles were built
    # from the old patched sources and broke symlinked launches ("Could not
    # find CMAKE_ROOT !!!"); they were removed. Arm64 binaries for macOS 15/14
    # must be rebuilt from the current (unpatched) formula before being
    # re-published. This bottle was built from stock v3.31.10 sources.
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "aa88ee148312461e6a0b1ff065488dd04308c8dce3f319055f782a9b153623b9"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # NOTE: The old homebrew-core patch that disabled symlink resolution in
  # cmSystemTools::FindCMakeResources (workaround for Kitware issue #19849) has
  # been dropped. It broke launching cmake through a symlinked path ("Could not
  # find CMAKE_ROOT !!!"): on macOS `_NSGetExecutablePath` returns the invocation
  # path without resolving symlinks, and without GetRealPath the install-tree
  # probe cannot find the Modules directory. Stock v3.31.10 resolves symlinks to
  # the Cellar prefix, which works in all invocation forms. (CMake 4.x later
  # implemented proper "preserve symlinks if possible" handling; see the
  # symlink-regression test below.)

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # Regression test: a real configure through a symlinked cmake must
    # succeed. This catches the "Could not find CMAKE_ROOT !!!" failure caused
    # by the removed patch, which disabled symlink resolution.
    (testpath/"sym/CMakeLists.txt").write("project(SymlinkCheck NONE)")
    ln_sf bin/"cmake", testpath/"sym/cmake"
    assert system(testpath/"sym/cmake", "-S", (testpath/"sym").to_s,
                  "-B", (testpath/"sym/build").to_s)

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
