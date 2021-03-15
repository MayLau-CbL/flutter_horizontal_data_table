import 'dart:math' as math;
import 'package:flutter/material.dart';

class NonBounceBackScrollPhysics extends ScrollPhysics {
  const NonBounceBackScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  NonBounceBackScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NonBounceBackScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (position.outOfRange) {
      return null;
    }
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity: velocity,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  double get minFlingVelocity => 50.0 * 2.0;

  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(),
            40000.0);
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}
