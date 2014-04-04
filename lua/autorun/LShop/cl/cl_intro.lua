
net.Receive( "LShop.intro.sendcl", function( len, cli )
	local customvalue = net.ReadString()
	if ( customvalue == "ok" ) then
		LShop.cl.IntroLoadText[ #LShop.cl.IntroLoadText + 1 ] = { 
			Time = CurTime() + 7, 
			SoundV = false, 
			Iserror = false,
			Stop = false, 
			Ani1 = false, 
			W = 0, 
			BoxW = 0, 
			Alpha = 255, 
			Text = "Loaded complete!!!" 
		}
		LShop.cl.IntroLoadText[ #LShop.cl.IntroLoadText + 1 ] = { 
			Time = CurTime() + 7, 
			SoundV = false, 
			Iserror = false,
			Stop = false, 
			Ani1 = false, 
			W = 0, 
			BoxW = 0, 
			Alpha = 255, 
			Text = "Welcome to LShop."
		}
		LShop.cl.IntroDone = true
		return	
	end
	
	LShop.cl.IntroLoadText[ #LShop.cl.IntroLoadText + 1 ] = { 
		Time = CurTime() + 6, 
		Iserror = false,
		SoundV = false, 
		Stop = false, 
		Ani1 = false, 
		W = 0 - surface.GetTextSize( customvalue ) * 2, 
		BoxW = 0, 
		Alpha = 255, 
		Text = customvalue
	}
	return
end)

net.Receive( "LShop.intro.sendstopcmd", function( len, cl )
	LShop.cl.IntroLoadText = {}
	LShop.cl.IntroLoadText[ #LShop.cl.IntroLoadText + 1 ] = { 
		Time = CurTime() + 15, 
		Iserror = true,
		SoundV = false, 
		Stop = false, 
		Ani1 = false, 
		W = 0, 
		BoxW = 0, 
		Alpha = 255, 
		Text = net.ReadString() 
	}
	LShop.cl.IntroPlaying = false
	hook.Remove( "CalcView", "LAdmin.intro.SchematicView" )
	hook.Remove( "HUDPaint", "LShop.cl.Intro_HUDPaint" )
	hook.Remove( "ShouldDrawLocalPlayer", "LAdmin.intro.SchematicView_Func" )
	hook.Remove( "HUDShouldDraw", "LShop.cl.Intro_HUDHide" )
	if ( LShop.cl.IntroBGM ) then
		LShop.cl.IntroBGM:Stop()
	end
end)

