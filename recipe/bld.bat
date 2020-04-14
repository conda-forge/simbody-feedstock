
del /f Platform\Windows\lib_x64\*.dll
del /f Platform\Windows\lib_x64\*.lib
cp %LIBRARY_LIB%\lapack.lib Platform\Windows\lib_x64\lapack.lib

mkdir build
cd build
cmake -G "%CMAKE_GENERATOR%" ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DBUILD_USING_OTHER_LAPACK="%LIBRARY_LIB%\lapack.lib;%LIBRARY_LIB%\blas.lib" ^
  ..

cmake --build . --target doxygen --config Release
cmake --build . --target install --config Release
REM NOTE: Run the tests here in the build directory to make sure things are
REM built correctly. This cannot be specified in the meta.yml:test section
REM because it won't be run in the build directory.
ctest --build-config Release --output-on-failure
