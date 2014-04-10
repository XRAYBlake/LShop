
if ( !fileio ) then
	require("fileio")
	
	if ( fileio ) then
		LShop.core.Message( Color( 0, 255, 0 ), "FileIO Module load. - Module by 'AlexGrist'" )
	else
		LShop.core.Message( Color( 255, 0, 0 ), "FileIO Module load failed. - Please reinstall FileIO Module ;o" )
	end
end

LShop.SU = LShop.SU or {}

util.AddNetworkString( "LShop_SU_CheckNewUpdate" )
util.AddNetworkString( "LShop_SU_CheckNewUpdate_SendCL" )
util.AddNetworkString( "LShop_SU_SoftwareUpdate" )
util.AddNetworkString( "LShop_SU_SoftwareUpdate_ProgressMessage" )
util.AddNetworkString( "LShop_SU_SoftwareUpdate_STOP" )
util.AddNetworkString( "LShop_SU_SoftwareUpdate_Ready" )

net.Receive( "LShop_SU_CheckNewUpdate", function( len, cl )
	LShop.SU.CheckNewUpdate( cl )
end)

net.Receive( "LShop_SU_SoftwareUpdate", function( len, cl )
	LShop.SU.ProgressMessage( cl, "Initializing ..." )
	timer.Simple( 1, function()
		LShop.SU.SoftwareUpdate_1( cl )
	end)
end)

function LShop.system.FileWrite( path, data )
	return fileio.Write( path, data )
end

function LShop.system.FileDelete( path )
	return fileio.Delete( path )
end

function LShop.system.DirCreate( path )
	return fileio.MakeDirectory( path )
end

function LShop.SU.ProgressMessage( caller, msg )
	net.Start("LShop_SU_SoftwareUpdate_ProgressMessage")
	net.WriteString( msg )
	net.Send( caller )
end

function LShop.SU.Ready( caller )
	net.Start("LShop_SU_SoftwareUpdate_Ready")
	net.Send( caller )
end

function LShop.SU.Stop( caller )
	net.Start("LShop_SU_SoftwareUpdate_STOP")
	net.Send( caller )
	LShop.SU.ProgressMessage( caller, "SU ERROR : Update stop ..." )
	RunConsoleCommand( "changelevel", game.GetMap() )
end

function LShop.SU.SoftwareUpdate_1( caller )
	LShop.core.Message( Color( 0, 255, 255 ), "[Progress] Software version check..." )
	LShop.SU.ProgressMessage( caller, "Software update check ..." )
	
	http.Fetch( "http://textuploader.com/tdny/raw",
		function( body, len, headers, code )
			if ( LShop.Config.Version == body ) then
				LShop.core.Message( Color( 0, 255, 0 ), "Version is latest!" )
				LShop.SU.ProgressMessage( caller, "ERROR : Version is latest!" )
			else
				LShop.SU.ProgressMessage( caller, "You need software update !" )
				LShop.SU.SoftwareUpdate_2( caller )
			end
		end,
		function( err )
			LShop.core.Message( Color( 255, 255, 0 ), "Error : " .. err )
			LShop.SU.ProgressMessage( caller, err )
		end
	)

end

