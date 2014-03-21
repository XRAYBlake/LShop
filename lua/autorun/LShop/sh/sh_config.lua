LShop.Config = LShop.Config or {}

LShop.Config.Version = "1.2A" -- Do not edit this!

LShop.Config.OpenCommand = "LShop_open" -- Set menu open console command.
LShop.Config.OpenKey = "F4" -- Set menu open key.
LShop.Config.ChatOpenCommand = "/XPSys_open" -- Set menu open chat command.
LShop.Config.ChatOpenCommand_Output = "" -- Set menu open chat command output string.
--[[
	= LShop.Config.OpenKey List =
	F1 
	F2
	F3
	F4
--]]

LShop.Config.AutoMoneyGive = true -- Are you sure turn on Auto Money Give system?
LShop.Config.MoneyGiveTimer = 60 -- ( Sec )
LShop.Config.MoneyAmmount = 100 -- Money Amount. ( 100 $ )

LShop.Config.ItemGiftSystem = true -- Are you sure allow Item Gift System?

LShop.Config.PermissionCheck = function( pl ) -- Administrator menu permission.
	return pl:IsSuperAdmin()
end