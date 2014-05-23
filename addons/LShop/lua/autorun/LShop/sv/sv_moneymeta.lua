local meta = FindMetaTable("Player")

function meta:LShop_GetMoney( )
	return self.Money	
end

function meta:LShop_SetMoney( money )
	self.Money = tonumber( money )
	self:SetNWInt("LShop_Money", self.Money)
end

function meta:LShop_AddMoney( money )
	local curretmoney = self.Money
	self.Money = curretmoney + tonumber( money )
	self:SetNWInt("LShop_Money", self.Money)
end

function meta:LShop_TakeMoney( money )
	local curretmoney = self.Money
	self.Money = curretmoney - tonumber( money )
	self:SetNWInt("LShop_Money", self.Money)
end

util.AddNetworkString("LShop_Admin_SetMoney")

function LShop.kernel.MoneyFIX( )
	for k, v in pairs( player.GetAll() ) do
		local money = v.Money
		if ( type( money ) == "number" ) then
			if ( money < 0 ) then
				v:LShop_SetMoney( 0 )
				return
			end
		else
			v:LShop_SetMoney( 0 )
			return
		end
	end
end
hook.Add( "Think", "LAdmin.kernel.MoneyFIX", LShop.kernel.MoneyFIX )

net.Receive("LShop_Admin_SetMoney", function( len, cl )
	local target = net.ReadEntity()
	local money = net.ReadString()
	if ( IsValid( target ) ) then
		target:LShop_SetMoney( tonumber( money ) )
		LShop.kernel.Message( Color( 0, 255, 0 ), "Set target money : " .. target:SteamID() )
		cl:LShop_SaveData()
		LShop.system.SendDBToPlayer( cl )
		LShop.system.SendDBToPlayer( target )
	end
end)