use chipmunk, math

include chipmunk/chipmunk

INFINITY: extern Float

CpFloat: cover from Double extends Double

CpVect: cover from cpVect {
    x, y: extern CpFloat
}

CpMat2x2: cover from cpMat2x2 {
    // Row major [[a, b][c d]]
    a, b, c, d: extern CpFloat
}

CpTransform: cover from cpTransform {
    // (a, b) is the x basis vector.
    // (c, d) is the y basis vector.
    // (tx, ty) is the translation.
    a, b, c, d, tx, ty: extern CpFloat
}

cpTransformIdentity: extern CpTransform

CpTimestamp: cover from cpTimestamp extends UInt

cpv: extern func (x, y: CpFloat) -> CpVect
cpvzero: extern CpVect
cpvtoangle: extern func (v: CpVect) -> CpFloat
cpvforangle: extern func (angle: CpFloat) -> CpVect

cpMomentForCircle: extern func (mass: CpFloat, radius1: CpFloat, radius2: CpFloat, offset: CpVect) -> CpFloat 

cpAreaForCircle: extern func (radius1: CpFloat, radius2: CpFloat) -> CpFloat 

cpMomentForSegment: extern func (mass: CpFloat, a: CpVect, b: CpVect, radius: CpFloat) -> CpFloat

cpAreaForSegment: extern func (a: CpVect, b: CpVect, radius: CpFloat) -> CpFloat

cpMomentForPoly: extern func (mass: CpFloat, numVerts: Int, verts: CpVect*, offset: CpVect, radius: CpFloat) -> CpFloat

cpAreaForPoly: extern func (numVerts: Int, verts: CpVect*) -> CpFloat

cpCentroidForPoly: extern func (numVerts: Int, verts: CpVect*) -> CpVect

cpRecenterPoly: extern func (numVerts: Int, verts: CpVect*)

cpMomentForBox: extern func (mass: CpFloat, width: CpFloat, height: CpFloat) -> CpFloat

cpMomentForBox2: extern func (mass: CpFloat, box: CpBB) -> CpFloat

cpConvexHull: extern func (count: Int, verts: CpVect*, result: CpVect*, first: Int*, tolerance: CpFloat) -> Int

CpBodyType: enum {
    dynamic: extern(CP_BODY_TYPE_DYNAMIC)
    kinematic: extern(CP_BODY_TYPE_KINEMATIC)
    statik: extern(CP_BODY_TYPE_STATIC)
}

CpBody: cover from cpBody* {

    new: extern(cpBodyNew) static func (mass: CpFloat, momentum: CpFloat) -> This
    newStatic: extern(cpBodyNewStatic) static func -> This

    isStatic: func -> Bool { getType() == CpBodyType statik }

    getType: extern(cpBodyGetType) func -> CpBodyType

    free: extern(cpBodyFree) func

    getMass: extern(cpBodyGetMass) func -> CpFloat
    setMass: extern(cpBodySetMass) func (CpFloat)

    getMoment: extern(cpBodyGetMoment) func -> CpFloat
    setMoment: extern(cpBodySetMoment) func (CpFloat)

    getPosition: extern(cpBodyGetPosition) func -> CpVect
    setPosition: extern(cpBodySetPosition) func (CpVect)

    getVelocity: extern(cpBodyGetVelocity) func -> CpVect
    setVelocity: extern(cpBodySetVelocity) func (CpVect)

    getForce: extern(cpBodyGetForce) func -> CpVect
    setForce: extern(cpBodySetForce) func (CpVect)

    getAngle: extern(cpBodyGetAngle) func -> CpFloat
    setAngle: extern(cpBodySetAngle) func (CpFloat)

    getAngVel: extern(cpBodyGetAngVel) func -> CpFloat
    setAngVel: extern(cpBodySetAngVel) func (CpFloat)

    getTorque: extern(cpBodyGetTorque) func -> CpFloat
    setTorque: extern(cpBodySetTorque) func (CpFloat)

    getRot: extern(cpBodyGetRot) func -> CpVect

    getVelLimit: extern(cpBodyGetVelLimit) func -> CpFloat
    setVelLimit: extern(cpBodySetVelLimit) func (CpFloat)

    getAngVelLimit: extern(cpBodyGetAngVelLimit) func -> CpFloat
    setAngVelLimit: extern(cpBodySetAngVelLimit) func (CpFloat)

    getUserData: extern(cpBodyGetUserData) func -> Pointer
    setUserData: extern(cpBodySetUserData) func (Pointer)

    applyImpulseAtWorldPoint: extern(cpBodyApplyImpulseAtWorldPoint) func (CpVect, CpVect)
    applyImpulseAtLocalPoint: extern(cpBodyApplyImpulseAtLocalPoint) func (CpVect, CpVect)

    _eachArbiter: extern(cpBodyEachArbiter) func (callback: Pointer, data: Pointer)
    _eachArbiterThunk: static func (body: CpBody, arbiter: CpArbiter, data: Closure*) {
        f := data@ as Func (CpBody, CpArbiter)
        f(body, arbiter)
    }

    eachArbiter: func (f: Func (CpBody, CpArbiter)) {
        c := f as Closure
        _eachArbiter(_eachArbiterThunk, c&)
    }

}

