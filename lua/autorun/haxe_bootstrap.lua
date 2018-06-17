AddCSLuaFile()

if SERVER then
	AddCSLuaFile("haxe_cl.lua")
	include("haxe_sv.lua")
end
if CLIENT then
	include("haxe_cl.lua")
end