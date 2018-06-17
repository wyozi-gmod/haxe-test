package gmod;
import gmod.internal.Cam;
import gmod.object.Vector;
import gmod.object.Angle;
class Camera {
    #if client
    public static inline function wrap3D2D(pos: Vector, angle: Angle, scale: Float, body: () -> Void): Void {
        Cam.Start3D2D(pos, angle, scale);
        body();
        Cam.End3D2D();
    }
    #end
}
