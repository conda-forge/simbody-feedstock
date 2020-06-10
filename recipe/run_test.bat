REM Test a client project.
REM Enter the test directory inside the recipe.
cd test
mkdir build
cd build
cmake -G Ninja .. ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_BUILD_TYPE=Release
ninja
mysimbodyexe

