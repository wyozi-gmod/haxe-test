package gmod.macros;
import haxe.macro.Context;
import haxe.macro.Expr;

class GPropMacro {
    private static var GProps = [
        { name: "Pos", type: macro:Vector },
        { name: "Model", type: macro:String },
        { name: "Color", type: macro:Color },
    ];
    public static function build():Array<Field> {
        // get existing fields from the context from where build() is called
        var fields = Context.getBuildFields();

        var pos = Context.currentPos();

        for (prop in GProps) {
            var fieldName = prop.name;
            var fieldType = prop.type;

            // create: `public var $fieldName(get,null)`
            var propertyField:Field = {
                name: fieldName,
                access: [Access.APublic],
                kind: FieldType.FProp("get", "set", fieldType),
                pos: pos,
            };

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

            // append both fields
            fields.push(propertyField);
            fields.push(getterField);
            fields.push(setterField);
        }

        return fields;

    }
}
