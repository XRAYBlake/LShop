LShop = LShop or {}
LShop.core = LShop.core or {}
LShop.system = LShop.system or {}

function LShop.core.Message( color, msg )
	if ( color && msg ) then
		MsgC( color, "[LShop]" .. msg .. "\n" )
	end
end

function LShop.core.LoadFile( fileDir )
	if ( fileDir ) then
		include( fileDir )
	end
end

function LShop.core.CSLoadFile( fileDir )
	if ( fileDir ) then
		AddCSLuaFile( fileDir )
	end
end

function LShop.core.LoadSharedFile( )
	local find = file.Find("autorun/LShop/sh/*.lua", "LUA") or nil
	if ( find ) then
		for k, v in pairs( find ) do
			LShop.core.LoadFile( "sh/" .. v )
			LShop.core.CSLoadFile( "autorun/LShop/sh/" .. v )
			LShop.core.Message( Color( 0, 255, 255 ), "Load shared file : " .. v )
		end
	end
end

function LShop.core.LoadServerFile( )
	local find = file.Find("autorun/LShop/sv/*.lua", "LUA") or nil
	if ( find ) then
		for k, v in pairs( find ) do
			LShop.core.LoadFile( "sv/" .. v )
			LShop.core.Message( Color( 0, 255, 255 ), "Load server file : " .. v )
		end
	end
end

LShop.core.LoadServerFile( )
LShop.core.LoadSharedFile( )