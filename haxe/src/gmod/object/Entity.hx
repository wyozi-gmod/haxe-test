package gmod.object;

@:forward() abstract Entity(Dynamic) {
    public var Pos(get, never): Vector;
    private inline function get_Pos(): Vector {
        return this.GetPos();
    }
}
