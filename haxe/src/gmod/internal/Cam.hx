package gmod.internal;
import gmod.object.Vector;
@:native("cam") extern class Cam {
    #if client
    static function Start3D2D(pos: Vector, ang: Dynamic, scale: Float): Void;
    static function End3D2D(): Void;
    #end
}