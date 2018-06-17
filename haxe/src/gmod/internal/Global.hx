package gmod.internal;
import gmod.object.*;

@:native("_G") extern class Global {
    static function CurTime(): Float;
    static function Vector(x: Float, y: Float, z: Float): Vector;
    static function Angle(p: Float, y: Float, r: Float): Angle;
    static function Color(r: Float, g: Float, b: Float): Color;
}