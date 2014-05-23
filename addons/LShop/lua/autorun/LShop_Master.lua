--[[ //////////////////////////////////////////////////////////////
								LShop
	Copyright ( C ) 2014 by 'Cyanide Team' - Team Leader : L7D
	* FileIO - Copyright ( C ) 2013 by 'Alex Grist-Hucker'
////////////////////////////////////////////////////////////// --]]

if ( SERVER ) then
	AddCSLuaFile( "autorun/LShop/cl_kernel.lua" )
	include( "LShop/sv_kernel.lua" )
elseif ( CLIENT ) then
	include( "LShop/cl_kernel.lua" )
end