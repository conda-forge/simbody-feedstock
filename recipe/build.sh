#!/bin/bash

mkdir build
cd build

# -LAH prints the values of all CMake variables.
cmake ${CMAKE_ARGS} .. -LAH \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_INSTALL_LIBDIR="lib" \
    -DCMAKE_BUILD_TYPE="Release"

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  make doxygen
fi
make --jobs ${CPU_COUNT}
# NOTE: Run the tests here in the build directory to make sure things are built
# correctly. This cannot be specified in the meta.yml:test section because it
# won't be run in the build directory.
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  ctest --output-on-failure
fi
make install
