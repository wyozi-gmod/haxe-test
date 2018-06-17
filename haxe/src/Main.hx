package ;
import gmod.object.Vector.AVector;
import gmod.internal.Global;
import gmod.object.Entity;
import gmod.Commands;
import gmod.ScriptedEntity;

class Main {
    static function main() {
        ScriptedEntity.register(TestEntity);

        #if server
        Commands.add("spawnent", function(ply, cmd, args) {
            var ent = new TestEntity();
            ent.Pos = (ply.Pos: AVector) + Global.Vector(0, 0, 150);
        });
        #end
    }
}
