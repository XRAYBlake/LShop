util.AddNetworkString( "LShop.intro.progress" )
util.AddNetworkString( "LShop.intro.sendcl" )
util.AddNetworkString( "LShop.intro.sendstopcmd" )

net.Receive( "LShop.intro.progress", function( len, cl )
	
	local IsFinished = false
	
	LShop.kernel.IntroLoadingMessageSend( cl, "Request received!" )
	LShop.kernel.IntroLoadingMessageSend( cl, "Checking valid in the player ..." )
	
	if ( !IsValid( cl ) ) then
		LShop.kernel.IntroErrorMessageSend( cl, "ERROR : You are not valid player!" )
		print("Error message send!")
		return	
	end

	if ( !cl:IsPlayer() ) then
		LShop.kernel.IntroErrorMessageSend( cl, "ERROR : You are not player!" )
		print("Error message send!")
		return
	end
	
	if ( cl:IsBot() ) then
		LShop.kernel.IntroErrorMessageSend( cl, "ERROR : You are bot!" )
		print("Error message send!")
		return
	end
	
	local plycheckCount = 0
	for k, v in pairs( player.GetAll() ) do
		if ( v ) then
			if ( v:SteamID() == cl:SteamID() ) then
				plycheckCount = plycheckCount + 1
			end
		end
	end
	
	if ( plycheckCount > 1 ) then
		LShop.kernel.IntroErrorMessageSend( cl, "ERROR : You are not valid player!" )
		print("Error message send!")
		return
	end
	
	plycheckCount = nil
	
	LShop.kernel.IntroLoadingMessageSend( cl, "Player valid check progress finished!" )
	
	cl:Lock()
	
	LShop.kernel.IntroLoadingMessageSend( cl, "System initializing ..." )
	
	timer.Simple( 1, function()
		for m, c in pairs( player.GetAll() ) do
			if ( IsValid( c ) ) then
				if ( c != cl ) then
					LShop.kernel.IntroLoadingMessageSend( cl, "Other player index data checking ... - " .. c:UniqueID() )
				end
				if ( m == #player.GetAll() ) then
					LShop.kernel.IntroLoadingMessageSend( cl, "Other player index data check progress finished!" )
				end
			else
				LShop.kernel.IntroErrorMessageSend( cl, "ERROR : Other player index data check failed!" )
				print("Error message send!")
				return		
			end
		end
	end)
	
	timer.Simple( 2, function()
		local catCount = 0
		local loadeditemCat = 0
		local catBuffer = {}
		
		local plydataCount = 0
		
		LShop.kernel.IntroLoadingMessageSend( cl, "Item data loading ..." )
		
		for cat, _ in pairs( LShop.system.GetItems( ) ) do
			if ( cat ) then
				catCount = catCount + 1
				catBuffer[ #catBuffer + 1 ] = cat
			end
		end
		local scancount = 0
		for m, _ in pairs( LShop.system.GetItems( ) ) do
			timer.Create( "LShop.kernel.introprogress_checkitemdata_" .. m .. "_" .. cl:SteamID(), 2, 0, function()
				for i = 1, #LShop.system.GetItems( )[ m ] do
					LShop.kernel.IntroLoadingMessageSend( cl, "Item data loaded ... - " .. LShop.system.GetItems( )[ m ][ i ].ID )
					if ( i == #LShop.system.GetItems( )[ m ] ) then
						scancount = scancount + 1
					end
					if ( scancount == catCount ) then
						LShop.kernel.IntroLoadingMessageSend( cl, "Loaded!" )
						for n = 1, #catBuffer do
							timer.Destroy( "LShop.kernel.introprogress_checkitemdata_" .. catBuffer[n] .. "_" .. cl:SteamID() )
						end
						timer.Simple( 1, function()
							LShop.kernel.IntroLoadingMessageSend( cl, "Player data loading ..." )
							cl:LShop_LoadData()
							
							timer.Simple( 1.5, function()
								LShop.kernel.IntroLoadingMessageSend( cl, "Loaded!" )
								
								LShop.kernel.IntroLoadingMessageSend( cl, "Player data checking ..." )
								
								local dirName = string.Replace( cl:SteamID(), ":", "_" )
								local money = file.Read("Lshop/" .. dirName .. "/Money.txt", "DATA") or nil
								local ownitem = file.Read("Lshop/" .. dirName .. "/Ownitems.txt", "DATA") or nil
								
								if ( !money ) then
									LShop.kernel.IntroLoadingMessageSend( cl, "NOTICE : Can't find player money data file, initializing ..." )
									cl.Money = 0
									LShop.kernel.IntroLoadingMessageSend( cl, "Initialized player money data!" )	
									plydataCount = plydataCount + 1
								end
								
								if ( !ownitem ) then
									LShop.kernel.IntroLoadingMessageSend( cl, "NOTICE : Can't find player items data file, initializing ..." )
									cl.OwnItems = {}	
									LShop.kernel.IntroLoadingMessageSend( cl, "Initialized player items data!" )	
									plydataCount = plydataCount + 1
								end
								timer.Create( "LShop.kernel.introprogress_plitemdataload" .. cl:SteamID(), 3, 0, function()
									if ( plydataCount == 2 ) then
										cl:LShop_SaveData()
										LShop.kernel.IntroLoadingMessageSend( cl, "Player data check finished!" )
										IsFinished = true
										if ( timer.Exists( "LShop.kernel.introprogress_plitemdataload" .. cl:SteamID() ) ) then
											timer.Destroy( "LShop.kernel.introprogress_plitemdataload" .. cl:SteamID() )
										end
										return
									end
								end)
								
								if ( money && ownitem ) then
									LShop.kernel.IntroLoadingMessageSend( cl, "Player data check finished!" )
									LShop.kernel.IntroLoadingMessageSend( cl, "You have " .. cl.Money .. " moneys." )
									LShop.kernel.IntroLoadingMessageSend( cl, "You have " .. #cl.OwnItems .. " items." )
									
									IsFinished = true
									return
								end
							end)
						end)
					end		
				end
			end)
		end	
	end)

	timer.Create( "LShop.kernel.introprogress_checkfinished_" .. cl:SteamID(), 5, 0, function()
		if ( IsFinished ) then
			LShop.kernel.IntroLoadingMessageSend( cl, "ok" )
			cl:UnLock()
			if ( timer.Exists( "LShop.kernel.introprogress_checkfinished_" .. cl:SteamID() ) ) then
				timer.Destroy( "LShop.kernel.introprogress_checkfinished_" .. cl:SteamID() )
			end
		end
	end)
end)

function LShop.kernel.IntroLoadingMessageSend( pl, msg )
	if ( IsValid( pl ) ) then
		if ( msg ) then
			if ( type( msg ) == "string" ) then
				net.Start("LShop.intro.sendcl")
				net.WriteString( msg )
				net.Send( pl )	
			end
		end
	end
end

function LShop.kernel.IntroErrorMessageSend( pl, msg )
	if ( IsValid( pl ) ) then
		if ( msg ) then
			if ( type( msg ) == "string" ) then
				net.Start("LShop.intro.sendstopcmd")
				net.WriteString( msg )
				net.Send( pl )	
			end
		end
	end
end