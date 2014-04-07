LShop.cl.NotifyText = LShop.cl.NotifyText or {}

net.Receive( "LShop.notify.add", function( len, cli )
	local customvalue = net.ReadString()
	LShop.cl.NotifyText[ #LShop.cl.NotifyText + 1 ] = { 
		Time = CurTime() + 7, 
		SoundV = false, 
		Iserror = false,
		Stop = false, 
		Ani1 = false, 
		W = ScrW() * 0.95, 
		BoxW = 0, 
		Alpha = 255, 
		Text = customvalue
	}
end )

hook.Add("HUDPaint", "LShop.cl.notify", function( )
	local scrw = ScrW()
	local scrh = ScrH()
	
	for k, v in pairs( LShop.cl.NotifyText ) do
		if ( !v.SoundV ) then
			surface.PlaySound("buttons/lightswitch2.wav")
			v.SoundV = true
		end
		if ( v.Time ) then
			v.BoxW = math.Approach( v.BoxW, surface.GetTextSize( v.Text ) * 1.5, 5 )
			if ( !v.Stop ) then	
				v.W = math.Approach( v.W, scrw * 0.95, 20 )
				if ( v.W >= 14 ) then
					v.Stop = true
				end
			end
			if ( v.Time <= CurTime() ) then	
				v.Alpha = math.Approach( v.Alpha, 0, 2 )
				if ( v.Ani1 == false ) then
					v.W = Lerp( 0.05, v.W, scrw * 0.85 )
				end
				if ( math.Round( v.W ) >= scrw * 0.85 - 1 && v.Ani1 == false ) then
					v.Ani1 = true
				end
				if ( v.Ani1 ) then
					v.W = Lerp( 0.1, v.W, scrw + surface.GetTextSize( v.Text ) + scrw * 0.1 )
				end
				if ( v.Alpha <= 0 ) then
					table.remove( LShop.cl.NotifyText, k )
				end
			end
		end
		local t = #LShop.cl.NotifyText + 1

		if ( !v.Iserror ) then
			draw.RoundedBox( 0, v.W - v.BoxW, scrh * 0.85 - 20 * (t-k), v.BoxW, 20, Color( 50, 50, 50, v.Alpha ) )
		end
			
		draw.SimpleText( v.Text, "LShop_Intro_LoadText_2", v.W - 5, scrh * 0.85 - 20 * (t-k), Color( 255, 255, 255, v.Alpha ), TEXT_ALIGN_RIGHT )
	end
end )