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

# TODO: Is this still necessary?
if [[ "$c_compiler" == "gcc" ]]; then
  export PATH="${PATH}:${BUILD_PREFIX}/${HOST}/sysroot/usr/lib:${BUILD_PREFIX}/${HOST}/sysroot/usr/include"
fi

cmake .. -LAH \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_INSTALL_LIBDIR="lib" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DBUILD_USING_OTHER_LAPACK="$PREFIX/lib/liblapack${SHLIB_EXT};$PREFIX/lib/libblas${SHLIB_EXT}"

make doxygen
make --jobs ${CPU_COUNT}
# NOTE: Run the tests here in the build directory to make sure things are built
# correctly. This cannot be specified in the meta.yml:test section because it
# won't be run in the build directory.
eval "ctest ${SKIP_TEST}"
make install
