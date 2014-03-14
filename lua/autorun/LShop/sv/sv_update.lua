
http.Fetch( "https://raw.githubusercontent.com/SolarTeam/LShop/master/version.txt", function( body )
	LShop.system.Versioncheck( body )
end)

function LShop.system.Versioncheck( newversion )
	local prefix = tonumber( newversion )
	
	if ( LShop.Config.Version <= prefix ) then
		LShop.core.Message( Color( 255, 255, 0 ), "New version found!" )
	elseif ( LShop.Config.Version >= prefix ) then
		LShop.core.Message( Color( 0, 255, 0 ), "Version is latest!" )
	end
end