
net.Receive( "LShop.intro.sendcl", function( len, cl )
	local customvalue = net.ReadString()
	if ( customvalue == "ok" ) then
		LShop.cl.IntroLoadText[ #LShop.cl.IntroLoadText + 1 ] = { Time = CurTime() + 5, Alpha = 255, Text = "Loading complete!" }
		LShop.cl.IntroDone = true
		return	
	end
	
	LShop.cl.IntroLoadText[ #LShop.cl.IntroLoadText + 1 ] = { Time = CurTime() + 5, Alpha = 255, Text = customvalue }
	return
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
	
	LShop.cl.IntroBGM = CreateSound( LocalPlayer(), Sound("music/Ravenholm_1.mp3") )
	LShop.cl.IntroBGM:Play()
	
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
			if ( v.Time ) then
				if ( v.Time <= CurTime() ) then	
					v.Alpha = math.Approach( v.Alpha, 0, 1 )
					if ( v.Alpha <= 0 ) then
						table.remove( LShop.cl.IntroLoadText, k )
					end
				end
			end
			local t = #LShop.cl.IntroLoadText + 1
			draw.SimpleText( v.Text, "LShop_Category_Text", 15, scrh * 0.85 - 30 * (t-k), Color( 255, 255, 255, v.Alpha ), TEXT_ALIGN_LEFT )
		end
	end)
	
	hook.Add( "HUDPaint", "LShop.cl.Intro_HUDPaint", function( )
		local Stop = CurTime() - Start
		
		if ( gui.IsGameUIVisible() ) then
			return
		end

		if ( !intro_stop_progress ) then
			first_background_a = math.Approach( first_background_a, 255, 5 )
		end

		draw.RoundedBox( 0, 0, 0, scrw, first_background_h, Color( 10, 10, 10, first_background_a ) )
		draw.RoundedBox( 0, 0, scrh - first_background_h, scrw, first_background_h, Color( 10, 10, 10, first_background_a ) )
		
		if ( !LShop.cl.IntroDone ) then
			if ( !intro_stop_progress ) then
				if ( first_background_a >= 250 ) then
					if ( !first_intro_teamback_w_stop ) then
						first_intro_teamtext_a = math.Approach( first_intro_teamtext_a, 255, 15 )
					end
					if ( first_intro_teamback_w_stop == false ) then
						first_intro_teamback_w = math.Approach( first_intro_teamback_w, scrw + scrw, 11 )
					end
					if ( first_intro_teamback_w >= scrw && !first_intro_teamback_emit_stop ) then
						first_intro_teamback_emit_stop = true
					end
					if ( first_intro_teamback_w >= scrw + scrw * 0.9 ) then
						first_intro_teamback_w_stop = true
					end
					if ( first_intro_teamback_w_stop == true ) then
						first_intro_teamback_w = math.Approach( first_intro_teamback_w, 0, 20 )		
						
						if ( first_intro_teamback_w <= 0 ) then
							first_intro_teamtext_a = 0
							first_background_h = 0
							if ( !intro_stop_progress ) then
								if ( !sendnet ) then
									net.Start("LShop.intro.progress")
									net.SendToServer()
									LShop.cl.IntroLoadText[ 1 ] = { Time = CurTime() + 5, Alpha = 255, Text = "Request send to server!" }
									LShop.cl.IntroLoadText[ 2 ] = { Time = CurTime() + 5, Alpha = 255, Text = "Send finished!" }
									sendnet = true
								end
							end
						end
					end
					draw.RoundedBox( 0, 0, scrh / 2 - scrh * 0.07 / 2, first_intro_teamback_w, scrh * 0.07, Color( 245, 245, 245, first_intro_teamtext_a ) )
					draw.SimpleText( "Solar Team", "LShop_Intro_TeamText", scrw / 2, scrh / 2, Color( 0, 0, 0, first_intro_teamtext_a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			end
		end
		
		if ( first_intro_teamback_w <= 0 && first_intro_teamback_w_stop ) then
				if ( !intro_stop_progress && !LShop.cl.IntroDone ) then
					first_background_h = math.Approach( first_background_h, scrh * 0.1, 5 )
					first_background_a = math.Approach( first_background_a, 200, 10 )
				end
				hook.Add( "CalcView", "LAdmin.intro.SchematicView", function( ply, pos, angles, fov )
					if ( IsValid( ply ) ) then
						first_intro_calcview_runned = true
						
						local sin = math.sin( CurTime() / 2 )
						viewSin = ( 30 / 1 ) * sin
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
				
				draw.SimpleText( "LShop", "LShop_MainTitle", scrw / 2, scrh * 0.05, Color( 255, 255, 255, intro_percent_a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
				draw.SimpleText( "Loading ...", "LShop_Category_Text", scrw / 2, scrh * 0.95, Color( 255, 255, 255, intro_percent_a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
		if ( LShop.cl.IntroDone ) then
			first_background_h = math.Approach( first_background_h, 0, 1 )
			first_background_a = 200
			if ( first_background_h <= 0 ) then
				intro_stop_progress = true
			end
		end
		
		if ( intro_stop_progress ) then
			LShop.cl.IntroBGM:FadeOut( 1 )
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