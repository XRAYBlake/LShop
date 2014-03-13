local meta = FindMetaTable("Player")

function meta:LShop_GetMoney( )
	return self.Money
end

function meta:LShop_SetMoney( money )
	self.Money = tonumber( money )
end

function meta:LShop_AddMoney( money )
	local curretmoney = self.Money
	self.Money = curretmoney + tonumber( money )
end

function meta:LShop_TakeMoney( money )
	local curretmoney = self.Money
	self.Money = curretmoney - tonumber( money )
end
	
concommand.Add("LShop_GiveMoney", function( pl, cmd, args )
	if ( pl:IsSuperAdmin() ) then
		if ( args[1] ) then
			pl:LShop_SetMoney( args[1] )
<<<<<<< HEAD
		else
			pl:ChatPrint( "[LShop] 당신은 서버 관리자가 아닙니다." )
		end
	end)
	
	concommand.Add("LShop_GiveMoneys2", function( pl, cmd, args )
		if ( pl:IsSuperAdmin() ) then
			for k, v in pairs( player.GetAll() ) do
				v:LShop_SetMoney( args[1] )
			end
		else
			pl:ChatPrint( "[LShop] 당신은 서버 관리자가 아닙니다." )
=======
>>>>>>> Code Cleanup 4
		end
	else
		pl:ChatPrint( "[LShop] You are not server admin." )
	end
end)

concommand.Add("LShop_GetMoney", function( pl, cmd, args )
	pl:ChatPrint( pl:LShop_GetMoney( ) )
end)
