
local KeyHook = {}
KeyHook[1] = "ShowHelp"
KeyHook[2] = "ShowTeam"
KeyHook[3] = "ShowSpare1"
KeyHook[4] = "ShowSpare2"

util.AddNetworkString("LShop_MenuOpen")

function LShop.system.OpenKeyHook( keyhook )
	if ( keyhook == "F1" ) then
		LShop.core.Message( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
		hook.Add(KeyHook[1], "LShop.OpenKey.1", function( ply )
			net.Start("LShop_MenuOpen")
			net.Send( ply )
		end)
	elseif ( keyhook == "F2" ) then
		LShop.core.Message( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
		hook.Add(KeyHook[2], "LShop.OpenKey.2", function( ply )
			net.Start("LShop_MenuOpen")
			net.Send( ply )
		end)
	elseif ( keyhook == "F3" ) then
		LShop.core.Message( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
		hook.Add(KeyHook[3], "LShop.OpenKey.3", function( ply )
			net.Start("LShop_MenuOpen")
			net.Send( ply )
		end)
	elseif ( keyhook == "F4" ) then
		LShop.core.Message( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
		hook.Add(KeyHook[4], "LShop.OpenKey.4", function( ply )
			net.Start("LShop_MenuOpen")
			net.Send( ply )
		end)
	else
		keyhook = "Non!"
		LShop.core.Message( Color( 0, 255, 0 ), "Menu open key set : " .. keyhook )
	end
end

hook.Add("Initialize", "LShop.OpenKeyHook", function()
	LShop.system.OpenKeyHook( LShop.Config.OpenKey )
end)
