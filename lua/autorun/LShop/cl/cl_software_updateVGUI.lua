function LShop.cl.SU_update( )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_su_update_w, LShop_su_update_h = scrW, scrH
	local LShop_su_update_x, LShop_su_update_y = scrW / 2 - LShop_su_update_w / 2, scrH / 2 - LShop_su_update_h / 2;
	local notify = {}
	local Ani = 0
	local AniFunc = false
	net.Receive( "LShop_SU_SoftwareUpdate_ProgressMessage", function( len, cl )
		local msg = net.ReadString()
		notify[ #notify + 1 ] = {
			Text = msg,
			Time = CurTime() + 3,
			Alpha = 255
		}
	end)

	if ( !LShop_su_update ) then
	LShop_su_update = vgui.Create("DFrame", parent)
	LShop_su_update:SetPos( LShop_su_update_x , LShop_su_update_y )
	LShop_su_update:SetSize( LShop_su_update_w, LShop_su_update_h )
	LShop_su_update:SetTitle( "" )
	LShop_su_update:SetDraggable( false )
	LShop_su_update:ShowCloseButton( false )
	LShop_su_update:MakePopup()
	LShop_su_update:SetDrawOnTop( true )
	LShop_su_update.Think = function() 
		if ( LShop_su_update ) then
			LShop_su_update:MoveToFront() 
		end
	end
	LShop_su_update.Paint = function()
		local x = LShop_su_update_x
		local y = LShop_su_update_y
		local w = LShop_su_update_w
		local h = LShop_su_update_h
		
		if ( Ani != w && !AniFunc ) then
			Ani = math.Approach( Ani, w + w, 4 )
		end
		
		if ( Ani >= w ) then
			AniFunc = true
		end
		
		if ( AniFunc ) then
			Ani = math.Approach( Ani, 0, 4 )
			if ( Ani == 0 ) then
				AniFunc = false
			end
		end
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, h - 10, Ani, 10, Color( 255, 255, 255, 255 ) )

		draw.SimpleText( "Software Update", "LShop_MainTitle", w * 0.95, h * 0.05, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Do not shutdown server!", "LShop_SubTitle", w * 0.95, h * 0.1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

		draw.SimpleText( "LShop Kernel " .. LShop.Config.Version, "LShop_Category_Text", w * 0.95, h * 0.95, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

		for k, v in pairs( notify ) do
			local t = #notify + 1
			if ( v.Time <= CurTime() ) then
				v.Alpha = math.Approach( v.Alpha, 0, 2 )
				if ( v.Alpha <= 0 ) then
					table.remove( notify, k )
				end			
			end
			
			draw.SimpleText( v.Text, "LShop_Category_Text", w * 0.05, h * 0.95 - 30 * ( t - k ), Color( 255, 255, 255, v.Alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )			
		end
	end
	
	else
		LShop_su_update:Remove()
		LShop_su_update = nil
	end
	
end

function LShop.cl.SU_software_download( newver, changelog )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_su_software_download_w, LShop_su_software_download_h = scrW * 0.7, scrH * 0.7
	local LShop_su_software_download_x, LShop_su_software_download_y = scrW / 2 - LShop_su_software_download_w / 2, scrH / 2 - LShop_su_software_download_h / 2;
	local step = 0
	local software_update_progress_msg = ""
	local mode = 0
	local w, h = LShop_su_software_download_w, LShop_su_software_download_h
	local x, y = scrW / 2 - LShop_su_software_download_w / 2, scrH / 2 - LShop_su_software_download_h / 2;

	

	net.Receive( "LShop_SU_SoftwareUpdate_ProgressMessage", function( len, cl )
		local msg = net.ReadString()
		software_update_progress_msg = msg
	end)
	
	net.Receive( "LShop_SU_SoftwareUpdate_STOP", function( len, cl )
		LShop.SU.CheckNewUpdate( cl )
	end)

	
	if ( !LShop_su_software_download ) then
	LShop_su_software_download = vgui.Create("DFrame", parent)
	LShop_su_software_download:SetPos( LShop_su_software_download_x , LShop_su_software_download_y )
	LShop_su_software_download:SetSize( LShop_su_software_download_w, LShop_su_software_download_h )
	LShop_su_software_download:SetTitle( "" )
	LShop_su_software_download:SetDraggable( false )
	LShop_su_software_download:ShowCloseButton( false )
	LShop_su_software_download:MakePopup()
	LShop_su_software_download:SetDrawOnTop( true )
	LShop_su_software_download.Think = function() 
		if ( LShop_su_software_download ) then
			LShop_su_software_download:MoveToFront() 
			
			if ( step == 0 ) then
				LShop_su_software_download.UpdateButton:SetText( "Update" )
			elseif ( step == 1 ) then
				LShop_su_software_download.UpdateButton:SetText( "Update Now" )
			elseif ( step == 2 ) then
				LShop_su_software_download.UpdateButton:SetVisible( false )
				LShop_su_software_download.CloseButton:SetVisible( false )
			end
		end
	end
	LShop_su_software_download.Paint = function()
		local x = LShop_su_software_download_x
		local y = LShop_su_software_download_y
		local w = LShop_su_software_download_w
		local h = LShop_su_software_download_h

		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )
		
		
		
		
		draw.SimpleText( "Software Update", "LShop_MainTitle", w * 0.03, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		
		if ( step == 0 ) then
			draw.SimpleText( "You can now update your LShop.", "LShop_Category_Text", w * 0.03, h * 0.13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			draw.RoundedBox( 0, 0, h * 0.2, w, h * 0.7, Color( 10, 10, 10, 50 ) )
			
			if ( LShop.Config.Version && newver ) then
				draw.SimpleText( "New Version", "LShop_Intro_TeamText", w * 0.03, h * 0.25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( newver, "LShop_Intro_TeamText", w * 0.3, h * 0.25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			
			if ( LShop.Config.Version ) then
				draw.SimpleText( "Curret Version", "LShop_Intro_TeamText", w * 0.03, h * 0.35, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( LShop.Config.Version, "LShop_Intro_TeamText", w * 0.3, h * 0.35, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			
			if ( changelog ) then
				draw.SimpleText( "Changelog", "LShop_Intro_TeamText", w * 0.03, h * 0.45, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				if ( #changelog != 0 ) then
					for k, v in pairs( changelog ) do
						local t = #changelog + 1
						
						draw.SimpleText( v, "LShop_Category_Text", w * 0.3, h * 0.6 - 30 * ( t - k ), Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				else
					draw.SimpleText( "No changelog", "LShop_Category_Text", w * 0.3, h * 0.45, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
			end
		elseif ( step == 1 ) then
			draw.SimpleText( "WARNING", "LShop_MainTitle", w * 0.5, h * 0.3, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Are you sure update software?", "LShop_Intro_TeamText", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif ( step == 2 ) then
			draw.SimpleText( "Update progress ...", "LShop_Category_Text", w * 0.03, h * 0.13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( software_update_progress_msg, "LShop_Intro_TeamText", w * 0.5, h * 0.4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	end
	
	
	net.Receive( "LShop_SU_SoftwareUpdate_Ready", function( len, cl )
		if ( LShop_su_software_download ) then
			LShop.cl.SU_update( )
			if ( LShop_AdminPanel ) then
				LShop_AdminPanel:Remove()
				LShop_AdminPanel = nil
			end
			if ( LShop_MainShopPanel ) then
				LShop_MainShopPanel:Remove()
				LShop_MainShopPanel = nil
				hook.Remove( "CalcView", "LAdmin.main.SchematicView" )
				hook.Remove( "ShouldDrawLocalPlayer", "LAdmin.main.SchematicView_Func" )
			end			
			if ( LShop_Menu01Panel ) then
				local LShop_Menu01Panel_w, LShop_Menu01Panel_h = 10 + ScrW() - 30, ScrH() * 0.8
				local LShop_Menu01Panel_x, LShop_Menu01Panel_y = 10, ScrH() + LShop_Menu01Panel_h;
				LShop_Menu01Panel:MoveTo( LShop_Menu01Panel_x, ScrH() + LShop_Menu01Panel_h, 0.3, 0 )
				timer.Simple( 0.3, function()
					if ( LShop_Menu01Panel ) then
						LShop_Menu01Panel:Remove()
						LShop_Menu01Panel = nil
					end
				end)
			end
			if ( LShop_Menu02Panel ) then
				local LShop_Menu02Panel_w, LShop_Menu02Panel_h = 10 + ScrW() - 30, ScrH() * 0.8
				local LShop_Menu02Panel_x, LShop_Menu02Panel_y = 10, ScrH() + LShop_Menu02Panel_h;
				LShop_Menu02Panel:MoveTo( LShop_Menu02Panel_x, ScrH() + LShop_Menu02Panel_w, 0.3, 0 )
				timer.Simple( 0.3, function()
					if ( LShop_Menu02Panel ) then
						LShop_Menu02Panel:Remove()
						LShop_Menu02Panel = nil
					end
				end)
			end
			if ( LShop_AdminPanel ) then
				local LShop_AdminPanel_w, LShop_AdminPanel_h = 10 + scrW - 30, scrH * 0.8
				local LShop_AdminPanel_x, LShop_AdminPanel_y = 10, scrH + LShop_AdminPanel_h;
				LShop_AdminPanel:MoveTo( LShop_AdminPanel_x, scrH + LShop_AdminPanel_w, 0.3, 0 )
				timer.Simple( 0.3, function()
					if ( LShop_AdminPanel ) then
						LShop_AdminPanel:Remove()
						LShop_AdminPanel = nil
					end
				end)	
			end
			if ( LShop_PlayerManager ) then
				local LShop_PlayerManager_w, LShop_PlayerManager_h = 10 + scrW - 30, scrH * 0.8
				local LShop_PlayerManager_x, LShop_PlayerManager_y = 10, scrH + LShop_PlayerManager_h;
				LShop_PlayerManager:MoveTo( LShop_PlayerManager_x, scrH + LShop_PlayerManager_w, 0.3, 0 )
				timer.Simple( 0.3, function()
					if ( LShop_PlayerManager ) then
						LShop_PlayerManager:Remove()
						LShop_PlayerManager = nil
					end
				end)	
			end
			LShop_su_software_download:Remove()
			LShop_su_software_download = nil
			
		end
	end)
	
	local Bx, By = LShop_su_software_download_w / 2 - LShop_su_software_download_w * 0.5 / 2, LShop_su_software_download_h * 0.93

	LShop_su_software_download.UpdateButton = vgui.Create( "DButton", LShop_su_software_download )    
	LShop_su_software_download.UpdateButton:SetText( "Update" )  
	LShop_su_software_download.UpdateButton:SetFont("LShop_ButtonText")
	LShop_su_software_download.UpdateButton:SetPos( Bx, By )  
	LShop_su_software_download.UpdateButton:SetColor(Color( 0, 0, 0, 255 ))
	LShop_su_software_download.UpdateButton:SetSize( LShop_su_software_download_w * 0.5, 35 ) 
	LShop_su_software_download.UpdateButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		if ( step == 0 ) then
			step = 1
			surface.PlaySound( "buttons/button2.wav" )
		elseif ( step == 1 ) then
			step = 2
			net.Start("LShop_SU_SoftwareUpdate")
			net.SendToServer()
		end
	end
	LShop_su_software_download.UpdateButton.Paint = function()
		local w = LShop_su_software_download.UpdateButton:GetWide()
		local h = LShop_su_software_download.UpdateButton:GetTall()
		
		surface.SetDrawColor( 50, 255, 50, 100 )
		surface.DrawRect( 0, 0, w, h )
	end

	
	local Bx, By = LShop_su_software_download_w - 40, 5

	LShop_su_software_download.CloseButton = vgui.Create( "DButton", LShop_su_software_download )    
	LShop_su_software_download.CloseButton:SetText( "X" )  
	LShop_su_software_download.CloseButton:SetFont("LShop_ButtonText")
	LShop_su_software_download.CloseButton:SetPos( Bx, By )  
	LShop_su_software_download.CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	LShop_su_software_download.CloseButton:SetSize( 35, 35 ) 
	LShop_su_software_download.CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		LShop_su_software_download:MoveTo( ScrW() / 2 - LShop_su_software_download_w / 2, ScrH() * 1.5, 0.3, 0 )
		timer.Simple(0.3 , function()
			LShop_su_software_download:Remove()
			LShop_su_software_download = nil
		end)		
	end
	LShop_su_software_download.CloseButton.Paint = function()
		local w = LShop_su_software_download.CloseButton:GetWide()
		local h = LShop_su_software_download.CloseButton:GetTall()
		
		surface.SetDrawColor( 255, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	else
		LShop_su_software_download:MoveTo( LShop_su_software_download_x, scrH + LShop_su_software_download_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_su_software_download ) then
				LShop_su_software_download:Remove()
				LShop_su_software_download = nil
			end
		end)
	end
end