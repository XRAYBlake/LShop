--[[

--]]

local meta = FindMetaTable("Player")


function meta:LShop_GetMoney( )
	return self.Money
end

function meta:LShop_SetMoney( money )
	self.Money = tonumber( money )
	--self:SetNWInt( "LShop_Money", tonumber( money ) )
end

function meta:LShop_AddMoney( money )
	local curretmoney = self.Money
	self.Money = curretmoney + tonumber( money )
	--self:SetNWInt( "LShop_Money", self:GetNWInt( "LShop_Money" ) + tonumber( money ) )	
end

function meta:LShop_TakeMoney( money )
	local curretmoney = self.Money
	self.Money = curretmoney - tonumber( money )
	--self:SetNWInt( "LShop_Money", self:GetNWInt( "LShop_Money" ) - tonumber( money ) )
end

--[[
	function LShop.system.SaveMoney( )
		file.CreateDir("Lshop")
		for k, v in pairs( player.GetAll() ) do
			file.CreateDir("Lshop/" .. string.gsub( v:SteamID(), ":", "_" ))
			file.Write("Lshop/" .. string.gsub( v:SteamID(), ":", "_" ) .. "/Money.txt", tostring( v:GetNWInt( "LShop_Money" ) ) )
		end
	end

	function LShop.system.SaveMoneyTarget( pl )
	
	end
	
	

	function Player:LShop_LoadMoney( )
		for k, v in pairs( player.GetAll() ) do
			local load = file.Read("Lshop/" .. string.gsub( self:SteamID(), ":", "_" ) .. "/Money.txt") or nil
			if ( load ) then
				self:SetNWInt( "LShop_Money", tonumber( load ) )
			else
				self:SetNWInt( "LShop_Money", 0 )
			end
			print("Load money! : " .. self:SteamID() )
		end
	end
	
	
	function LShop.system.FindPlyMoney( steamID )
		local checkExist = file.Read("Lshop/" .. string.gsub( steamID, ":", "_" ) .. "/Money.txt") or nil
		
		if ( checkExist ) then
			return checkExist
		else
			return 0
		end
	end
	
	function LShop.system.LoadMoneyConnect( pl )
		local money = LShop.system.FindPlyMoney( pl:SteamID() )
		pl:SetNWInt( "LShop_Money", tonumber( money ) )
		print("Recover money! : " .. money )
	end
	
	hook.Add("PlayerAuthed", "LShop.system.LoadMoneyConnect", LShop.system.LoadMoneyConnect)
--]]
	concommand.Add("LShop_Loadmoney", function( pl, cmd, args )
		print( pl:LShop_GetMoney( ) )
	end)
	
	concommand.Add("LShop_GiveMoneys", function( pl, cmd, args )
		pl:LShop_SetMoney( args[1] )
		print( pl:LShop_GetMoney( ) )
	end)
	
	concommand.Add("LShop_GiveMoneys2", function( pl, cmd, args )
		for k, v in pairs( player.GetAll() ) do
			v:LShop_SetMoney( args[1] )
		
			print( v.Money )
		end
	end)
	
	concommand.Add("LShop_GetMoney", function( pl, cmd, args )
		pl:ChatPrint( pl:LShop_GetMoney( ) )
	end)