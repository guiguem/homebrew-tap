class Geant4AT103 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "http://geant4.cern.ch"
  url "https://gitlab.cern.ch/geant4/geant4/-/archive/v10.3.3/geant4-v10.3.3.zip"
  sha256 "2f7b760221d0c076b49585dc2e418672f4f1f02c9dcd9dd4b3c2c581d1044a0f"

  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-usolids", "Use USolids (experimental)"

  depends_on "glfw"
  depends_on "cmake"
  depends_on "libx11"
  depends_on "libxmu"
  depends_on "qt" => :optional
  depends_on "xerces-c" => :optional

  resource "G4NDL" do
    url "http://geant4.cern.ch/support/source/G4NDL.4.5.tar.gz"
    sha256 "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e"
  end

  resource "G4EMLOW" do
    url "http://geant4.cern.ch/support/source/G4EMLOW.6.50.tar.gz"
    sha256 "c97be73fece5fb4f73c43e11c146b43f651c6991edd0edf8619c9452f8ab1236"
  end

  resource "G4PhotonEvaporation" do
    url "http://geant4.cern.ch/support/source/G4PhotonEvaporation.4.3.2.tar.gz"
    sha256 "d4641a6fe1c645ab2a7ecee09c34e5ea584fb10d63d2838248bfc487d34207c7"
  end

  resource "G4RadioactiveDecay" do
    url "http://geant4.cern.ch/support/source/G4RadioactiveDecay.5.1.1.tar.gz"
    sha256 "f7a9a0cc998f0d946359f2cb18d30dff1eabb7f3c578891111fc3641833870ae"
  end

  resource "G4NEUTRONXS" do
    url "http://geant4.cern.ch/support/source/G4NEUTRONXS.1.4.tar.gz"
    sha256 "57b38868d7eb060ddd65b26283402d4f161db76ed2169437c266105cca73a8fd"
  end

  resource "G4PII" do
    url "http://geant4.cern.ch/support/source/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "RealSurface" do
    url "http://geant4.cern.ch/support/source/RealSurface.1.0.tar.gz"
    sha256 "3e2d2506600d2780ed903f1f2681962e208039329347c58ba1916740679020b1"
  end

  resource "G4SAIDDATA" do
    url "http://geant4.cern.ch/support/source/G4SAIDDATA.1.1.tar.gz"
    sha256 "a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f"
  end

  resource "G4ABLA" do
    url "http://geant4.cern.ch/support/source/G4ABLA.3.0.tar.gz"
    sha256 "99fd4dcc9b4949778f14ed8364088e45fa4ff3148b3ea36f9f3103241d277014"
  end

  resource "G4ENSDFSTATE" do
    url "http://geant4.cern.ch/support/source/G4ENSDFSTATE.2.1.tar.gz"
    sha256 "933e7f99b1c70f24694d12d517dfca36d82f4e95b084c15d86756ace2a2790d9"
  end

  def install
    # inreplace "source/geometry/management/include/G4SmartVoxelStat.hh" do |s|
    # # Use a more flexible regex to catch the inheritance even if it spans lines
    # # \s+ matches any whitespace (including newlines)
    # s.gsub!(/:\s+public\s+std::binary_function\s*<[^>]+>/, "")
    
    # # Ensure we only replace the first 'public:' which defines the class body start
    # s.sub!(/public:/, "public:\n    typedef G4SmartVoxelStat first_argument_type;\n    typedef G4SmartVoxelStat second_argument_type;\n    typedef G4bool result_type;")
    # end

    # hadronic_header = "source/processes/hadronic/models/de_excitation/multifragmentation/include/G4StatMFMicroCanonical.hh"
    # inreplace hadronic_header do |s|
    #     # Remove the inheritance
    #     s.gsub!(/class\s+SumProbabilities\s*:\s*public\s*std::binary_function\s*<[^>]+>/, "class SumProbabilities")
    #     # Add the typedefs required by the std::accumulate call later in the code
    #     s.sub!(/class SumProbabilities\s*{/, "class SumProbabilities {\npublic:\n    typedef G4double first_argument_type;\n    typedef G4double second_argument_type;\n    typedef G4double result_type;")
    # end

    # hadronic_header = "source/processes/hadronic/models/de_excitation/multifragmentation/src/G4StatMFChannel.cc"
    # inreplace hadronic_header do |s|
    #     # Remove the inheritance
    #     s.gsub!(/class\s+SumCoulombEnergy\s*:\s*public\s*std::binary_function\s*<[^>]+>/, "class SumCoulombEnergy")
    #     # Add the typedefs required by the std::accumulate call later in the code
    #     s.sub!(/class SumCoulombEnergy\s*{/, "class SumCoulombEnergy {\npublic:\n    typedef G4double first_argument_type;\n    typedef G4double second_argument_type;\n    typedef G4double result_type;")
    # end

    # interpolation_table = "source/processes/hadronic/models/inclxx/utils/src/G4INCLInterpolationTable.cc"

    # inreplace interpolation_table do |s|
    # # Replace std::mem_fun_ref(&InterpolationNode::getX)
    # # with a lambda: [](const InterpolationNode& n) { return n.getX(); }
    # s.gsub!(/std::mem_fun_ref\s*\(\s*&InterpolationNode::getX\s*\)/,
    #         "[](const InterpolationNode& n) { return n.getX(); }")
    # s.gsub!(/std::mem_fun_ref\s*\(\s*&InterpolationNode::getY\s*\)/,
    #         "[](const InterpolationNode& n) { return n.getY(); }")
    # end


    # # Path to the file with the bind2nd error
    # nuclei_model = "source/processes/hadronic/models/cascade/cascade/src/G4NucleiModel.cc"
    # inreplace nuclei_model do |s|
    # # We are replacing:
    # # std::bind2nd(std::divides<G4double>(), wtlen.back())
    # # with a lambda that does the same thing:
    # # [wt_val = wtlen.back()](G4double val) { return val / wt_val; }
    
    # s.gsub!(/std::bind2nd\s*\(\s*std::divides\s*<\s*G4double\s*>\s*\(\s*\)\s*,\s*wtlen\.back\s*\(\s*\)\s*\)/,
    #         "[&wtlen](G4double val) { return val / wtlen.back(); }")
    # end
    mkdir "geant-build" do
      
      args = %w[
        ../
        -DGEANT4_USE_OPENGL_X11=OFF
        -DGEANT4_USE_RAYTRACER_X11=ON
        -DGEANT4_BUILD_EXAMPLE=ON
        -DGEANT4_INSTALL_DATA=OFF
        -DGEANT4_BUILD_MULTITHREADED=OFF
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        -DGEANT4_USE_SYSTEM_ZLIB=ON
        -DCMAKE_CXX_STANDARD=17
      ]
       polyfill_path = buildpath/"g4_compat.h"
    polyfill_path.write <<~EOS
      #ifndef G4_COMPAT_H
      #define G4_COMPAT_H
      #ifdef __cplusplus
      #include <algorithm>
      #include <functional>
      #include <random>
      #include <type_traits>
      #include <iterator>

      namespace std {
        // 1. Re-inject binary_function and unary_function
        template<typename _Arg1, typename _Arg2, typename _Result>
        struct binary_function {
          typedef _Arg1 first_argument_type;
          typedef _Arg2 second_argument_type;
          typedef _Result result_type;
        };

        template<typename _Arg, typename _Result>
        struct unary_function {
          typedef _Arg argument_type;
          typedef _Result result_type;
        };

        // 2. Re-inject bind2nd and bind1st
        template<typename _Fn, typename _Tp>
        inline auto bind2nd(const _Fn& __f, const _Tp& __x) {
          return std::bind(__f, std::placeholders::_1, __x);
        }

        template<typename _Fn, typename _Tp>
        inline auto bind1st(const _Fn& __f, const _Tp& __x) {
          return std::bind(__f, __x, std::placeholders::_1);
        }

        // 3. Re-inject mem_fun AND mem_fun_ref (0 and 1 argument versions)
        // 0-argument versions (Non-const and Const)
        template<typename _Ret, typename _Tp>
        inline auto mem_fun(_Ret (_Tp::*__f)()) { return std::mem_fn(__f); }
        template<typename _Ret, typename _Tp>
        inline auto mem_fun_ref(_Ret (_Tp::*__f)()) { return std::mem_fn(__f); }
        template<typename _Ret, typename _Tp>
        inline auto mem_fun(_Ret (_Tp::*__f)() const) { return std::mem_fn(__f); }
        template<typename _Ret, typename _Tp>
        inline auto mem_fun_ref(_Ret (_Tp::*__f)() const) { return std::mem_fn(__f); }

        // 1-argument versions (This fixes the G4INCLCDPP error)
        template<typename _Ret, typename _Tp, typename _Arg>
        inline auto mem_fun(_Ret (_Tp::*__f)(_Arg)) { return std::mem_fn(__f); }
        template<typename _Ret, typename _Tp, typename _Arg>
        inline auto mem_fun_ref(_Ret (_Tp::*__f)(_Arg)) { return std::mem_fn(__f); }
        template<typename _Ret, typename _Tp, typename _Arg>
        inline auto mem_fun(_Ret (_Tp::*__f)(_Arg) const) { return std::mem_fn(__f); }
        template<typename _Ret, typename _Tp, typename _Arg>
        inline auto mem_fun_ref(_Ret (_Tp::*__f)(_Arg) const) { return std::mem_fn(__f); }

        // 4. Bridge random_shuffle
        template<typename _RAI>
        inline void random_shuffle(_RAI __first, _RAI __last) {
          std::random_device __rd; std::mt19937 __g(__rd());
          std::shuffle(__first, __last, __g);
        }
        template<typename _RAI, typename _RNG>
        inline void random_shuffle(_RAI __first, _RAI __last, _RNG&&) {
          std::random_device __rd; std::mt19937 __g(__rd());
          std::shuffle(__first, __last, __g);
        }

        // 5. Add ptr_fun
        template<typename _Arg, typename _Result>
        inline auto ptr_fun(_Result (*__f)(_Arg)) { return std::function<_Result(_Arg)>(__f); }
        template<typename _Arg1, typename _Arg2, typename _Result>
        inline auto ptr_fun(_Result (*__f)(_Arg1, _Arg2)) { return std::function<_Result(_Arg1, _Arg2)>(__f); }
      }
      #endif
      #endif
    EOS

      args << "-DCMAKE_CXX_FLAGS=-include #{polyfill_path}"

      args << "-DGEANT4_USE_QT=ON" if build.with? "qt"
      args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
      args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"
      args << "-DGEANT4_USE_USOLIDS=ON" if build.with? "usolids"
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"

    end
      (include/"Geant4").install polyfill_path
  end

  def post_install
    resources.each do |r|
      (share/"Geant4-#{version}/data/#{r.name}#{r.version}").install r
    end
  end

  test do
    system "cmake", share/"Geant4-#{version}/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<~EOS
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    system "/bin/bash", "test.sh"
  end
end