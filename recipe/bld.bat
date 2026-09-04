
REM Do not overwrite Conda's libraries with Simbody's vendored libraries.
del /f Platform\Windows\lib_x64\*.dll
del /f Platform\Windows\lib_x64\*.lib

mkdir build
cd build
REM -LAH prints the values of all CMake variables.
REM A bare BLAS library name keeps installed CMake metadata relocatable.
cmake -G Ninja .. -LAH ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DWINDOWS_USE_EXTERNAL_LIBS=ON ^
  -DBUILD_USING_OTHER_LAPACK=openblas
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

ninja doxygen
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
ninja
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
REM Run the tests here in the build directory to make sure things are
REM built correctly. This cannot be specified in the meta.yml:test section
REM because it won't be run in the build directory.
ctest --output-on-failure
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
ninja install
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
