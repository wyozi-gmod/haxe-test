package ;
import gmod.Graphics;
import gmod.Camera;
import gmod.object.Vector;
import gmod.internal.Global;
import gmod.ScriptedEntity;
class TestEntity extends ScriptedEntity {
    @:networked var ThinkCount: Int;

    #if server
    override public function Init() {
        this.Model = "models/props_borealis/bluebarrel001.mdl";
        this.InitPhysics();
        this.ThinkCount = 0;
    }
    override public function Think() {
        this.ThinkCount++;
    }
    #end
    #if client
    override public function Draw() {
        this.DrawModel();
        Camera.wrap3D2D(
            this.WorldPos(Global.Vector(0, -20, 0)),
            this.WorldAngle(Global.Angle(0, 0, 90)),
            0.1,
            function() {
                Graphics.drawText(Std.string(this.ThinkCount), 0, 0);
            });
    }
    #end
}
