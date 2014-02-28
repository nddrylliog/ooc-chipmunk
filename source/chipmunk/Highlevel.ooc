
use chipmunk
import chipmunk

ShapePair: cover {
    a, b: Shape
}

BodyPair: cover {
    a, b: Body
}

Arbiter: class {

    cpArbiter: CpArbiter

    init: func {}

    contactCount: Int {
        get { cpArbiter getContactPointSet() count }
    }

    getContact: func (index: Int) -> CpContactPoint {
        cpSet := cpArbiter getContactPointSet()
        (cpSet points[index] point, cpSet points[index] normal, cpSet points[index] dist) as CpContactPoint
    }

    elasticity: Double {
        get { cpArbiter getElasticity() }
        set (f) { cpArbiter setElasticity(f) }
    }

    friction: Double {
        get { cpArbiter getFriction() }
        set (f) { cpArbiter setFriction(f) }
    }

    shapes: ShapePair {
        get {
            a, b: CpShape
            cpArbiter getShapes(a&, b&)
            ash := a getUserData() as Shape
            bsh := b getUserData() as Shape
            (ash, bsh) as ShapePair
        }
    }

    bodies: BodyPair {
        get {
            a, b: CpBody
            cpArbiter getBodies(a&, b&)
            abo := a getUserData() as Body
            bbo := b getUserData() as Body
            (abo, bbo) as BodyPair
        }
    }

}

Space: class {

    cpSpace: CpSpace
    staticBody: Body
    arbiter := Arbiter new()

    userData: Pointer {
        get { cpSpace getUserData() }
        set (p) { cpSpace setUserData(p) }
    }

    iterations: Int {
        get { cpSpace getIterations() }
        set(i) { cpSpace setIterations(i) }
    }

    gravity: CpVect {
        get { cpSpace getGravity() }
        set(g) { cpSpace setGravity(g) }
    }

    collisionBias: CpFloat {
        get { cpSpace getCollisionBias() }
        set(f) { cpSpace setCollisionBias(f) }
    }

    collisionPersistence: CpFloat {
        get { cpSpace getCollisionPersistence() }
        set(f) { cpSpace setCollisionPersistence(f) }
    }

    collisionSlop: CpFloat {
        get { cpSpace getCollisionSlop() }
        set(f) { cpSpace setCollisionSlop(f) }
    }

    currentTimeStep: Double {
        get { cpSpace getCurrentTimeStep() }
    }

    init: func {
        cpSpace = CpSpace new()
        userData = this
        staticBody = Body new(cpSpace getStaticBody())
    }

    free: func {
        cpSpace free()
    }

    step: func (timeStep: Double) {
        cpSpace step(timeStep)
    }

    addBody: func (body: Body) -> Body {
        cpSpace addBody(body cpBody)
        body
    }

    removeBody: func (body: Body) {
        cpSpace removeBody(body cpBody)
    }

    addShape: func (shape: Shape) -> Shape {
        cpSpace addShape(shape cpShape)
        shape
    }

    addStaticShape: func (shape: Shape) -> Shape {
        cpSpace addStaticShape(shape cpShape)
        shape
    }

    removeShape: func (shape: Shape) {
        cpSpace removeShape(shape cpShape)
    }

    addCollisionHandler: func (type1: UInt, type2: UInt, handler: CpCollisionHandler) {
        cpSpace addCollisionHandler(type1, type2, handler)
    }

    removeCollisionHandler: func (type1: UInt, type2: UInt) {
        cpSpace removeCollisionHandler(type1, type2)
    }

}

HlCollisionHandler: class extends CpCollisionHandler {

    arbiter := Arbiter new()

    onBegin: Func (Arbiter) -> Bool
    onPreSolve: Func (Arbiter) -> Bool
    onPostSolve: Func (Arbiter)
    onSeparate: Func (Arbiter)

    init: func {}

    begin: func (cpArbiter: CpArbiter, space: CpSpace) -> Bool {
        c := onBegin as Closure
        if (!c thunk) {
            return true
        }

        arbiter cpArbiter = cpArbiter
        onBegin(arbiter)
    }

    preSolve: func (cpArbiter: CpArbiter, space: CpSpace) -> Bool {
        c := onPreSolve as Closure
        if (!c thunk) {
            return true
        }

        arbiter cpArbiter = cpArbiter
        onPreSolve(arbiter)
    }

    postSolve: func (cpArbiter: CpArbiter, space: CpSpace) {
        c := onPostSolve as Closure
        if (!c thunk) {
            return
        }

        arbiter cpArbiter = cpArbiter
        onPostSolve(arbiter)
    }

    separate: func (cpArbiter: CpArbiter, space: CpSpace) {
        c := onSeparate as Closure
        if (!c thunk) {
            return
        }

        arbiter cpArbiter = cpArbiter
        onSeparate(arbiter)
    }

}

Body: class {

    cpBody: CpBody

    userData: Pointer {
        get { cpBody getUserData() }
        set (p) { cpBody setUserData(p) }
    }

    pos: CpVect {
        get { cpBody getPos() }
        set (p) { cpBody setPos(p) }
    }

    vel: CpVect {
        get { cpBody getVel() }
        set (v) { cpBody setVel(v) }
    }

    angle: Double {
        get { cpBody getAngle() }
        set (a) { cpBody setAngle(a) }
    }

    init: func (mass, moment: Double) {
        init(CpBody new(mass, moment))
    }

    // internals
    init: func ~fromBody (=cpBody) {
        userData = this
    }

}

Shape: abstract class {

    cpShape: CpShape

    init: func (=cpShape) {
        userData = this
    }

    collisionType: UInt {
        get { cpShape getCollisionType() }
        set (t) { cpShape setCollisionType(t) }
    }

    group: UInt {
        get { cpShape getGroup() }
        set (g) { cpShape setGroup(g) }
    }

    layers: UInt {
        get { cpShape getLayers() }
        set (l) { cpShape setLayers(l) }
    }

    userData: Pointer {
        get { cpShape getUserData() }
        set (p) { cpShape setUserData(p) }
    }

    friction: Double {
        get { cpShape getFriction() }
        set(f) { cpShape setFriction(f) }
    }

}

PolyShape: class extends Shape {

    init: func (body: Body, numVerts: Int, verts: CpVect*, offset: CpVect) {
        super(CpPolyShape new(body cpBody, numVerts, verts, offset))
    }

}

BoxShape: class extends Shape {

    init: func (body: Body, width, height: Double) {
        super(CpBoxShape new(body cpBody, width, height))
    }

}

SegmentShape: class extends Shape {

    init: func (body: Body, a, b: CpVect, radius: Double) {
        super(CpSegmentShape new(body cpBody, a, b, radius))
    }

}

CpUtils: class {

    // vectors

    cpv: static func (x, y: Double) -> CpVect {
        (x, y) as CpVect
    }

    // moments

    momentForBox: static func (mass, width, height: Double) -> Double {
        cpMomentForBox(mass, width, height)
    }

}