CpSpace: cover from cpSpace* {

    new: static extern(cpSpaceNew) func -> This

    free: extern(cpSpaceFree) func

    getIterations: extern(cpSpaceGetIterations) func -> Int
    setIterations: extern(cpSpaceSetIterations) func (Int)

    getGravity: extern(cpSpaceGetGravity) func -> CpVect
    setGravity: extern(cpSpaceSetGravity) func (CpVect)

    getDamping: extern(cpSpaceGetDamping) func -> CpFloat
    setDamping: extern(cpSpaceSetDamping) func (CpFloat)

    getIdleSpeedThreshold: extern(cpSpaceGetIdleSpeedThreshold) func -> CpFloat
    setIdleSpeedThreshold: extern(cpSpaceSetIdleSpeedThreshold) func (CpFloat)

    getSleepTimeThreshold: extern(cpSpaceGetSleepTimeThreshold) func -> CpFloat
    setSleepTimeThreshold: extern(cpSpaceSetSleepTimeThreshold) func (CpFloat)

    getCollisionSlop: extern(cpSpaceGetCollisionSlop) func -> CpFloat
    setCollisionSlop: extern(cpSpaceSetCollisionSlop) func (CpFloat)

    getCollisionBias: extern(cpSpaceGetCollisionBias) func -> CpFloat
    setCollisionBias: extern(cpSpaceSetCollisionBias) func (CpFloat)

    getCollisionPersistence: extern(cpSpaceGetCollisionPersistence) func -> CpFloat
    setCollisionPersistence: extern(cpSpaceSetCollisionPersistence) func (CpFloat)

    getEnableContactGraph: extern(cpSpaceGetEnableContactGraph) func -> Bool
    setEnableContactGraph: extern(cpSpaceSetEnableContactGraph) func (Bool)

    getUserData: extern(cpSpaceGetUserData) func -> Pointer
    setUserData: extern(cpSpaceSetUserData) func (Pointer)

    getStaticBody: extern(cpSpaceGetStaticBody) func -> CpBody

    getCurrentTimeStep: extern(cpSpaceGetCurrentTimeStep) func -> CpFloat

    addBody: extern(cpSpaceAddBody) func (body: CpBody) -> CpBody
    removeBody: extern(cpSpaceRemoveBody) func (constraint: CpBody)

    addShape: extern(cpSpaceAddShape) func (shape: CpShape) -> CpShape
    removeShape: extern(cpSpaceRemoveShape) func (constraint: CpShape)

    reindexShape: extern(cpSpaceReindexShape) func (shape: CpShape)

    addConstraint: extern(cpSpaceAddConstraint) func (constraint: CpConstraint) -> CpConstraint
    removeConstraint: extern(cpSpaceRemoveConstraint) func (constraint: CpConstraint)

    addCollisionHandler: func (type1: CpCollisionType, type2: CpCollisionType, handler: CollisionHandler) {
        cph := cpSpaceAddCollisionHandler(this, type1, type2)
        cph@ beginFunc = collisionBeginFuncThunk
        cph@ preSolveFunc = collisionPreSolveFuncThunk
        cph@ postSolveFunc = collisionPostSolveFuncThunk
        cph@ separateFunc = collisionSeparateFuncThunk
        cph@ userData = handler
    }

    shapeQuery: extern(cpSpaceShapeQuery) func (shape: CpShape, callback: Pointer, userData: Pointer) -> Bool

    step: extern(cpSpaceStep) func (timeStep: CpFloat)

}

cpSpaceAddCollisionHandler: extern func (CpSpace, CpCollisionType, CpCollisionType) -> CpCollisionHandler*

