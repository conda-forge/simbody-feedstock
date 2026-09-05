#include <Simbody.h>

#include <cmath>
#include <iostream>

int main() {
    try {
        using namespace SimTK;

        MultibodySystem system;
        SimbodyMatterSubsystem matter(system);
        CableSubsystem cables(system);
        Body::Rigid body(MassProperties(1.0, Vec3(0), Inertia(1)));

        MobilizedBody::Translation origin(
                matter.Ground(), Vec3(0), body, Transform());
        MobilizedBody::Translation termination(
                matter.Ground(), Transform(Vec3(-4, 0, 0)),
                body, Transform());
        MobilizedBody::Translation viaPoint(
                matter.Ground(), Transform(Vec3(0, 1, 0)),
                body, Transform());

        CableSpan cable(
                cables, origin, Vec3(0), termination, Vec3(0));
        const CableSpanViaPointIndex viaPointIndex =
                cable.addViaPoint(viaPoint, Vec3(0));

        system.realizeTopology();
        State state = system.getDefaultState();
        system.realize(state, Stage::Report);

        const Real expectedLength = 1 + std::sqrt(17.0);
        const Real actualLength = cable.calcLength(state);
        const Vec3 expectedIncoming(0, 1, 0);
        const Vec3 expectedOutgoing = Vec3(-4, -1, 0) / std::sqrt(17.0);
        if (cable.getNumViaPoints() != 1 ||
                std::abs(actualLength - expectedLength) > 1e-10 ||
                (cable.calcOriginTangentDirection(state) -
                        expectedIncoming).norm() > 1e-10 ||
                (cable.calcViaPointIncomingTangentDirection(
                        state, viaPointIndex) - expectedIncoming).norm() > 1e-10 ||
                (cable.calcViaPointOutgoingTangentDirection(
                        state, viaPointIndex) - expectedOutgoing).norm() > 1e-10 ||
                (cable.calcTerminationTangentDirection(state) -
                        expectedOutgoing).norm() > 1e-10) {
            std::cerr << "Unexpected CableSpan via-point path: count="
                      << cable.getNumViaPoints() << ", length="
                      << actualLength << ", expected=" << expectedLength
                      << std::endl;
            return 1;
        }
    } catch (const std::exception& exception) {
        std::cerr << exception.what() << std::endl;
        return 2;
    }

    std::cout << "CableSpan via-point test succeeded." << std::endl;
    return 0;
}