function LShop.cl.Intro()
	
	local first_background_a = 0
	local first_background_h = ScrH()
	local first_intro_teamtext_a = 0
	local first_intro_teamback_w = 100
	local first_intro_teamback_w_stop = false
	local first_intro_teamback_emit_stop = false
	local intro_percent_a = 0
	local intro_percent_str = ""
	local done = false
	local intro_stop_progress = false
	local first_intro_calcview_runned = false
	local sendnet = false
	local loading_bar_w_ani = 0
	
	local Start = CurTime()
	local scrw = ScrW()
	local scrh = ScrH()
	
	if ( LShop.cl.IntroPlaying ) then
		return
	end
	
	if ( LocalPlayer():GetNWBool( "LShop_Intro_AlreadyPlayed" ) == true ) then
		LShop.cl.MainShop()
		return
	end
	
	LShop.cl.IntroDone = false
	
 	hook.Remove( "HUDPaint", "LShop.cl.Intro_HUDPaint" )
	hook.Remove( "CalcView", "LAdmin.intro.SchematicView" )
	hook.Remove( "ShouldDrawLocalPlayer", "LAdmin.intro.SchematicView_Func" )
	hook.Remove( "HUDPaint", "LShop.cl.Intro_LoadText" )
	hook.Remove( "HUDShouldDraw", "LShop.cl.Intro_HUDHide" )
	
	LShop.cl.IntroBGM = CreateSound( LocalPlayer(), Sound("music/HL2_song1.mp3") )
	LShop.cl.IntroBGM:Play()
	
	local twostep = false
	LShop.cl.IntroPlaying = true
	LShop.cl.IntroPercent = 0
	LShop.cl.IntroLoadText = {}
	
	hook.Add( "HUDShouldDraw", "LShop.cl.Intro_HUDHide", function( name )
		local blockHUD = { "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudWeaponSelection", "CHudChat" }
		for k, v in pairs( blockHUD ) do
			if ( name == v ) then
				return false
			end
        end		
	end)
	
	hook.Add( "HUDPaint", "LShop.cl.Intro_LoadText", function( )
		for k, v in pairs( LShop.cl.IntroLoadText ) do
			if ( !v.SoundV ) then
				surface.PlaySound("buttons/lightswitch2.wav")
				v.SoundV = true
			end
			if ( v.Time ) then
				v.BoxW = math.Approach( v.BoxW, surface.GetTextSize( v.Text ) + scrh * 0.15, 5 )
				if ( !v.Stop ) then	
					v.W = math.Approach( v.W, 15, 20 )
					if ( v.W >= 14 ) then
						v.Stop = true
					end
				end
				if ( v.Time <= CurTime() ) then	
					v.Alpha = math.Approach( v.Alpha, 0, 2 )
					if ( v.Ani1 == false ) then
						v.W = Lerp( 0.05, v.W, scrh * 0.05 )
					end
					if ( math.Round( v.W ) >= scrh * 0.05 - 1 && v.Ani1 == false ) then
						v.Ani1 = true
					end
					if ( v.Ani1 ) then
						v.W = Lerp( 0.1, v.W, 0 - surface.GetTextSize( v.Text ) * 2 )
					end
					if ( v.Alpha <= 0 ) then
						table.remove( LShop.cl.IntroLoadText, k )
					end
				else
				end
			end
			local t = #LShop.cl.IntroLoadText + 1

			if ( !v.Iserror ) then
				surface.SetDrawColor( 50, 50, 50, v.Alpha )
				surface.SetMaterial( Material("gui/gradient") )
				surface.DrawTexturedRect( v.W, scrh * 0.85 - 30 * (t-k), v.BoxW, 25 )
			else
				surface.SetDrawColor( 255, 50, 50, v.Alpha )
				surface.SetMaterial( Material("gui/gradient") )
				surface.DrawTexturedRect( v.W, scrh * 0.85 - 30 * (t-k), v.BoxW, 25 )			
			end
			
			draw.SimpleText( v.Text, "LShop_Intro_LoadText_2", v.W + 5, scrh * 0.85 - 30 * (t-k), Color( 255, 255, 255, v.Alpha ), TEXT_ALIGN_LEFT )
			
		end
	end)
	
	hook.Add( "HUDPaint", "LShop.cl.Intro_HUDPaint", function( )
		local Stop = CurTime() - Start
		
		if ( gui.IsGameUIVisible() ) then
			return
		end

		if ( !intro_stop_progress ) then
			first_background_a = math.Approach( first_background_a, 255, 1 )
		end

		draw.RoundedBox( 0, 0, 0, scrw, first_background_h, Color( 30, 30, 30, first_background_a ) )
		draw.RoundedBox( 0, 0, scrh - first_background_h, scrw, first_background_h, Color( 30, 30, 30, first_background_a ) )
		
		if ( !LShop.cl.IntroDone ) then
			if ( !intro_stop_progress ) then
				if ( !twostep ) then
					if ( first_background_a >= 255 - 1 ) then
						if ( !first_intro_teamback_w_stop ) then
							first_intro_teamtext_a = 255
						end
						if ( first_intro_teamback_w_stop == false ) then
							first_intro_teamback_w = math.Approach( first_intro_teamback_w, scrw + scrw + scrw * 0.5, 10 )
						end
						if ( first_intro_teamback_w >= scrw && !first_intro_teamback_emit_stop ) then
							first_intro_teamback_emit_stop = true
						end
						if ( first_intro_teamback_w >= scrw + scrw + scrw * 0.5 - 1 ) then
							first_intro_teamback_w_stop = true
						end
						if ( first_intro_teamback_w_stop == true ) then
							first_intro_teamback_w = math.Approach( first_intro_teamback_w, 0, 13 )		
							
							if ( first_intro_teamback_w <= 0 ) then
								first_intro_teamtext_a = 0
								first_background_h = 0
								twostep = true
								if ( !intro_stop_progress ) then
									if ( !sendnet ) then
										surface.PlaySound("buttons/combine_button1.wav")
										net.Start("LShop.intro.progress")
										net.SendToServer()
										LShop.cl.IntroLoadText[ #LShop.cl.IntroLoadText + 1 ] = { 
											Time = CurTime() + 6, 
											SoundV = false, 
											Stop = false, 
											Ani1 = false, 
											W = 0 - surface.GetTextSize( "Sending a request to server ..." ) * 2, 
											BoxW = 0, 
											Alpha = 255, 
											Text = "Sending a request to server ..."
										}
										sendnet = true
									end
								end
							end
						end
						draw.RoundedBox( 0, 0, scrh / 2 - scrh * 0.15 / 2, first_intro_teamback_w, scrh * 0.15, Color( 235, 235, 235, first_intro_teamtext_a ) )
						draw.SimpleText( "LShop", "LShop_Intro_Title", scrw / 2 + math.random( 1, 3 ), scrh / 2 - scrh * 0.03 + math.random( 1, 3 ), Color( 30, 30, 30, first_intro_teamtext_a - 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( "LShop", "LShop_Intro_Title", scrw / 2, scrh / 2 - scrh * 0.03, Color( 30, 30, 30, first_intro_teamtext_a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( "Solar Team", "LShop_Intro_TeamText", scrw / 2, scrh / 2 + scrh * 0.03, Color( 30, 30, 30, first_intro_teamtext_a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( "VERSION " .. LShop.Config.Version, "LShop_Intro_Version", scrw - 10, scrh / 2 + scrh * 0.05, Color( 30, 30, 30, first_intro_teamtext_a ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						
						surface.SetDrawColor( 60, 60, 60, first_intro_teamtext_a )
						surface.SetMaterial( Material("gui/gradient_up") )
						surface.DrawTexturedRect( 0, scrh - scrh * 0.8, scrw, scrh * 0.8 )
					end
				end
			end
		end
		
		if ( first_intro_teamback_w <= 0 && first_intro_teamback_w_stop ) then
				if ( !intro_stop_progress && !LShop.cl.IntroDone ) then
					first_background_h = math.Approach( first_background_h, 100, 1 )
					first_background_a = math.Approach( first_background_a, 0, 10 )
				end
				
				hook.Add( "CalcView", "LAdmin.intro.SchematicView", function( ply, pos, angles, fov )
					if ( IsValid( ply ) ) then
						first_intro_calcview_runned = true
						
						local sin = math.sin( CurTime() / 3 )
						viewSin = ( 50 / 1 ) * sin
						local view = {}
						view.origin = Vector( pos.x, pos.y, pos.z + 100 )
						view.angles = Angle( angles.p, angles.y + viewSin, angles.r ) 
						view.fov = fov
							 
						return view
					end
				end)	
				
				hook.Add( "ShouldDrawLocalPlayer", "LAdmin.intro.SchematicView_Func", function()
					return true
				end)
				
				if ( LShop.cl.IntroDone ) then
					intro_percent_a = math.Approach( intro_percent_a, 0, 10 )
				else
					intro_percent_a = math.Approach( intro_percent_a, 255, 10 )
				end	
				
				surface.SetDrawColor( 50, 50, 50, intro_percent_a - 0 )
				surface.SetMaterial( Material("gui/gradient_up") )
				surface.DrawTexturedRect( 0, scrh - first_background_h + 10, scrw, first_background_h )
				
				surface.SetDrawColor( 50, 50, 50, intro_percent_a - 0 )
				surface.SetMaterial( Material("gui/gradient_down") )
				surface.DrawTexturedRect( 0, 0 - 10, scrw, first_background_h )
				
				draw.SimpleText( "LShop", "LShop_MainTitle", scrw / 2, first_background_h / 2, Color( 255, 255, 255, intro_percent_a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Loading ...", "LShop_Intro_LoadText_2", scrw / 2, scrh - first_background_h / 2, Color( 255, 255, 255, intro_percent_a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
		if ( LShop.cl.IntroDone ) then
			first_background_h = math.Approach( first_background_h, 0, 1 )
			first_background_a = 0
			if ( first_background_h <= 0 ) then
				intro_stop_progress = true
			end
		end
		
		if ( intro_stop_progress ) then
			LShop.cl.IntroBGM:FadeOut( 3 )
			LShop.cl.IntroPlaying = false
			hook.Remove( "CalcView", "LAdmin.intro.SchematicView" )
			hook.Remove( "HUDPaint", "LShop.cl.Intro_HUDPaint" )
			hook.Remove( "ShouldDrawLocalPlayer", "LAdmin.intro.SchematicView_Func" )
			hook.Remove( "HUDShouldDraw", "LShop.cl.Intro_HUDHide" )
			LShop.cl.MainShop()
			LocalPlayer():SetNWBool( "LShop_Intro_AlreadyPlayed", true )
		end
	end)
end
LocalPlayer():SetNWBool( "LShop_Intro_AlreadyPlayed", false )