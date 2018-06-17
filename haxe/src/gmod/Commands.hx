package gmod;
import gmod.object.Player;
class Commands {
    public static inline function add(command: String, callback: (Player, String, Array<String>) -> Void) {
        untyped __lua__("concommand.Add({0}, {1})", command, callback);
    }
}
