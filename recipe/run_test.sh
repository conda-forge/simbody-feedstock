# Test a client project.
cd test
mkdir build
cd build
cmake .. -LAH \
  -DCMAKE_PREFIX_PATH="$PREFIX" \
  -DCMAKE_BUILD_TYPE=Release
make
./mysimbodyexe

