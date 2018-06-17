package gmod.internal;
import gmod.object.Color;
@:native("draw") extern class Draw {
    #if client
    static function SimpleText(text: String, font: String, x: Float, y: Float, color: Color, hAlign: Int, vAlign: Int): Void;
    #end
}