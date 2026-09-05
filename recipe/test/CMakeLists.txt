cmake_minimum_required(VERSION 3.21)
project(mysimbodyexe)
find_package(Simbody REQUIRED)
add_executable(mysimbodyexe mysimbodyexe.cpp)
target_link_libraries(mysimbodyexe ${Simbody_LIBRARIES})

add_executable(cablespan_via_point cablespan_via_point.cpp)
target_compile_features(cablespan_via_point PRIVATE cxx_std_11)
target_link_libraries(cablespan_via_point ${Simbody_LIBRARIES})
