LShop = LShop or {}
LShop.kernel = LShop.kernel or {}
LShop.system = LShop.system or {}

function LShop.kernel.Message( color, msg )
	if ( color && msg ) then
		MsgC( color, "[LShop]" .. msg .. "\n" )
	end
end

function LShop.kernel.LoadFile( fileDir )
	if ( fileDir ) then
		include( fileDir )
	end
end

function LShop.kernel.CSLoadFile( fileDir )
	if ( fileDir ) then
		AddCSLuaFile( fileDir )
	end
end

function LShop.kernel.AddClientFile( )
	local find = file.Find("autorun/LShop/cl/*.lua", "LUA") or nil
	if ( find ) then
		for k, v in pairs( find ) do
			LShop.kernel.CSLoadFile( "autorun/LShop/cl/" .. v )
			LShop.kernel.Message( Color( 0, 255, 255 ), "Load client file : " .. v )
		end
	end
end

function LShop.kernel.LoadSharedFile( )
	local find = file.Find("autorun/LShop/sh/*.lua", "LUA") or nil
	if ( find ) then
		for k, v in pairs( find ) do
			LShop.kernel.LoadFile( "sh/" .. v )
			LShop.kernel.CSLoadFile( "autorun/LShop/sh/" .. v )
			LShop.kernel.Message( Color( 0, 255, 255 ), "Load shared file : " .. v )
		end
	end
end

function LShop.kernel.LoadServerFile( )
	local find = file.Find("autorun/LShop/sv/*.lua", "LUA") or nil
	if ( find ) then
		for k, v in pairs( find ) do
			LShop.kernel.LoadFile( "sv/" .. v )
			LShop.kernel.Message( Color( 0, 255, 255 ), "Load server file : " .. v )
		end
	end
end

LShop.kernel.AddClientFile( )
LShop.kernel.LoadServerFile( )
LShop.kernel.LoadSharedFile( )