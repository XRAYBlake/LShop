
local function BuildMenuGive( parent, target )
	for category_ID, items in pairs(LShop.ITEMs) do
		local category = parent:AddSubMenu( category_ID )
		
		table.sort(LShop.ITEMs, function(a, b) 
			return a.Name > b.Name
		end)
		
		for i= 1, #items do
			category:AddOption( items[i].Name, function()
				net.Start("LShop_Admin_ItemGive")
				net.WriteEntity( target )
				net.WriteString( items[i].ID )
				net.WriteString( items[i].Category )
				net.SendToServer()
			end)
		end
	end
end

local function BuildMenuTake( parent, target )
	for category_ID, items in pairs(LShop.ITEMs) do
		local category = parent:AddSubMenu( category_ID )

		table.sort(LShop.ITEMs, function(a, b) 
			return a.Name > b.Name
		end)

		for i= 1, #items do
			category:AddOption( items[i].Name, function()
				net.Start("LShop_Admin_ItemTake")
				net.WriteEntity( target )
				net.WriteString( items[i].ID )
				net.WriteString( items[i].Category )
				net.SendToServer()				
			end)
		end
	end
end

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


function LShop.cl.Admin( parent, tab )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_AdminPanel_w, LShop_AdminPanel_h = scrW, scrH * 0.8
	local LShop_AdminPanel_x, LShop_AdminPanel_y = 0, scrH + LShop_AdminPanel_h;
	local curret_version = LShop.Config.Version or "0.1"
	local new_version = ""
	local IsLatestVer = false
	local AlreadyChecked = false
	local changelog = {}
	
	net.Receive( "LShop_SU_CheckNewUpdate_SendCL", function( len, cl )
		local check = net.ReadString()
		local new_ver = net.ReadString()
		local changelogs = net.ReadTable()
		new_version = new_ver
		if ( check == "1" ) then
			IsLatestVer = false
			changelog = changelogs
		else
			IsLatestVer = true
		end
		AlreadyChecked = true
	end)
	


	if ( !LShop_AdminPanel ) then
	LShop_AdminPanel = vgui.Create("DFrame", parent)
	LShop_AdminPanel:SetPos( LShop_AdminPanel_x , LShop_AdminPanel_y )
	LShop_AdminPanel:MoveTo( LShop_AdminPanel_x, scrH * 0.1, 0.3, 0 )
	LShop_AdminPanel:SetSize( LShop_AdminPanel_w, LShop_AdminPanel_h )
	LShop_AdminPanel:SetTitle( "" )
	LShop_AdminPanel:SetDraggable( false )
	LShop_AdminPanel:ShowCloseButton( false )
	LShop_AdminPanel:MakePopup()
	LShop_AdminPanel:SetDrawOnTop( true )
	LShop_AdminPanel.Paint = function()
		local x = LShop_AdminPanel_x
		local y = LShop_AdminPanel_y
		local w = LShop_AdminPanel_w
		local h = LShop_AdminPanel_h

		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, 0, w, 2, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, h - 2, w, 2, Color( 0, 0, 0, 255 ) )
		
		draw.SimpleText( LShop.lang.GetValue( "LShop_MainButton_Admin" ), "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	net.Start("LShop_SU_CheckNewUpdate")
	net.SendToServer()
	
	local Menus = vgui.Create( "LShop_PropertySheet", LShop_AdminPanel )
	Menus:Dock( FILL )
	Menus:DockMargin(10, 50, 10, 10)
	Menus:SetPadding( 0 )
	Menus.Paint = function() end
	
	local Menu1Panel = vgui.Create("DPanel")
	Menu1Panel:Dock( FILL )
	Menu1Panel.Paint = function( panel, w, h ) 
		surface.SetDrawColor( 10, 10, 10, 20 )
		surface.DrawRect( 0, 0, w, h )	
		
		draw.SimpleText( #player.GetAll() .. "/" .. game.MaxPlayers(), "LShop_SubTitle", w * 0.01, h * 0.95, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( LShop.lang.GetValue( "LShop_AdminMenu_Menu01_Help" ), "LShop_Category_Text", w * 0.1, h * 0.95, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	local Menu2Panel = vgui.Create("DPanel")
	Menu2Panel:Dock( FILL )
	Menu2Panel.Paint = function( panel, w, h ) 
		surface.SetDrawColor( 10, 10, 10, 20 )
		surface.DrawRect( 0, 0, w, h )	
		-- IsLatestVer
		
		draw.SimpleText( "Software Update", "LShop_SubTitle", w * 0.5, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if ( AlreadyChecked ) then
			if ( IsLatestVer ) then
				draw.SimpleText( "Version is latest!", "LShop_Intro_TeamText", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "Update found!", "LShop_Intro_TeamText", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		else
			draw.SimpleText( "Checking version ...", "LShop_Category_Text", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	timer.Create( "LShop_admin_su_newversionfound_notice_create", 1.5, 0, function()
		if ( !AlreadyChecked ) then return end
		if ( !IsLatestVer ) then
			if ( !LShop_su_software_download ) then
				LShop.cl.SU_software_download( new_version, changelog )
				timer.Stop( "LShop_admin_su_newversionfound_notice_create" )
			end
		end
	end)
	
	Menu2Panel.Button1 = vgui.Create( "DButton", Menu2Panel )    
	Menu2Panel.Button1:SetText( "Recheck version" )  
	Menu2Panel.Button1:SetFont("LShop_ButtonText")
	Menu2Panel.Button1:Dock( BOTTOM )
	Menu2Panel.Button1:SetTall( 30 )
	Menu2Panel.Button1:SetColor(Color( 0, 0, 0, 255 ))
	Menu2Panel.Button1.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		net.Start("LShop_SU_CheckNewUpdate")
		net.SendToServer()
		AlreadyChecked = false
		timer.Start( "LShop_admin_su_newversionfound_notice_create" )
	end
	Menu2Panel.Button1.Paint = function()
		local w = Menu2Panel.Button1:GetWide()
		local h = Menu2Panel.Button1:GetTall()
		
		surface.SetDrawColor( 10, 10, 10, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	
	
	local Menu3Panel = vgui.Create("DPanel")
	Menu3Panel:Dock( FILL )
	Menu3Panel.Paint = function( panel, w, h ) 
		surface.SetDrawColor( 10, 10, 10, 20 )
		surface.DrawRect( 0, 0, w, h )	
		
		draw.SimpleText( "LShop", "LShop_MainTitle", w * 0.5, h * 0.1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if ( LShop.Config.Version ) then
			draw.SimpleText( LShop.Config.Version, "LShop_Category_Text", w * 0.5, h * 0.2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		draw.SimpleText( "Copyright (C) 2014 ~ 'Solar Team' - Team Leader : L7D.", "LShop_Category_Text", w * 0.5, h * 0.4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		--draw.SimpleText( "You can view changelog, issues here.", "LShop_Category_Text", w * 0.5, h * 0.8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		--draw.SimpleText( "https://github.com/SolarTeam/LShop", "LShop_MoneyNotice", w * 0.5, h * 0.85, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	Menus:AddSheet( LShop.lang.GetValue( "LShop_AdminMenu_Menu01_Title" ), Menu1Panel, "icon16/user.png", 
	false, false, false )
	Menus:AddSheet( LShop.lang.GetValue( "LShop_AdminMenu_Menu02_Title" ), Menu2Panel, "icon16/new.png", 
	false, false, false )
	Menus:AddSheet( LShop.lang.GetValue( "LShop_AdminMenu_Menu03_Title" ), Menu3Panel, "icon16/information.png", 
	false, false, false )
	
	Menu3Panel.Button1 = vgui.Create( "DButton", Menu3Panel )    
	Menu3Panel.Button1:SetText( LShop.lang.GetValue( "LShop_AdminMenu_Button_ContactUS" ) )  
	Menu3Panel.Button1:SetFont("LShop_ButtonText")
	Menu3Panel.Button1:Dock( BOTTOM )
	Menu3Panel.Button1:SetTall( 30 )
	Menu3Panel.Button1:SetColor(Color( 0, 0, 0, 255 ))
	Menu3Panel.Button1.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		gui.OpenURL( "http://steamcommunity.com/profiles/76561198011675377" )
	end
	Menu3Panel.Button1.Paint = function()
		local w = Menu3Panel.Button1:GetWide()
		local h = Menu3Panel.Button1:GetTall()
		
		surface.SetDrawColor( 10, 10, 10, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local PlayerList = vgui.Create( "DPanelList", Menu1Panel )
	PlayerList:Dock( FILL )
	PlayerList:DockMargin( 0, 0, 0, 50 )
	PlayerList:SetSpacing( 3 )
	PlayerList:EnableHorizontal( false )
	PlayerList:EnableVerticalScrollbar( true )
	PlayerList.Paint = function()
		local w, h = PlayerList:GetWide(), PlayerList:GetTall()
		surface.SetDrawColor( 10, 10, 10, 10 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	function Admin_PlayerListClear()
		PlayerList:Clear()
	end

	function Admin_PlayerListAdd()
		for k, v in pairs( player.GetAll() ) do
			local color = Color( 10, 10, 10, 10 )
			local list = vgui.Create( "DButton", PlayerList )    
			list:SetSize( PlayerList:GetWide(), 50 ) 
			list:SetText("")
			list.DoClick = function()
				if ( LShop.Config.PermissionCheck( LP ) ) then
					local Menu = DermaMenu()
					Menu:AddOption( LShop.lang.GetValue( "LShop_AdminMenu_Button_MoneySet" ), function()
						Derma_StringRequest(
							LShop.lang.GetValue_Replace( "LShop_AdminMenu_MoneySet_StringRequest_Title", { v:Name() } ),
							LShop.lang.GetValue( "LShop_AdminMenu_MoneySet_StringRequest_Value" ),
							v:LShop_GetMoney(),
							function( str )
								if ( !str ) then
									return
								end
								if ( type( str ) == "string" ) then
									str = tonumber( str )
								end
								
								net.Start("LShop_Admin_SetMoney")
									net.WriteEntity( v )
									net.WriteString( str )
								net.SendToServer()
							end
						)					
					end)
					BuildMenuGive( Menu:AddSubMenu( LShop.lang.GetValue( "LShop_AdminMenu_Button_GiveItem" ) ), v )
					BuildMenuTake( Menu:AddSubMenu( LShop.lang.GetValue( "LShop_AdminMenu_Button_TakeItem" ) ), v )
					Menu:Open()
				else
					LShop.cl.SelectedMenu = nil
					LShop_AdminPanel:MoveTo( LShop_AdminPanel_x, scrH + LShop_AdminPanel_w, 0.3, 0 )
					timer.Simple( 0.3, function()
						if ( LShop_AdminPanel ) then
							LShop_AdminPanel:Remove()
							LShop_AdminPanel = nil
						end
					end)	
					Derma_Message( "YOU ARE NOT HAVE PERMISSION! :(", "WARNING", "OK" )
				end
			end
			list.OnCursorEntered = function()
				color = Color( 10, 255, 10, 50 )
			end
			list.OnCursorExited = function()
				color = Color( 10, 10, 10, 10 )
			end
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				
				surface.SetDrawColor( color )
				surface.DrawRect( 0, 0, w, h )

				draw.SimpleText( v:Name(), "LShop_Category_Text", w * 0.01, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v:LShop_GetMoney(), "LShop_Category_Text", w * 0.99, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			PlayerList:AddItem( list )
		end
	end
	
	Admin_PlayerListAdd()

	if ( LShop_Menu01Panel ) then
		local LShop_Menu01Panel_w, LShop_Menu01Panel_h = 10 + scrW - 30, scrH * 0.8
		local LShop_Menu01Panel_x, LShop_Menu01Panel_y = 10, scrH + LShop_Menu01Panel_h;
		LShop_Menu01Panel:MoveTo( LShop_Menu01Panel_x, scrH + LShop_Menu01Panel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_Menu01Panel ) then
				LShop_Menu01Panel:Remove()
				LShop_Menu01Panel = nil
			end
		end)	
	end
	
	if ( LShop_Menu02Panel ) then
		local LShop_Menu02Panel_w, LShop_Menu02Panel_h = 10 + scrW - 30, scrH * 0.8
		local LShop_Menu02Panel_x, LShop_Menu02Panel_y = 10, scrH + LShop_Menu02Panel_h;
		LShop_Menu02Panel:MoveTo( LShop_Menu02Panel_x, scrH + LShop_Menu02Panel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_Menu02Panel ) then
				LShop_Menu02Panel:Remove()
				LShop_Menu02Panel = nil
			end
		end)	
	end
	
	LShop.cl.SelectedMenu = 3
	
	else
		LShop.cl.SelectedMenu = nil
		timer.Destroy( "LShop_admin_su_newversionfound_notice_create" )
		LShop_AdminPanel:MoveTo( LShop_AdminPanel_x, scrH + LShop_AdminPanel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_AdminPanel ) then
				LShop_AdminPanel:Remove()
				LShop_AdminPanel = nil
			end
		end)
	end
end
