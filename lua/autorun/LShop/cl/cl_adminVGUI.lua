
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
