--[[
	LShop
	Copyright ( C ) 2014 by 'L7D'
--]]

local function BuildMenuGive( parent, target )
	for category_ID, items in pairs( LShop.system.GetItems( ) ) do
		local category = parent:AddSubMenu( category_ID )
		
		table.sort( LShop.system.GetItems( ), function( a, b ) 
			return a.Name > b.Name
		end )
		
		for i= 1, #items do
			category:AddOption( items[i].Name, function( )
				net.Start( "LShop_Admin_ItemGive" )
				net.WriteEntity( target )
				net.WriteString( items[i].ID )
				net.WriteString( items[i].Category )
				net.SendToServer( )
			end )
		end
	end
end

local function BuildMenuTake( parent, target )
	for category_ID, items in pairs( LShop.system.GetItems( ) ) do
		local category = parent:AddSubMenu( category_ID )

		table.sort( LShop.system.GetItems( ), function( a, b ) 
			return a.Name > b.Name
		end )

		for i= 1, #items do
			category:AddOption( items[i].Name, function( )
				net.Start( "LShop_Admin_ItemTake" )
				net.WriteEntity( target )
				net.WriteString( items[i].ID )
				net.WriteString( items[i].Category )
				net.SendToServer( )				
			end )
		end
	end
end

function LShop.cl.Admin( parent, tab )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_AdminPanel_w, LShop_AdminPanel_h = scrW, scrH * 0.8
	local LShop_AdminPanel_x, LShop_AdminPanel_y = 0, scrH + LShop_AdminPanel_h;
	local new_version = ""
		
	net.Receive( "LShop_versioncheck_CheckSendCL", function( len, cl )
		new_version = net.ReadString()
	end )
	
	net.Start( "LShop_versioncheck_Check" )
	net.SendToServer( )
	
	if ( IsValid( LShop_AdminPanel ) ) then
		LShop.cl.SelectedMenu = nil
		timer.Destroy( "LShop_admin_su_newversionfound_notice_create" )
		LShop_AdminPanel:MoveTo( LShop_AdminPanel_x, scrH + LShop_AdminPanel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_AdminPanel ) then
				LShop_AdminPanel:Remove()
				LShop_AdminPanel = nil
			end
		end )
		return
	end
	
	LShop_AdminPanel = vgui.Create( "DFrame", parent )
	LShop_AdminPanel:SetPos( LShop_AdminPanel_x , LShop_AdminPanel_y )
	LShop_AdminPanel:MoveTo( LShop_AdminPanel_x, scrH * 0.1, 0.3, 0 )
	LShop_AdminPanel:SetSize( LShop_AdminPanel_w, LShop_AdminPanel_h )
	LShop_AdminPanel:SetTitle( "" )
	LShop_AdminPanel:SetDraggable( false )
	LShop_AdminPanel:ShowCloseButton( false )
	LShop_AdminPanel:MakePopup( )
	LShop_AdminPanel:SetDrawOnTop( true )
	LShop_AdminPanel.Paint = function( pnl, w, h )
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, 0, w, 2, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, h - 2, w, 2, Color( 0, 0, 0, 255 ) )
		
		draw.SimpleText( LShop.lang.GetValue( "LShop_MainButton_Admin" ), "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	local Menus = vgui.Create( "LShop_PropertySheet", LShop_AdminPanel )
	Menus:Dock( FILL )
	Menus:DockMargin(10, 50, 10, 10)
	Menus:SetPadding( 0 )
	Menus.Paint = function( ) end
	local Menu1Panel = vgui.Create( "DPanel" )
	Menu1Panel:Dock( FILL )
	Menu1Panel.Paint = function( pnl, w, h ) 
		surface.SetDrawColor( 10, 10, 10, 20 )
		surface.DrawRect( 0, 0, w, h )	
		
		draw.SimpleText( #player.GetAll( ) .. "/" .. game.MaxPlayers( ), "LShop_SubTitle", w * 0.01, h * 0.95, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( LShop.lang.GetValue( "LShop_AdminMenu_Menu01_Help" ), "LShop_Category_Text", w * 0.1, h * 0.95, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	local Menu2Panel = vgui.Create( "DPanel" )
	Menu2Panel:Dock( FILL )
	Menu2Panel.Paint = function( pnl, w, h ) 
		surface.SetDrawColor( 10, 10, 10, 20 )
		surface.DrawRect( 0, 0, w, h )	
		
		draw.SimpleText( "LShop", "LShop_MainTitle", w * 0.5, h * 0.1, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( LShop.lang.GetValue_Replace( "LShop_AdminMenu_Menu02_CurVerStr", { LShop.Config.Version or "0.1" } ), "LShop_Category_Text", w * 0.5, h * 0.2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( LShop.lang.GetValue_Replace( "LShop_AdminMenu_Menu02_NewVerStr", { new_version or "" } ), "LShop_Category_Text", w * 0.5, h * 0.2 + 30, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if ( LShop.Config.Version != new_version ) then
			draw.SimpleText( LShop.lang.GetValue( "LShop_AdminMenu_Menu02_NewVerNotStr" ), "LShop_Category_Text", w * 0.5, h * 0.4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif ( LShop.Config.Version == new_version ) then
			draw.SimpleText( LShop.lang.GetValue( "LShop_AdminMenu_Menu02_CurVerNotStr" ), "LShop_Category_Text", w * 0.5, h * 0.4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		draw.SimpleText( "Copyright ( C ) 2014 by 'L7D'", "LShop_Intro_LoadText", w * 0.5, h - 60, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	Menus:AddSheet( LShop.lang.GetValue( "LShop_AdminMenu_Menu01_Title" ), Menu1Panel, "icon16/user.png", 
	false, false, false )
	Menus:AddSheet( LShop.lang.GetValue( "LShop_AdminMenu_Menu02_Title" ), Menu2Panel, "icon16/information.png", 
	false, false, false )
	
	Menu2Panel.Button1 = vgui.Create( "DButton", Menu2Panel )    
	Menu2Panel.Button1:SetText( LShop.lang.GetValue( "LShop_AdminMenu_Button_ContactUS" ) )  
	Menu2Panel.Button1:SetFont( "LShop_ButtonText" )
	Menu2Panel.Button1:Dock( BOTTOM )
	Menu2Panel.Button1:SetTall( 30 )
	Menu2Panel.Button1:SetColor( Color( 0, 0, 0, 255 ) )
	Menu2Panel.Button1.DoClick = function( )
		surface.PlaySound( "ui/buttonclick.wav" )
		gui.OpenURL( "http://steamcommunity.com/profiles/76561198011675377" )
	end
	Menu2Panel.Button1.Paint = function( pnl, w, h )
		surface.SetDrawColor( 10, 10, 10, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local PlayerList = vgui.Create( "DPanelList", Menu1Panel )
	PlayerList:Dock( FILL )
	PlayerList:DockMargin( 0, 0, 0, 50 )
	PlayerList:SetSpacing( 3 )
	PlayerList:EnableHorizontal( false )
	PlayerList:EnableVerticalScrollbar( true )
	PlayerList.Paint = function( pnl, w, h )
		surface.SetDrawColor( 10, 10, 10, 10 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	function Admin_PlayerListClear( )
		PlayerList:Clear( )
	end

	function Admin_PlayerListAdd( )
		for k, v in pairs( player.GetAll( ) ) do
			local color = Color( 10, 10, 10, 10 )
			local list = vgui.Create( "DButton", PlayerList )    
			list:SetSize( PlayerList:GetWide(), 70 ) 
			list:SetText( "" )
			list.DoClick = function( )
				if ( !LShop.Config.PermissionCheck( LP ) ) then
					if ( IsValid( LShop_AdminPanel ) ) then
						LShop.cl.SelectedMenu = nil
						timer.Destroy( "LShop_admin_su_newversionfound_notice_create" )
						LShop_AdminPanel:MoveTo( LShop_AdminPanel_x, scrH + LShop_AdminPanel_w, 0.3, 0 )
						timer.Simple( 0.3, function( )
							if ( !IsValid( LShop_AdminPanel ) ) then return end
							LShop_AdminPanel:Remove( )
							LShop_AdminPanel = nil
						end )
					end
					Derma_Message( "당신은 권한이 없습니다.", "경고", "확인" )
					return
				end
				local Menu = DermaMenu( )
				Menu:AddOption( LShop.lang.GetValue( "LShop_AdminMenu_Button_MoneySet" ), function()
					Derma_StringRequest(
						LShop.lang.GetValue_Replace( "LShop_AdminMenu_MoneySet_StringRequest_Title", { v:Name( ) } ),
						LShop.lang.GetValue( "LShop_AdminMenu_MoneySet_StringRequest_Value" ),
						v:LShop_GetMoney( ),
						function( str )
							if ( !str ) then return end
							if ( type( str ) == "string" ) then str = tonumber( str ) end
							net.Start( "LShop_Admin_SetMoney" )
							net.WriteEntity( v )
							net.WriteString( str )
							net.SendToServer( )
						end
					)					
				end )
				BuildMenuGive( Menu:AddSubMenu( LShop.lang.GetValue( "LShop_AdminMenu_Button_GiveItem" ) ), v )
				BuildMenuTake( Menu:AddSubMenu( LShop.lang.GetValue( "LShop_AdminMenu_Button_TakeItem" ) ), v )
				Menu:AddOption( LShop.lang.GetValue( "LShop_AdminMenu_Button_CopySteamID" ), function()
					SetClipboardText( v:SteamID( ) )
				end )
				Menu:AddOption( LShop.lang.GetValue( "LShop_AdminMenu_Button_OpenSteamProfile" ), function()
					gui.OpenURL( "http://steamcommunity.com/profiles/" .. util.SteamIDTo64( v:SteamID( ) ) )
				end )
				Menu:Open( )
			end
			list.OnCursorEntered = function( ) color = Color( 10, 255, 10, 50 ) end
			list.OnCursorExited = function( ) color = Color( 10, 10, 10, 10 ) end
			list.Paint = function( pnl, w, h )
				if ( !IsValid( v ) ) then return end
				surface.SetDrawColor( color )
				surface.DrawRect( 0, 0, w, h )

				draw.SimpleText( v:Name( ), "LShop_Category_Text", 5 + 60 + 15, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v:GetNWString( "usergroup" ), "LShop_Category_Text", w * 0.4, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v:SteamID( ) .. "    |    " .. v:LShop_GetMoney( ) .. " $", "LShop_Category_Text", w * 0.99, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			local avatar = vgui.Create( "AvatarImage", list )
			avatar:SetPos( 5, list:GetTall( ) / 2 - 60 / 2 )
			avatar:SetSize( 60, 60 )
			avatar:SetPlayer( v, 60 )
			
			PlayerList:AddItem( list )
		end
	end
	
	Admin_PlayerListAdd( )

	if ( IsValid( LShop_Menu01Panel ) ) then
		local LShop_Menu01Panel_w, LShop_Menu01Panel_h = 10 + scrW - 30, scrH * 0.8
		local LShop_Menu01Panel_x, LShop_Menu01Panel_y = 10, scrH + LShop_Menu01Panel_h;
		LShop_Menu01Panel:MoveTo( LShop_Menu01Panel_x, scrH + LShop_Menu01Panel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( !IsValid( LShop_Menu01Panel ) ) then return end
			LShop_Menu01Panel:Remove( )
			LShop_Menu01Panel = nil
		end )	
	end
	
	if ( IsValid( LShop_Menu02Panel ) ) then
		local LShop_Menu02Panel_w, LShop_Menu02Panel_h = 10 + scrW - 30, scrH * 0.8
		local LShop_Menu02Panel_x, LShop_Menu02Panel_y = 10, scrH + LShop_Menu02Panel_h;
		LShop_Menu02Panel:MoveTo( LShop_Menu02Panel_x, scrH + LShop_Menu02Panel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( !IsValid( LShop_Menu02Panel ) ) then return end
			LShop_Menu02Panel:Remove( )
			LShop_Menu02Panel = nil
		end )	
	end
	
	LShop.cl.SelectedMenu = 3
end