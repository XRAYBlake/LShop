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

function LShop.core.AddClientFile( )
	local find = file.Find("autorun/LShop/cl/*.lua", "LUA") or nil
	if ( find ) then
		for k, v in pairs( find ) do
			LShop.core.CSLoadFile( "autorun/LShop/cl/" .. v )
			LShop.core.Message( Color( 0, 255, 255 ), "Load client file : " .. v )
		end
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

LShop.core.AddClientFile( )
LShop.core.LoadServerFile( )
LShop.core.LoadSharedFile( )

util.AddNetworkString( "LShop.intro.progress" )
util.AddNetworkString( "LShop.intro.sendcl" )

net.Receive( "LShop.intro.progress", function( len, cl )
	net.Start("LShop.intro.sendcl")
	net.WriteString( "Initialize..." )
	net.Send( cl )
	
	cl:Lock()
	
	for k, v in pairs( player.GetAll() ) do
		if ( IsValid( v ) ) then
			net.Start("LShop.intro.sendcl")
			net.WriteString( "Player data loading... : " .. k )
			net.Send( cl )			
		end
		
		if ( k == #player.GetAll() ) then
			net.Start("LShop.intro.sendcl")
			net.WriteString( "Player index load finished!" )
			net.Send( cl )		

			local catCount = 0
			local cat = 0
			
			timer.Create( "LShop_intro_ItemDataLoadProgress_" .. cl:SteamID(), 0.3, 0, function()
				for b, n in pairs( LShop.system.GetItems( ) ) do
					cat = cat + 1
					for i = 1, #LShop.system.GetItems( )[ b ] do	
						net.Start("LShop.intro.sendcl")
						net.WriteString( "Loaded global item : " .. LShop.system.GetItems( )[b][i].Name )
						net.Send( cl )	
						if ( i == #LShop.system.GetItems( )[b] ) then
							catCount = catCount + 1
						end
					end
				end
				
				if ( catCount == cat ) then
					timer.Destroy( "LShop_intro_ItemDataLoadProgress_" .. cl:SteamID() )
					
					net.Start("LShop.intro.sendcl")
					net.WriteString( "Player item data loading..." )
					net.Send( cl )
					
					cl:LShop_LoadData()
					
					local ownitems_file = file.Read("Lshop/" .. string.Replace( cl:SteamID(), ":", "_" ) .. "/Ownitems.txt", "DATA") or "[]"
					local ownitems = util.JSONToTable( ownitems_file )
					
					timer.Simple( 2, function()
						for m, dv in pairs( ownitems ) do
							net.Start("LShop.intro.sendcl")
							net.WriteString( "Player item data '" .. dv.ID .. "' loaded." )
							net.Send( cl )	
						end
						
						net.Start("LShop.intro.sendcl")
						net.WriteString( "Player item data load finished!" )
						net.Send( cl )	
					end)
					
					local money = file.Read("Lshop/" .. string.Replace( cl:SteamID(), ":", "_" ) .. "/Money.txt", "DATA") or 0

					timer.Simple( 3.5, function()
						net.Start("LShop.intro.sendcl")
						net.WriteString( "Scanning validation..." )
						net.Send( cl )	
					end)
					
					if ( tonumber( money ) >= 0 ) then
						timer.Simple( 4, function()
							net.Start("LShop.intro.sendcl")
							net.WriteString( "Validation scan finished!" )
							net.Send( cl )						
						end)					
					end

					timer.Simple( 6, function()
						net.Start("LShop.intro.sendcl")
						net.WriteString( "ok" )
						net.Send( cl )	
						cl:UnLock()	
					end)
					
					return
				end
			end)			
		end
	end
end)










