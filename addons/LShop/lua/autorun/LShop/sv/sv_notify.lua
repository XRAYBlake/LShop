
util.AddNetworkString( "LShop.notify.add" )

function LShop.system.Notify( pl, msg )
	if ( IsValid( pl ) ) then
		if ( msg ) then
			net.Start("LShop.notify.add")
			net.WriteString( msg )
			net.Send( pl )
		end
	end
end