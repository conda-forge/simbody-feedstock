
del /f Platform\Windows\lib_x64\*.dll
del /f Platform\Windows\lib_x64\*.lib
REM copy %LIBRARY_LIB%\lapack.lib Platform\Windows\lib_x64\lapack.lib
echo "LIBRARY_DIR DEBUG"
dir %LIBRARY_LIB%

mkdir build
cd build
cmake -G Ninja .. ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DBUILD_USING_OTHER_LAPACK="%LIBRARY_BIN%/lapack.dll;%LIBRARY_BIN%/blas.dll"

ninja doxygen
ninja
REM NOTE: Run the tests here in the build directory to make sure things are
REM built correctly. This cannot be specified in the meta.yml:test section
REM because it won't be run in the build directory.
ctest --output-on-failure
ninja install
