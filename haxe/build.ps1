echo BuildingCL
C:\HaxeToolkit\haxe\haxe -lua ../lua/haxe_cl.lua -cp src -main Main -D client -D dev -dce full
echo BuildingSV
C:\HaxeToolkit\haxe\haxe -lua ../lua/haxe_sv.lua -cp src -main Main -D server -D dev -dce full
