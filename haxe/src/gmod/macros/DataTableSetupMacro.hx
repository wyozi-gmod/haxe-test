package gmod.macros;
import haxe.macro.Expr.Error;
import haxe.macro.Expr.TypePath;
import haxe.ds.Option;
import haxe.macro.Expr.MetadataEntry;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
class DataTableSetupMacro {
    private static function getGModNetworkableType(f: Field): String {
        var ftype = f.kind;
        //trace(f);
        return switch(ftype) {
            case FVar(TPath(_.name => "Int"), e): "Int";
            case FVar(TPath(_.name => "Float"), e): "Float";
            case FVar(TPath(_.name => "String"), e): "String";
            case FVar(TPath(_.name => "Entity"), e): "Entity";
            case FVar(TPath(_.name => "Vector"), e): "Vector";
            case FVar(TPath(tp), e): throw new Error("Cannot network following type: '" + tp.name + "'", f.pos);
            case _: throw new Error("Unnetworkable field: " + f, f.pos);
        };
    }
    public static function build():Array<Field> {
        var fields: Array<Field> = Context.getBuildFields();
        var pos = Context.currentPos();

        var networkedFields = fields.filter(function(f: Field) {
            return f.meta.filter(function(m: MetadataEntry) {
                return m.name == ":networked";
            }).length > 0;
        });

        if (networkedFields.length == 0) {
            return fields;
        }

        var typeCounts = new Map<String, Int>();
        var exprs = networkedFields.map(function(f: Field) {
            var gmodType = getGModNetworkableType(f);
            var index = 0;
            if (typeCounts.exists(gmodType)) {
                index = typeCounts.get(gmodType);
            }
            typeCounts.set(gmodType, index + 1);
            return macro gmodEnt.NetworkVar('${gmodType}', $v{index}, '${f.name}');
        });

        var setupDataTables:Field = {
            name: "SetupDataTables",
            access: [Access.APublic, Access.AStatic],
            kind: FieldType.FFun({
                expr: macro $b{exprs},
                ret: (macro:Void),
                args:[{
                    value: null,
                    type: (macro:Dynamic),
                    opt: false,
                    name: "ignoredSelf"
                },{
                    value: null,
                    type: (macro:Dynamic),
                    opt: false,
                    name: "gmodEnt"
                }]
            }),
            pos: pos,
        };
        fields.push(setupDataTables);

        for (nwField in networkedFields) {
            var fieldName = nwField.name;
            var fieldType = switch (nwField.kind) {
                case FVar(t, e): t;
                case _: throw new Error("Failed to retrieve fieldType??", nwField.pos);
            };

            var propertyField:Field = {
                name: fieldName,
                access: [Access.APublic],
                kind: FieldType.FProp("get",
                #if server
                "set"
                #else
                "never"
                #end
                , fieldType),
                pos: pos,
            };
            fields.push(propertyField);

            var gGetterName = "Get" + fieldName;
            var getterField:Field = {
                name: "get_" + fieldName,
                access: [Access.APrivate, Access.AInline],
                kind: FieldType.FFun({
                    expr: macro return this.gmodEnt.$gGetterName(),
                    ret: (fieldType), // ret = return type
                    args:[] // no arguments here
                }),
                pos: pos,
            };
            fields.push(getterField);

            #if server
            var gSetterName = "Set" + fieldName;
            var setterField:Field = {
                name: "set_" + fieldName,
                access: [Access.APrivate, Access.AInline],
                kind: FieldType.FFun({
                    expr: macro {
                        this.gmodEnt.$gSetterName(val);
                        return val;
                    },
                    ret: (fieldType), // ret = return type
                    args:[{
                        value: null,
                        type: fieldType,
                        opt: false,
                        name: "val"
                    }]
                }),
                pos: pos,
            };
            fields.push(setterField);
            #end

            // Remove original field
            fields.remove(nwField);
        }

        return fields;
    }
}
