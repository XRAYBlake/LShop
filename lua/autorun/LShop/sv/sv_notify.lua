--[[
	LShop
	Copyright ( C ) 2014 by 'L7D'
--]]

util.AddNetworkString( "LShop.notify.add" )

function LShop.system.Notify( pl, msg )
	if ( !IsValid( pl ) or !msg ) then return end
	net.Start( "LShop.notify.add" )
	net.WriteString( msg )
	net.Send( pl )
end