CpArbiter: cover from cpArbiter* {

    getShapes: extern(cpArbiterGetShapes) func (CpShape*, CpShape*)
    getBodies: extern(cpArbiterGetBodies) func (CpBody*, CpBody*)

    getRestitution: extern(cpArbiterGetRestitution) func -> CpFloat
    setRestitution: extern(cpArbiterSetRestitution) func (CpFloat)

    getFriction: extern(cpArbiterGetFriction) func -> CpFloat
    setFriction: extern(cpArbiterSetFriction) func (CpFloat)

    getUserData: extern(cpArbiterGetUserData) func -> Pointer
    setUserData: extern(cpArbiterSetUserData) func (Pointer)

    getContactPointSet: extern(cpArbiterGetContactPointSet) func -> CpContactPointSet

}

CpContactPointSet: cover from cpContactPointSet {
    count: Int
    points: CpContactPoint*
}

CpContactPoint: cover {
    pointA: CpVect
    pointB: CpVect
    distance: Double
}

CpCollisionHandler: cover from cpCollisionHandler {
    typeA, typeB: SizeT
    beginFunc: Pointer
    preSolveFunc: Pointer
    postSolveFunc: Pointer
    separateFunc: Pointer
    userData: Pointer
}

CollisionHandler: class {

    begin: func (arb: CpArbiter, space: CpSpace) -> Bool {
        // overload at will!
        true
    }

    preSolve: func (arb: CpArbiter, space: CpSpace) -> Bool {
        // overload at will!
        true
    }

    postSolve: func (arb: CpArbiter, space: CpSpace) {
        // overload at will!
    }

    separate: func (arb: CpArbiter, space: CpSpace) {
        // overload at will!
    }
    
}

collisionBeginFuncThunk: func (arb: CpArbiter, space: CpSpace, ch: CollisionHandler) -> Int {
    ch begin(arb, space) ? 1 : 0
}

collisionPreSolveFuncThunk: func (arb: CpArbiter, space: CpSpace, ch: CollisionHandler) -> Int {
    ch preSolve(arb, space) ? 1 : 0
}

collisionPostSolveFuncThunk: func (arb: CpArbiter, space: CpSpace, ch: CollisionHandler) {
    ch postSolve(arb, space)
}

collisionSeparateFuncThunk: func (arb: CpArbiter, space: CpSpace, ch: CollisionHandler) {
    ch separate(arb, space)
}

CpBB: cover from cpBB {
    l, b, r, t: extern CpFloat

    new: extern(cpBBNew) static func (l: CpFloat, b: CpFloat, r: CpFloat, t: CpFloat) -> This

}

CpCollisionType: cover from SizeT extends SizeT {

}

CpGroup: cover from SizeT extends SizeT {

}

CpBitmask: cover from UInt extends UInt {

}

CpShapeFilter: cover from cpShapeFilter {
	// Two objects with the same non-zero group value do not collide.
	// This is generally used to group objects in a composite object together to disable self collisions.
    group: CpGroup

	// A bitmask of user definable categories that this object belongs to.
	// The category/mask combinations of both objects in a collision must agree for a collision to occur.
    categories: CpBitmask

	// A bitmask of user definable category types that this object object collides with.
	// The category/mask combinations of both objects in a collision must agree for a collision to occur.
    mask: CpBitmask
}

CpShape: cover from cpShape* {

    free: extern(cpShapeFree) func

    getBB: extern(cpShapeGetBB) func -> CpBB

    getSensor: extern(cpShapeGetSensor) func -> Bool
    setSensor: extern(cpShapeSetSensor) func (Bool)

    getBody: extern(cpShapeGetBody) func -> CpBody
    setBody: extern(cpShapeSetBody) func (body: CpBody)

    getElasticity: extern(cpShapeGetElasticity) func -> CpFloat
    setElasticity: extern(cpShapeSetElasticity) func (CpFloat)

    getFriction: extern(cpShapeGetFriction) func -> CpFloat
    setFriction: extern(cpShapeSetFriction) func (CpFloat)

    getSurfaceVelocity: extern(cpShapeGetSurfaceVelocity) func -> CpVect
    setSurfaceVelocity: extern(cpShapeSetSurfaceVelocity) func (CpVect)

    getUserData: extern(cpShapeGetUserData) func -> Pointer
    setUserData: extern(cpShapeSetUserData) func (Pointer)

    userDataIs?: func (c: Class) -> Bool {
        obj: Object = getUserData()
        return (obj != null && obj instanceOf?(c))
    }

    getCollisionType: extern(cpShapeGetCollisionType) func -> CpCollisionType
    setCollisionType: extern(cpShapeSetCollisionType) func (CpCollisionType)

    getFilter: extern(cpShapeGetFilter) func -> CpShapeFilter
    setFilter: extern(cpShapeSetFilter) func (CpShapeFilter)

    update: extern(cpShapeUpdate) func (pos: CpVect, rot: CpVect)

}

