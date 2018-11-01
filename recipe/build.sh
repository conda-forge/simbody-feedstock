#!/bin/bash

# FIXME: This is a hack to make sure the environment is activated.
# The reason this is required is due to the conda-build issue
# mentioned below.
#
# https://github.com/conda/conda-build/issues/910
source activate "${CONDA_DEFAULT_ENV}"

mkdir build
cd build
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	# TODO: This test is failing for a yet-to-be-determined reason. See
	# https://github.com/simbody/simbody/issues/400 for more details. Once
	# that is figured out then this test should be enabled.
	SKIP_TEST="-E TestCustomConstraints"
	# The CMAKE_CXX_FLAGS is required due to this bug in Simbody:
	# https://github.com/simbody/simbody/issues/511
	GLUT_OVERRIDE=(-DCMAKE_CXX_FLAGS="-I$PREFIX/include")
    CMAKE_PLATFORM_FLAGS=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
elif [[ "$OSTYPE" == "darwin"* ]]; then
	SKIP_TEST=()
	GLUT_OVERRIDE=()
    CMAKE_PLATFORM_FLAGS=()
fi

# https://github.com/AnacondaRecipes/freeglut-feedstock/blob/master/recipe/build.sh

echo "DEBUG PREFIX"
echo "$PREFIX"
ls $PREFIX/lib
# cp /usr/lib64/libGL.so $PREFIX/lib
cmake .. \
	-DCMAKE_INSTALL_PREFIX="$PREFIX" \
	-DCMAKE_INSTALL_LIBDIR="lib" \
	-DCMAKE_BUILD_TYPE="RELEASE" \
    -DCMAKE_VERBOSE_MAKEFILE=on \
    $CMAKE_PLATFORM_FLAGS \
	-DBUILD_USING_OTHER_LAPACK="$PREFIX/lib/libopenblas${SHLIB_EXT}" $GLUT_OVERRIDE
# make doxygen
make --jobs ${CPU_COUNT} simbody-visualizer
# NOTE: Run the tests here in the build directory to make sure things are built
# correctly. This cannot be specified in the meta.yml:test section because it
# won't be run in the build directory.
eval "ctest ${SKIP_TEST}"
make install
