package: defaults-o2-dev-fairroot
version: v1
env:
  CXXFLAGS: "-fPIC -O2 -std=c++14"
  CFLAGS: "-fPIC -O2"
  CMAKE_BUILD_TYPE: "RELWITHDEBINFO"
disable:
  - AliEn-Runtime
  - AliRoot
overrides:
  autotools:
    tag: v1.5.0
  boost:
    tag: "v1.64.0-alice1"
    requires:
      - "GCC-Toolchain:(?!osx)"
      - Python
    prefer_system_check: |
      printf "#include \"boost/version.hpp\"\n# if (BOOST_VERSION < 106400 || BOOST_VERSION > 106499)\n#error \"Cannot use system's boost: boost 1.64 required.\"\n#endif\nint main(){}" | gcc -I$(brew --prefix boost)/include -xc++ - -o /dev/null
  GCC-Toolchain:
    tag: v6.2.0-alice1
    prefer_system_check: |
      set -e
      which gfortran || { echo "gfortran missing"; exit 1; }
      which cc && test -f $(dirname $(which cc))/c++ && printf "#define GCCVER ((__GNUC__ << 16)+(__GNUC_MINOR__ << 8)+(__GNUC_PATCHLEVEL__))\n#if (GCCVER < 0x060200)\n#error \"System's GCC cannot be used: we need at least GCC 6.X. We are going to compile our own version.\"\n#endif\n" | cc -xc++ - -c -o /dev/null
  ROOT:
    version: "v6-10-06+git_%(short_hash)s"
    tag: "c54db1c10b19b05f157dc44078b45edd9f38c741"
    source: https://github.com/root-mirror/root
    requires:
      - GSL
      - opengl:(?!osx)
      - Xdevel:(?!osx)
      - FreeType:(?!osx)
      - Python-modules
      - libxml2
      - "GCC-Toolchain:(?!osx)"
  GSL:
    prefer_system_check: |
      printf "#include \"gsl/gsl_version.h\"\n#define GSL_V GSL_MAJOR_VERSION * 100 + GSL_MINOR_VERSION\n# if (GSL_V < 116)\n#error \"Cannot use system's gsl. Notice we only support versions from 1.16 (included)\"\n#endif\nint main(){}" | gcc  -I$(brew --prefix gsl)/include -xc++ - -o /dev/null
  protobuf:
    version: "%(tag_basename)s"
    tag: "v3.0.2"
  O2:
    version: "%(short_hash)s%(defaults_upper)s"
  CMake:
    version: "%(tag_basename)s"
    tag: "v3.9.4"
    prefer_system_check: |
      which cmake && case `cmake --version | sed -e 's/.* //' | cut -d. -f1,2,3 | head -n1` in [0-2]*|3.[0-8].*|3.9.[0-3]) exit 1 ;; esac
  FairRoot:
    version: dev
    tag: dev
    source: https://github.com/FairRootGroup/FairRoot
---
# This file is included in any build recipe and it's only used to set
# environment variables. Which file to actually include can be defined by the
# "--defaults" option of alibuild.
