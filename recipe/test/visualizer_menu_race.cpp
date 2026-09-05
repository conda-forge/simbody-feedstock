#include <Simbody.h>

#include <chrono>
#include <csignal>
#include <iostream>
#include <string>
#include <thread>
#include <utility>

int main() {
#ifndef _WIN32
    // Let Simbody turn a dead visualizer's EPIPE into an exception that makes
    // this test fail with useful diagnostics rather than terminating silently.
    std::signal(SIGPIPE, SIG_IGN);
#endif

    try {
        SimTK::MultibodySystem system;
        SimTK::SimbodyMatterSubsystem matter(system);
        SimTK::Visualizer visualizer(system);
        visualizer.setShutdownWhenDestructed(true);
        SimTK::State state = system.realizeTopology();

        visualizer.addSlider("Speed", 2000, 0.0, 1.0, 0.5);
        visualizer.addSlider("Time", 2001, 0.0, 1.0, 0.0);

        SimTK::Array_<std::pair<SimTK::String, int>> items;
        items.push_back(std::make_pair(SimTK::String("item"), 1));

        // Simbody 3.8's renderer iterates this vector without the scene lock.
        // Reallocation while the visualizer process is drawing can crash it.
        for (int i = 0; i < 64; ++i) {
            visualizer.addMenu(
                    SimTK::String(std::string("menu") + std::to_string(i)),
                    i, items);
            if (i % 4 == 0) {
                visualizer.drawFrameNow(state);
            }
        }
        visualizer.drawFrameNow(state);
        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        visualizer.shutdown();
        std::this_thread::sleep_for(std::chrono::milliseconds(500));
    } catch (const std::exception& exception) {
        std::cerr << exception.what() << std::endl;
        return 2;
    }

    return 0;
}
