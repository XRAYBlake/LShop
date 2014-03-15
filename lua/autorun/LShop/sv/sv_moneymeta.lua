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

net.Receive("LShop_Admin_SetMoney", function( len, cl )
	local target = net.ReadEntity()
	local money = net.ReadString()
	if ( IsValid( target ) ) then
		target:LShop_SetMoney( tonumber( money ) )
		LShop.core.Message( Color( 0, 255, 0 ), "Set target money : " .. target:SteamID() )
	end
end)