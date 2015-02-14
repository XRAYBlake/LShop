--[[
	LShop
	Copyright ( C ) 2014 by 'L7D'
--]]

if ( SERVER ) then
	AddCSLuaFile( "autorun/LShop/cl_kernel.lua" )
	include( "LShop/sv_kernel.lua" )
elseif ( CLIENT ) then
	include( "LShop/cl_kernel.lua" )
end