package gmod.internal;
@:native("hook") extern class Hook {
    static function Add(name: String, identifier: String, callback: Dynamic): Void;
}