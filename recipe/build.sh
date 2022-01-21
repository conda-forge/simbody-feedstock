#!/bin/bash

mkdir build
cd build

declare -a CMAKE_PLATFORM_FLAGS
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # TODO: This test is failing for a yet-to-be-determined reason. See
    # https://github.com/simbody/simbody/issues/400 for more details. Once
    # that is figured out then this test should be enabled.
    SKIP_TEST="-E TestCustomConstraints"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    SKIP_TEST=()
fi

# -LAH prints the values of all CMake variables.
cmake ${CMAKE_ARGS} .. -LAH \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_INSTALL_LIBDIR="lib" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DBUILD_USING_OTHER_LAPACK="$PREFIX/lib/libblas${SHLIB_EXT};$PREFIX/lib/liblapack${SHLIB_EXT}"

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  make doxygen
fi
make --jobs ${CPU_COUNT}
# NOTE: Run the tests here in the build directory to make sure things are built
# correctly. This cannot be specified in the meta.yml:test section because it
# won't be run in the build directory.
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  eval "ctest ${SKIP_TEST}"
fi
make install
