cmake_minimum_required(VERSION 2.8)
project(mysimbodyexe)
find_package(Simbody REQUIRED)
add_executable(mysimbodyexe mysimbodyexe.cpp)
target_link_libraries(mysimbodyexe ${Simbody_LIBRARIES})