CpSegmentShape: cover from cpSegmentShape* extends CpShape {

    new: static extern(cpSegmentShapeNew) func (body: CpBody, a: CpVect, b: CpVect, radius: CpFloat) -> This

    setNeighbors: extern(cpSegmentShapeSetNeighbors) func (a: CpVect, b: CpVect)

    getA: extern(cpSegmentShapeGetA) func -> CpVect
    getB: extern(cpSegmentShapeGetB) func -> CpVect

}

CpCircleShape: cover from cpCircleShape* extends CpShape {

    new: static extern(cpCircleShapeNew) func (body: CpBody, radius: CpFloat, offset: CpVect) -> This

    getOffset: extern(cpCircleShapeGetOffset) func -> CpVect

    getRadius: extern(cpCircleShapeGetRadius) func -> CpFloat

}

CpBoxShape: cover from cpPolyShape* extends CpShape {

    new: static extern(cpBoxShapeNew) func (body: CpBody, width: CpFloat, height: CpFloat, radius: CpFloat) -> This
    new: static extern(cpBoxShapeNew2) func ~fromBB (body: CpBody, box: CpBB, radius: CpFloat) -> This

}

CpPolyShape: cover from cpPolyShape* extends CpShape {

    new: static extern(cpPolyShapeNew) func (body: CpBody, numVerts: Int, verts: CpVect*, transform: CpTransform, radius: CpFloat) -> This

}

CpConstraint: cover from cpConstraint* {

    free: extern(cpConstraintFree) func

    newPivot: static extern(cpPivotJointNew) func (a: CpBody, b: CpBody, pivot: CpVect) -> This

    setMaxBias: extern(cpConstraintSetMaxBias) func (value: CpFloat)
    getMaxBias: extern(cpConstraintGetMaxBias) func -> CpFloat

    setErrorBias: extern(cpConstraintSetErrorBias) func (value: CpFloat)
    getErrorBias: extern(cpConstraintGetErrorBias) func -> CpFloat

    setMaxForce: extern(cpConstraintSetMaxForce) func (value: CpFloat)
    getMaxForce: extern(cpConstraintGetMaxForce) func -> CpFloat

}

CpPinJoint: cover from cpPinJoint* extends CpConstraint {

    new: static extern(cpPinJointNew) func (a: CpBody, b: CpBody, anchr1: CpVect, anchr2: CpVect) -> This

    setDist: extern(cpPinJointSetDist) func (dist: CpFloat)
    getDist: extern(cpPinJointGetDist) func -> CpFloat

}

CpDampedSpring: cover from cpDampedSpring* extends CpConstraint {

    new: static extern(cpDampedSpringNew) func (a: CpBody, b: CpBody, anchr1: CpVect, anchr2: CpVect,
        restLength: CpFloat, stiffness: CpFloat, damping: CpFloat) -> This

    setRestLength: extern(cpDampedSpringSetRestLength) func (CpFloat)
    getRestLength: extern(cpDampedSpringSetRestLength) func -> CpFloat

    setStiffness: extern(cpDampedSpringSetStiffness) func (CpFloat)
    getStiffness: extern(cpDampedSpringSetStiffness) func -> CpFloat

    setDamping: extern(cpDampedSpringSetDamping) func (CpFloat)
    getDamping: extern(cpDampedSpringSetDamping) func -> CpFloat

}

CpRotaryLimitJoint: cover from cpRotaryLimitJoint* extends CpConstraint {

    new: static extern(cpRotaryLimitJointNew) func (a: CpBody, b: CpBody, min: CpFloat, max: CpFloat) -> This

    setMin: extern(cpRotaryLimitJointSetMin) func (val: CpFloat)
    getMin: extern(cpRotaryLimitJointGetMin) func -> CpFloat

    setMax: extern(cpRotaryLimitJointSetMax) func (val: CpFloat)
    getMax: extern(cpRotaryLimitJointGetMax) func -> CpFloat

}

