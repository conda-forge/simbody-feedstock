cmake_minimum_required(VERSION 3.21)
project(mysimbodyexe)
find_package(Simbody REQUIRED)
add_executable(mysimbodyexe mysimbodyexe.cpp)
target_link_libraries(mysimbodyexe ${Simbody_LIBRARIES})

add_executable(visualizer_menu_race visualizer_menu_race.cpp)
target_compile_features(visualizer_menu_race PRIVATE cxx_std_11)
target_link_libraries(visualizer_menu_race ${Simbody_LIBRARIES})
