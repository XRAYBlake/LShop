LShop.Config = LShop.Config or {}

LShop.Config.Version = "1.3" -- Do not edit this!

LShop.Config.OpenCommand = "LShop_open" -- Set menu open console command.
LShop.Config.OpenKey = "F4" -- Set menu open key.
LShop.Config.ChatOpenCommand = "/XPSys_open" -- Set menu open chat command.
LShop.Config.ChatOpenCommand_Output = "" -- Set menu open chat command output string.

--[[// #################################### //
	= Shop Open Key Document =
	F1 -- Yeah F1 Button. :)
	F2 -- Yeah F2 Button. :)
	F3 -- Yeah F3 Button. :)
	F4 -- Yeah F4 Button. :)
--]]// #################################### //


LShop.Config.AutoMoneyGive = true -- Are you sure turn on Auto Money Give system? ( Timer system )
LShop.Config.MoneyGiveTimer = 60 -- ( Sec )
LShop.Config.MoneyAmmount = 100 -- Money Amount. ( 100 $ )

LShop.Config.ItemGiftSystem = true -- Are you sure allow Item Gift System?

LShop.Config.DaySaleSystem = false -- Are you sure turn on Week Day Sale System?
LShop.Config.DayNumber = 1 -- WeekDay Sale system day number.
LShop.Config.SalePercent = function( price ) -- WeekDay Sale system sale percent.
	return math.Round( price * 0.95 )
end

--[[// #################################### //
	= WeekDay Sale System Document =

	What is 'LShop.Config.DayNumber'?
	Answer : It is weekday number, look at bottom.
	
	1 = Sunday
	2 = Monday
	3 = Tuesday
	4 = Wednesday
	5 = Thursday
	6 = Friday
	7 = Saturday
	
	:)
--]]// #################################### //

LShop.Config.PermissionCheck = function( pl ) -- Administrator menu permission.
	return pl:IsSuperAdmin()
end

--[[// #################################### //
	= Administrator Permission Check System Document =

	-- Give permission super admins!
	LShop.Config.PermissionCheck = function( pl )
		return pl:IsSuperAdmin()
	end
	
	-- Give permission admins!
	LShop.Config.PermissionCheck = function( pl )
		return pl:IsAdmin()
	end
	
	-- Give permission only that Steam ID!
	// NOTICE : If you want get your Steam ID? use this site!
	// http://steamidfinder.com/
	
	LShop.Config.PermissionCheck = function( pl )
		if ( pl:SteamID() == "STEAM ID HERE" ) then
			return true
		else
			return false
		end
	end
--]]// #################################### //