function LShop.SU.SoftwareUpdate_2( caller )
	for _, pl in pairs( player.GetAll() ) do
		if ( pl != caller ) then
			pl:Kick( "[SU]Software update." )
		end
	end
	RunConsoleCommand( "sv_password", math.random( 1, 99999999 ) .. math.random( 1, 100000 ) )
	LShop.SU.Ready( caller )

	LShop.SU.ProgressMessage( caller, "Downloading, update file list ..." )

	local updatedfileList = {}
	http.Fetch( "http://textuploader.com/tdni/raw",
		function( body, len, headers, code )
			updatedfileList = string.Explode( "\n", body )
			print("Get update list..")
			for k, v in pairs( updatedfileList ) do
					if ( k != #updatedfileList ) then
						updatedfileList[k] = string.sub( v, 0, string.len( v ) - 1 )
					else
						LShop.SU.ProgressMessage( caller, "Update file list download finished!" )	
						LShop.system.SoftwareUpdate_3( caller, updatedfileList )
					end
			end
		end,
		function( err )
			LShop.core.Message( Color( 255, 255, 0 ), "Error : " .. err )
			LShop.SU.ProgressMessage( caller, err )
		end
	)
end

function LShop.system.SoftwareUpdate_3( caller, lists )
	LShop.SU.ProgressMessage( caller, "Cache download system initializing ..." )	
	local Finished = {}
	
	for k, v in pairs( lists ) do
		Finished[ k ] = false
	end
	
	LShop.system.DirCreate( "data/LShop" )
	LShop.system.DirCreate( "data/LShop/cache/" )
	local deletepreCache = file.Find( "LShop/cache/*", "DATA" ) or nil
	if ( #deletepreCache != 0 ) then
		LShop.SU.ProgressMessage( caller, "Pre create cache file delete ..." )	
		for k1, v1 in pairs( deletepreCache ) do
			LShop.system.FileDelete( "data/LShop/cache/" .. v1 )
			LShop.SU.ProgressMessage( caller, "Cache file delete! : " .. v1 )
		end
	end
	
	for k2, v2 in pairs( lists ) do
		timer.Create( "LShop_su_func3_1_" .. k2, 3 + k2, 1, function()
			http.Fetch( "https://raw.githubusercontent.com/SolarTeam/LShop/master/" .. v2,
				function( body, len, headers, code )
					if ( !string.match( body, "Not Found" ) ) then
						Finished[ k2 ] = true
						local exs = string.GetExtensionFromFilename( v2 )
						LShop.system.FileWrite( "data/LShop/cache/" .. k2 .. ".data", tostring( body ) )
						LShop.system.FileWrite( "data/LShop/cache/" .. k2 .. ".cache", tostring( v2 ) )
						LShop.SU.ProgressMessage( caller, "Cache file create ... : " .. k2 .. ".data" )
					else
						Finished[ k2 ] = nil
						LShop.SU.ProgressMessage( caller, "ERROR : Cache file create failed! : " .. v2 )
						table.remove( lists, k2 )
					end
				end,
				function( err )
					LShop.core.Message( Color( 255, 255, 0 ), "Error : " .. err )
				end
			)				
		end)
	end
	
	timer.Create( "LShop_su_func3_compcheck", 1, 0, function()
		for k3, v3 in pairs( Finished ) do
			if ( v3 ) then
				if ( k3 == #Finished ) then
					LShop.SU.ProgressMessage( caller, "Cache file create finished !" )
					LShop.system.SoftwareUpdate_4( caller, lists )
					timer.Destroy("LShop_su_func3_compcheck")
				end			
			end
		end
	end)
	
end

function LShop.system.SoftwareUpdate_4( caller, lists )
	LShop.SU.ProgressMessage( caller, "Software update initializing ..." )
	timer.Simple( 2, function()
		local Finished = {}
		for i = 1, #lists do
			Finished[ i ] = false
		end
		local files, dirs = file.Find( "addons/*", "GAME" )
		if ( dirs ) then
			for k, v in pairs( dirs ) do
				local findText = string.lower( v )
				local addonDIR = ""
				if ( string.match( findText, "lshop" ) ) then
					addonDIR = v
					local cachefileFind = file.Find( "LShop/cache/*", "DATA" )
					for kg, vg in pairs( cachefileFind ) do
						if ( string.match( vg, ".cache" ) ) then
							table.remove( cachefileFind, kg )
						end
					end
					for k2, v2 in pairs( cachefileFind ) do
						timer.Create( "LShop_su_func4_1_" .. k2, 2 + k2, 0, function()
							local exs = string.GetExtensionFromFilename( v2 )
							local dirRep = string.gsub( v2, exs, "cache" )
							local fileDirread = file.Read( "LShop/cache/" .. dirRep, "DATA" )
							local fileDataread = file.Read( "LShop/cache/" .. v2, "DATA" )
							
							if ( fileDirread && fileDataread ) then
								Finished[ k2 ] = true
								local dir = ""
								local exs = ""
								local exd = string.Explode( "/", fileDirread )
								for k3, v3 in pairs( exd ) do
									if ( k3 != #exd ) then
										dir = dir .. "/" ..  v3
										LShop.system.DirCreate( "addons/" .. addonDIR .. "/" .. dir )
									else
										LShop.system.FileWrite( "addons/" .. addonDIR .. "/" .. fileDirread, fileDataread )
										LShop.SU.ProgressMessage( caller, "Update software ... : " .. v3 )
										LShop.core.Message( Color( 0, 255, 0 ), "[SU]Update software ... : " .. fileDirread )
									end
								end
								timer.Destroy( "LShop_su_func4_1_" .. k2 )
							else
								LShop.SU.ProgressMessage( caller, "Cache file read failed! : " .. v2 )
								LShop.core.Message( Color( 255, 0, 0 ), "[SU]Cache file read failed! : " .. v2 )
							end
						end)
					end
				end
			end
		end
		
		timer.Create( "LShop_su_func4_compcheck", 3, 0, function()
			for k3, v3 in pairs( Finished ) do
				if ( v3 ) then
					if ( k3 == #Finished ) then
						LShop.SU.ProgressMessage( caller, "Software update finished !" )
						timer.Simple( 2, function()
							LShop.SU.ProgressMessage( caller, "After a while, reboot server ..." )
							timer.Simple( 4, function()
								RunConsoleCommand("changelevel", game.GetMap())
							end)
						end)
						timer.Destroy("LShop_su_func4_compcheck")
					end			
				end
			end		
		end)
	end)
end

function LShop.SU.CheckNewUpdate( caller )
	local curret_version = LShop.Config.Version or "0.1"
	LShop.core.Message( Color( 0, 255, 0 ), "Check Version update ..." )
	http.Fetch( "http://textuploader.com/tdny/raw",
		function( body, len, headers, code )
			if ( curret_version == body ) then
				LShop.core.Message( Color( 0, 255, 0 ), "Version is latest!" )
				net.Start("LShop_SU_CheckNewUpdate_SendCL")
				net.WriteString( "0" )
				net.WriteString( body )
				net.WriteTable( { } )
				net.Send( caller )
			else
				LShop.core.Message( Color( 0, 255, 255 ), "You need software update." )
				http.Fetch( "http://textuploader.com/t1kj/raw",
					function( body2, len, headers, code )
						local changelog = string.Explode( "\n", body2 )
						net.Start("LShop_SU_CheckNewUpdate_SendCL")
						net.WriteString( "1" )
						net.WriteString( body )
						net.WriteTable( changelog )
						net.Send( caller )
					end,
					function( err )
					
					end
				)
			end
		end,
		function( err )
			LShop.core.Message( Color( 255, 255, 0 ), "Error : " .. err )
		end
	)
end