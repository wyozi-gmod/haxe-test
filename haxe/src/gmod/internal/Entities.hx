package gmod.internal;
import lua.Table;
import gmod.object.Entity;
@:native("ents") extern class Entities{
    static function Create(name: String): Entity;
    static function FindByClass(name: String): Table<Int, Entity>;
}