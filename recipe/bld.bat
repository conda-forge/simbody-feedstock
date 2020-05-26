
REM Do not overwrite Conda's libraries with Simbody's vendored libraries.
del /f Platform\Windows\lib_x64\*.dll
del /f Platform\Windows\lib_x64\*.lib

mkdir build
cd build
REM -LAH prints the values of all CMake variables.
cmake -G Ninja .. -LAH ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DBUILD_USING_OTHER_LAPACK="%LIBRARY_LIB%/openblas.lib"

ninja doxygen
ninja
REM Run the tests here in the build directory to make sure things are
REM built correctly. This cannot be specified in the meta.yml:test section
REM because it won't be run in the build directory.
ctest --output-on-failure
ninja install
