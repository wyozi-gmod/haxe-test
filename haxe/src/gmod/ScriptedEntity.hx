package gmod;

import lua.PairTools;
import lua.Lib;
import gmod.internal.Entities;
import gmod.object.Entity;
import gmod.internal.SEntities;
import gmod.object.*; // used by macro

import lua.Lua;
@:keepSub
@:build(gmod.macros.GPropMacro.build())
@:autoBuild(gmod.macros.DataTableSetupMacro.build())
class ScriptedEntity {
    private var gmodEnt: Entity;

    public static function getGmodClassName<T: ScriptedEntity>(cls: Class<T>) {
        return 'haxe_${Type.getClassName(cls)}'.toLowerCase();
    }

    public function Init() {
    }
    public function Think() {
    }

    #if server
    @:final public function new() {
        var clz = getGmodClassName(Type.getClass(this));
        this.gmodEnt = Entities.Create(clz);
        this.gmodEnt._haxeRef = this;
        this.gmodEnt.Spawn();
        this.gmodEnt.Activate();
    }

    public function InitPhysics() {
        this.gmodEnt.PhysicsInit(untyped SOLID_VPHYSICS);
    }
    #end

    #if client
    private function new() {
    }

    @:final public function DrawModel() {
        this.gmodEnt.DrawModel();
    }
    public function Draw() {
        this.DrawModel();
    }
    #end

    public var EntIndex(get, null): Int;
    private function get_EntIndex(): Int { return this.gmodEnt.EntIndex(); }

    private inline function WorldPos(localPos: Vector): Vector {
        return this.gmodEnt.LocalToWorld(localPos);
    }
    private inline function WorldAngle(localAngle: Angle): Angle {
        return this.gmodEnt.LocalToWorldAngles(localAngle);
    }

    public var ModelScale(get, set): Float;
    private function get_ModelScale(): Float { return this.gmodEnt.GetModelScale(); }
    private function set_ModelScale(val: Float): Float { this.gmodEnt.SetModelScale(val, 0); return val; }

    public function toString(): String {
        return '[SEnt; gmod=${Lua.tostring(this.gmodEnt)}]';
    }

    public static function register<T: ScriptedEntity>(cls: Class<T>) {
        var className = ScriptedEntity.getGmodClassName(cls);
        var entObj = {
            Type: "anim",
            SetupDataTables: function() {
                var self = untyped self;
                var staticCls: Dynamic = cls;
                if (staticCls.SetupDataTables) {
                    staticCls.SetupDataTables(self);
                }
            },
            Initialize: function() {
                var self = untyped self;
                if (self._haxeRef == null) {
                    self._haxeRef = Type.createInstance(cls, []);
                    self._haxeRef.gmodEnt = untyped self;
                }
                self._haxeRef.Init();
            },
            Think: function() {
                var self = untyped self;
                self._haxeRef.Think();
            },
            Draw: function() {
                var self = untyped self;
                self._haxeRef.Draw();
            }
        };
        SEntities.Register(entObj, className);

        #if dev
        #if client
        // Hot reload
        PairTools.pairsEach(Entities.FindByClass(className), function(key, e) {
            e._haxeRef = Type.createInstance(cls, []);
            e._haxeRef.gmodEnt = e;
        });
        #end
        #end
    }
}