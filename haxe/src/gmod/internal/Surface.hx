package gmod.internal;
@:native("surface") extern class Surface {
    #if client
    static function SetDrawColor(r: Float, g: Float, b: Float): Void;
    static function DrawRect(x:Float, y:Float, w:Float, h:Float): Void;
    #end
}