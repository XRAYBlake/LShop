LShop = LShop or { kernel = { }, system = { } }

function LShop.kernel.Message( color, text )
	if ( !text ) then return end
	if ( !color ) then color = Color( 255, 255, 255 ) end
	MsgC( color, "[LShop] " .. text .. "\n" )
end

function LShop.kernel.LoadFile( fileDir )
	if ( !fileDir ) then return end
	include( fileDir )
end

function LShop.kernel.CSLoadFile( fileDir )
	if ( !fileDir ) then return end
	AddCSLuaFile( fileDir )
end

function LShop.kernel.AddClientFile( )
	local find = file.Find("autorun/LShop/cl/*.lua", "LUA")
	for k, v in pairs( find ) do
		LShop.kernel.CSLoadFile( "autorun/LShop/cl/" .. v )
		LShop.kernel.Message( Color( 0, 255, 255 ), "Load client file : " .. v )
	end
end

function LShop.kernel.LoadSharedFile( )
	local find = file.Find("autorun/LShop/sh/*.lua", "LUA")
	for k, v in pairs( find ) do
		LShop.kernel.LoadFile( "sh/" .. v )
		LShop.kernel.CSLoadFile( "autorun/LShop/sh/" .. v )
		LShop.kernel.Message( Color( 0, 255, 255 ), "Load shared file : " .. v )
	end
end

function LShop.kernel.LoadServerFile( )
	local find = file.Find("autorun/LShop/sv/*.lua", "LUA")
	for k, v in pairs( find ) do
		LShop.kernel.LoadFile( "sv/" .. v )
		LShop.kernel.Message( Color( 0, 255, 255 ), "Load server file : " .. v )
	end
end

LShop.kernel.AddClientFile( )
LShop.kernel.LoadServerFile( )
LShop.kernel.LoadSharedFile( )