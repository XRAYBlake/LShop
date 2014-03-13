
if ( SERVER ) then
	AddCSLuaFile( "autorun/LShop/cl_core.lua" )

	include( "LShop/sv_core.lua" )
end

if ( CLIENT ) then
	include( "LShop/cl_core.lua" )
end