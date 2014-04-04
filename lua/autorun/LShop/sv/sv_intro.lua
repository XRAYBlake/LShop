util.AddNetworkString( "LShop.intro.progress" )
util.AddNetworkString( "LShop.intro.sendcl" )
util.AddNetworkString( "LShop.intro.sendstopcmd" )

net.Receive( "LShop.intro.progress", function( len, cl )
	
	local IsFinished = false
	
	LShop.core.IntroLoadingMessageSend( cl, "Request received!" )
	LShop.core.IntroLoadingMessageSend( cl, "Checking valid in the player ..." )
	
	if ( !IsValid( cl ) ) then
		LShop.core.IntroErrorMessageSend( cl, "ERROR : You are not valid player!" )
		print("Error message send!")
		return	
	end

	if ( !cl:IsPlayer() ) then
		LShop.core.IntroErrorMessageSend( cl, "ERROR : You are not player!" )
		print("Error message send!")
		return
	end
	
	if ( cl:IsBot() ) then
		LShop.core.IntroErrorMessageSend( cl, "ERROR : You are bot!" )
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
		LShop.core.IntroErrorMessageSend( cl, "ERROR : You are not valid player!" )
		print("Error message send!")
		return
	end
	
	plycheckCount = nil
	
	LShop.core.IntroLoadingMessageSend( cl, "Player valid check progress finished!" )
	
	cl:Lock()
	
	LShop.core.IntroLoadingMessageSend( cl, "System initializing ..." )
	
	timer.Simple( 1, function()
		for m, c in pairs( player.GetAll() ) do
			if ( IsValid( c ) ) then
				if ( c != cl ) then
					LShop.core.IntroLoadingMessageSend( cl, "Other player index data checking ... - " .. c:UniqueID() )
				end
				if ( m == #player.GetAll() ) then
					LShop.core.IntroLoadingMessageSend( cl, "Other player index data check progress finished!" )
				end
			else
				LShop.core.IntroErrorMessageSend( cl, "ERROR : Other player index data check failed!" )
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
		
		LShop.core.IntroLoadingMessageSend( cl, "Item data loading ..." )
		
		for cat, _ in pairs( LShop.ITEMs ) do
			if ( cat ) then
				catCount = catCount + 1
				catBuffer[ #catBuffer + 1 ] = cat
			end
		end
		local scancount = 0
		for m, _ in pairs( LShop.ITEMs ) do
			timer.Create( "LShop.core.introprogress_checkitemdata_" .. m .. "_" .. cl:SteamID(), 2, 0, function()
				for i = 1, #LShop.ITEMs[ m ] do
					LShop.core.IntroLoadingMessageSend( cl, "Item data loaded ... - " .. LShop.ITEMs[ m ][ i ].ID )
					if ( i == #LShop.ITEMs[ m ] ) then
						scancount = scancount + 1
					end
					if ( scancount == catCount ) then
						LShop.core.IntroLoadingMessageSend( cl, "Loaded!" )
						for n = 1, #catBuffer do
							timer.Destroy( "LShop.core.introprogress_checkitemdata_" .. catBuffer[n] .. "_" .. cl:SteamID() )
						end
						timer.Simple( 1, function()
							LShop.core.IntroLoadingMessageSend( cl, "Player data loading ..." )
							cl:LShop_LoadData()
							
							timer.Simple( 1.5, function()
								LShop.core.IntroLoadingMessageSend( cl, "Loaded!" )
								
								LShop.core.IntroLoadingMessageSend( cl, "Player data checking ..." )
								
								local dirName = string.Replace( cl:SteamID(), ":", "_" )
								local money = file.Read("Lshop/" .. dirName .. "/Money.txt", "DATA") or nil
								local ownitem = file.Read("Lshop/" .. dirName .. "/Ownitems.txt", "DATA") or nil
								
								if ( !money ) then
									LShop.core.IntroLoadingMessageSend( cl, "NOTICE : Can't find player money data file, initializing ..." )
									cl.Money = 0
									LShop.core.IntroLoadingMessageSend( cl, "Initialized player money data!" )	
									plydataCount = plydataCount + 1
								end
								
								if ( !ownitem ) then
									LShop.core.IntroLoadingMessageSend( cl, "NOTICE : Can't find player items data file, initializing ..." )
									cl.OwnItems = {}	
									LShop.core.IntroLoadingMessageSend( cl, "Initialized player items data!" )	
									plydataCount = plydataCount + 1
								end
								timer.Create( "LShop.core.introprogress_plitemdataload" .. cl:SteamID(), 3, 0, function()
									if ( plydataCount == 2 ) then
										cl:LShop_SaveData()
										LShop.core.IntroLoadingMessageSend( cl, "Player data check finished!" )
										IsFinished = true
										if ( timer.Exists( "LShop.core.introprogress_plitemdataload" .. cl:SteamID() ) ) then
											timer.Destroy( "LShop.core.introprogress_plitemdataload" .. cl:SteamID() )
										end
										return
									end
								end)
								
								if ( money && ownitem ) then
									LShop.core.IntroLoadingMessageSend( cl, "Player data check finished!" )
									LShop.core.IntroLoadingMessageSend( cl, "You have " .. cl.Money .. " moneys." )
									LShop.core.IntroLoadingMessageSend( cl, "You have " .. #cl.OwnItems .. " items." )
									
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

	timer.Create( "LShop.core.introprogress_checkfinished_" .. cl:SteamID(), 5, 0, function()
		if ( IsFinished ) then
			LShop.core.IntroLoadingMessageSend( cl, "ok" )
			cl:UnLock()
			if ( timer.Exists( "LShop.core.introprogress_checkfinished_" .. cl:SteamID() ) ) then
				timer.Destroy( "LShop.core.introprogress_checkfinished_" .. cl:SteamID() )
			end
		end
	end)
end)

function LShop.core.IntroLoadingMessageSend( pl, msg )
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

function LShop.core.IntroErrorMessageSend( pl, msg )
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