package gmod.object;
extern class Vector {
    var x: Float;
    var y: Float;
    var z: Float;
}
abstract AVector(Vector) from Vector to Vector {
    @:op(A + B)
    public inline function add(rhs: Vector):Vector {
        return untyped __lua__("{0} + {1}", this, rhs);
    }
}