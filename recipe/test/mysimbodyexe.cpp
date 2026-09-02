// Based on PendulumNoViz.cpp
#include "Simbody.h"

using namespace SimTK;

int main() {
    try {
        // Simbody's public inline matrix API calls LAPACK directly. Keep this
        // here so the exported CMake target must propagate BLAS/LAPACK.
        double value = 1.0;
        int pivot = 0;
        int info = 0;
        Lapack::getrf<double>(1, 1, &value, 1, &pivot, info);
        if (info != 0 || pivot != 1) {
            return 1;
        }

        MultibodySystem system;
        SimbodyMatterSubsystem matter(system);
        GeneralForceSubsystem forces(system);
        Force::UniformGravity gravity(forces, matter, Vec3(0, -9.8, 0));
        Body::Rigid body(MassProperties(1.0, Vec3(0), Inertia(1)));
        MobilizedBody::Pin pendulum(matter.Ground(), Transform(Vec3(0)),
		    body, Transform(Vec3(0, 1, 0)));
        system.realizeTopology();
        State state = system.getDefaultState();
        Array_<ForceIndex> noForces;
        Vector_<SpatialVec> bodyForces;
        Vector mobilityForces;
        forces.calcForceContributionsSum(
                state, noForces, bodyForces, mobilityForces);
        if (bodyForces.size() != matter.getNumBodies() ||
                mobilityForces.size() != matter.getNumMobilities()) {
            return 1;
        }
        pendulum.setOneU(state, 0, 1.0);
        RungeKuttaMersonIntegrator integ(system);
        TimeStepper stepper(system, integ);
        stepper.initialize(state);
        stepper.stepTo(1.5);
    } catch (const std::exception& e) {
        std::cout << "Exception thrown: " << e.what() << std::endl;
        exit(1);
    } catch (...) {
        std::cout << "Unknown exception thrown." << std::endl;
        exit(1);
    }
    std::cout << "Test succeeded." << std::endl;
    return 0;
}
