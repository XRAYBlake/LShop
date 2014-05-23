util.AddNetworkString( "LShop_versioncheck_Check" )
util.AddNetworkString( "LShop_versioncheck_CheckSendCL" )

net.Receive( "LShop_versioncheck_Check", function( len, cl )
	LShop.system.NewVersionCheck( cl )
end)

function LShop.system.NewVersionCheck( caller )
	http.Fetch( "http://textuploader.com/t0uw/raw",
		function( body, len, headers, code )
			net.Start("LShop_versioncheck_CheckSendCL")
			net.WriteString( body )
			net.Send( caller )
		end,
		function( err )
			LShop.kernel.Message( Color( 255, 0, 0 ), "Version Check Error : " .. err )
			net.Start("LShop_versioncheck_CheckSendCL")
			net.WriteString( "Error" )
			net.Send( caller )
		end
	)
end