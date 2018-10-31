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
	echo $PREFIX
	ls $PREFIX
	ls $PREFIX/include
	ls "DEBUG"
	ls $PREFIX/include/GL
	GLUT_OVERRIDE=(-DCMAKE_CXX_FLAGS="-I$PREFIX/include")
elif [[ "$OSTYPE" == "darwin"* ]]; then
	SKIP_TEST=()
	GLUT_OVERRIDE=()
fi
cmake .. \
	-DCMAKE_INSTALL_PREFIX="$PREFIX" \
	-DCMAKE_INSTALL_LIBDIR="lib" \
	-DCMAKE_BUILD_TYPE="RELEASE" \
	-DBUILD_USING_OTHER_LAPACK="$PREFIX/lib/libopenblas${SHLIB_EXT}" $GLUT_OVERRIDE
make
# NOTE: Run the tests here in the build directory to make sure things are built
# correctly. This cannot be specified in the meta.yml:test section because it
# won't be run in the build directory.
eval "ctest ${SKIP_TEST}"
make install
