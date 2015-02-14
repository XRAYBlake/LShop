--[[
	LShop
	Copyright ( C ) 2014 by 'L7D'
--]]

local META = FindMetaTable("Player")

function META:LShop_GetMoney( )
	return self.Money	
end

function META:LShop_SetMoney( money )
	if ( type( money ) != "number" ) then money = tonumber( money ) end
	self:SetNWInt( "LShop_Money", math.max( self.Money, 0 ) )
end

function META:LShop_AddMoney( money )
	if ( type( money ) != "number" ) then money = tonumber( money ) end
	self.Money = self.Money + money
	self:SetNWInt( "LShop_Money", math.max( self.Money, 0 ) )
end

function META:LShop_TakeMoney( money )
	if ( type( money ) != "number" ) then money = tonumber( money ) end
	self.Money = self.Money - money
	self:SetNWInt( "LShop_Money", math.max( self.Money, 0 ) )
end

util.AddNetworkString( "LShop_Admin_SetMoney" )

net.Receive( "LShop_Admin_SetMoney", function( len, cl )
	local target = net.ReadEntity( )
	local money = net.ReadString( )
	if ( !IsValid( target ) ) then return end
	target:LShop_SetMoney( net.ReadString( ) )
	cl:LShop_SaveData( )
	LShop.system.SendDBToPlayer( cl )
	LShop.system.SendDBToPlayer( target )
end )