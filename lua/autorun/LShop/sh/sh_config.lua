LShop.Config = LShop.Config or {}

LShop.Config.Version = "1.4" -- Do not edit this!

LShop.Config.OpenCommand = "LShop_open" -- Shop open command in console.
LShop.Config.OpenKey = "F4" -- Key to open Shop.
LShop.Config.ChatOpenCommand = "!shop" -- Chat command that opens Shop.
LShop.Config.ChatOpenCommand_Output = "Shop opened!" -- Set menu open chat command output string.

--[[// #################################### //
	= Shop Open Key Document =
	F1 -- Yeah F1 Button. :)
	F2 -- Yeah F2 Button. :)
	F3 -- Yeah F3 Button. :)
	F4 -- Yeah F4 Button. :)
--]]// #################################### //

LShop.Config.IntroEnabled = true -- Enable intro? (It's pretty cool!)

LShop.Config.AutoMoneyGive = true -- Enable timed "Paychecks"?
LShop.Config.MoneyGiveTimer = 60 -- How long between "Paychecks" (Seconds)
LShop.Config.MoneyAmmount = 100 -- How much money per paycheck.

LShop.Config.ItemGiftSystem = true -- Enable item gifting?

LShop.Config.DaySaleSystem = false -- Enable weekday sales? (Serverside weekdays)
LShop.Config.DayNumber = 7 -- What day is the sale on?

LShop.Config.SalePercent = function( price )
	return math.Round( price * 0.95 ) --Percentage of price paid on Sale Day.
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

LShop.Config.GroupDiscountEnabled = true
LShop.Config.GroupDiscount = function( pl, price )
	if ( pl:IsUserGroup( "donator" ) ) then
		return math.Round( price * 0.75 )
	elseif ( pl:IsAdmin() ) then
		return math.Round( price * 0.50 )
	elseif ( pl:IsSuperAdmin() ) then
		return math.Round( price * 0.25 )
	elseif ( pl:IsUserGroup( "owner" ) ) then
		return math.Round( price * 0 )
	else
		return price
	end
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
