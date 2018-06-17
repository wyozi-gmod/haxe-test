package gmod;
import gmod.internal.Draw;
class Graphics {
    #if client
    public static inline function drawText(text: String, x: Float, y: Float): Void {
        Draw.SimpleText(text, "DermaLarge", x, y, null, null, null);
    }
    #end
}
