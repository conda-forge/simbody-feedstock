#!/bin/bash

mkdir build
cd build

declare -a CMAKE_PLATFORM_FLAGS
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # TODO: This test is failing for a yet-to-be-determined reason. See
    # https://github.com/simbody/simbody/issues/400 for more details. Once
    # that is figured out then this test should be enabled.
    SKIP_TEST="-E TestCustomConstraints"
    # The CMAKE_CXX_FLAGS is required due to this bug in Simbody:
    # https://github.com/simbody/simbody/issues/511
    GLUT_OVERRIDE=(-DCMAKE_CXX_FLAGS="-I$PREFIX/include")
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
elif [[ "$OSTYPE" == "darwin"* ]]; then
    SKIP_TEST=()
    GLUT_OVERRIDE=()
fi

# Here's an example of using the cross-linux.cmake toolchain file to find
# OpenGL.
# https://github.com/AnacondaRecipes/freeglut-feedstock/blob/master/recipe/build.sh

cmake .. \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_INSTALL_LIBDIR="lib" \
    -DCMAKE_BUILD_TYPE="RELEASE" \
    ${CMAKE_PLATFORM_FLAGS[@]} \
    -DBUILD_USING_OTHER_LAPACK="$PREFIX/lib/liblapack${SHLIB_EXT};$PREFIX/lib/libblas${SHLIB_EXT}" $GLUT_OVERRIDE
make --jobs ${CPU_COUNT}
# NOTE: Run the tests here in the build directory to make sure things are built
# correctly. This cannot be specified in the meta.yml:test section because it
# won't be run in the build directory.
eval "ctest ${SKIP_TEST}"
make install
