
del /f Platform\Windows\lib_x64\*.dll
del /f Platform\Windows\lib_x64\*.lib
copy %LIBRARY_LIB%\lapack.lib Platform\Windows\lib_x64\lapack.lib
copy %LIBRARY_LIB%\blas.lib Platform\Windows\lib_x64\blas.lib
echo "LIBRARY_LIB DEBUG"
dir %LIBRARY_LIB%
echo "LIBRARY_BIN DEBUG"
dir %LIBRARY_BIN%

mkdir build
cd build
REM -LAH prints the values of all CMake variables.
cmake -G Ninja .. -LAH ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DBUILD_USING_OTHER_LAPACK="%LIBRARY_LIB%/lapack.lib;%LIBRARY_LIB%/blas.lib"

ninja doxygen
ninja
REM NOTE: Run the tests here in the build directory to make sure things are
REM built correctly. This cannot be specified in the meta.yml:test section
REM because it won't be run in the build directory.
ctest --output-on-failure
ninja install
