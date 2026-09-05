# Test a client project.
cd test
mkdir build
cd build
cmake .. -LAH \
  -DCMAKE_PREFIX_PATH="$PREFIX" \
  -DCMAKE_BUILD_TYPE=Release
make
./mysimbodyexe

# Exercise the installed visualizer on native Linux. The Xvfb package is
# supplied by yum_requirements.txt in conda-forge's Linux build container.
if [ "$(uname -s)" = "Linux" ] && [ "$(uname -m)" = "x86_64" ]; then
  # The GUI is a separate process that can outlive its test client. Give the
  # pair its own process group so it is always cleaned up after the result.
  LIBGL_ALWAYS_SOFTWARE=1 xvfb-run -a \
    -s "-screen 0 1280x1024x24 +extension GLX" \
    timeout 60s bash -c '
      setsid ./visualizer_menu_race &
      test_pid=$!
      trap '\''kill -- -"${test_pid}" 2>/dev/null || true'\'' EXIT INT TERM
      wait "${test_pid}"
    '
fi
