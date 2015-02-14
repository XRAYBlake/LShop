--[[
	LShop
	Copyright ( C ) 2014 by 'L7D'
--]]

function LShop.cl.Menu02( parent, tab )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_Menu02Panel_w, LShop_Menu02Panel_h = scrW, scrH * 0.8
	local LShop_Menu02Panel_x, LShop_Menu02Panel_y = 0, scrH + LShop_Menu02Panel_h;

	if ( IsValid( LShop_Menu02Panel ) ) then
		LShop.cl.SelectedMenu = nil
		LShop_Menu02Panel:MoveTo( LShop_Menu02Panel_x, scrH + LShop_Menu02Panel_w, 0.3, 0 )
		timer.Simple( 0.3, function( )
			if ( !IsValid( LShop_Menu02Panel ) ) then return end
			LShop_Menu02Panel:Remove( )
			LShop_Menu02Panel = nil
		end )
		return
	end
	
	LShop_Menu02Panel = vgui.Create( "DFrame", parent )
	LShop_Menu02Panel:SetPos( LShop_Menu02Panel_x , LShop_Menu02Panel_y )
	LShop_Menu02Panel:MoveTo( LShop_Menu02Panel_x, scrH * 0.1, 0.3, 0 )
	LShop_Menu02Panel:SetSize( LShop_Menu02Panel_w, LShop_Menu02Panel_h )
	LShop_Menu02Panel:SetTitle( "" )
	LShop_Menu02Panel:SetDraggable( false )
	LShop_Menu02Panel:ShowCloseButton( false )
	LShop_Menu02Panel:MakePopup( )
	LShop_Menu02Panel:SetDrawOnTop( true )
	LShop_Menu02Panel.Paint = function( pnl, w, h )
		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, 0, w, 2, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, h - 2, w, 2, Color( 0, 0, 0, 255 ) )
		
		draw.SimpleText( LShop.lang.GetValue( "LShop_InvMenu_Title" ), "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( LShop.lang.GetValue_Replace( "LShop_InvMenu_Text_OwnItems", { #LShop.OwnItemsCL } ), "LShop_MoneyNotice", w * 0.99, h * 0.975, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
	
	LShop.cl.SelectedMenu = 2
	
	local ItemList = vgui.Create( "DPanelList", LShop_Menu02Panel )
	ItemList:SetPos( LShop_Menu02Panel_w * 0.5 - LShop_Menu02Panel_w * 0.98 / 2, LShop_Menu02Panel_h * 0.1 )
	ItemList:SetSize( LShop_Menu02Panel_w * 0.98 , LShop_Menu02Panel_h * 0.85 )
	ItemList:SetSpacing( 3 )
	ItemList:EnableHorizontal( false )
	ItemList:EnableVerticalScrollbar( true )
	ItemList.Paint = function( pnl, w, h )
		surface.SetDrawColor( 10, 10, 10, 0 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	function ClearInventory( )
		ItemList:Clear( )
	end
	
	function LoadInventory( )
		for k, v in pairs( LShop.OwnItemsCL ) do
			local itemInformation = LShop.system.ItemFindByID( v.ID, v.Category ) or nil
			local list = vgui.Create("DButton", ItemList)
			list:SetSize( ItemList:GetWide(), 50 )
			list:SetText("")
			list.DoClick = function()
				if ( !itemInformation ) then return end
				local Menu = DermaMenu( )
				if ( itemInformation.CanSell && LP:LShop_IsOwned( v.ID, v.Category ) ) then
					Menu:AddOption(LShop.lang.GetValue( "LShop_InvMenu_Button_Sell" ), function( ) 
						net.Start( "LShop_ItemSell" )
						net.WriteString( v.Category )
						net.WriteString( v.ID )
						net.SendToServer( )	
					end
					)
				end	
				if ( itemInformation.CanEquip && LP:LShop_IsOwned( v.ID, v.Category ) ) then
					if ( !LP:LShop_IsEquiped( v.ID, v.Category ) ) then
						Menu:AddOption(LShop.lang.GetValue( "LShop_InvMenu_Button_Equipped" ), function( ) 
							net.Start( "LShop_ItemEquip" )
							net.WriteString( v.Category )
							net.WriteString( v.ID )
							net.WriteString( "true" )
							net.SendToServer( )
							ClearInventory( )
							LoadInventory( )
						end
						)
					else
						Menu:AddOption(LShop.lang.GetValue( "LShop_InvMenu_Button_Unequipped" ), function( ) 
							net.Start( "LShop_ItemEquip" )
							net.WriteString( v.Category )
							net.WriteString( v.ID )
							net.WriteString( "false" )
							net.SendToServer( )
							ClearInventory( )
							LoadInventory( )	
						end
						)							
					end
				end
				Menu:Open( )
			end

			list.Paint = function( pnl, w, h )
				surface.SetDrawColor( 10, 10, 10, 10 )
				surface.DrawRect( 0, 0, w, h )
				
				draw.SimpleText( itemInformation.Name or "ERROR", "LShop_Category_Text", w * 0.1, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				if ( !v.onEquip ) then return end
				surface.SetMaterial( Material( "icon16/accept.png" ) )
				surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
				surface.DrawTexturedRect( w - 30, h * 0.1, 16, 16 )
			end
			
			local w, h = list:GetWide(), list:GetTall()
			
			if ( itemInformation ) then
				if ( !itemInformation.Material ) then
					local items = list:Add("SpawnIcon")
					items:SetSize( 50 - 10, 50 - 10 )
					items:SetPos( 5, 5 )
					if ( itemInformation ) then
						items:SetModel( itemInformation.Model )
					else
						items:SetModel( "models/error.mdl" )
					end
				else
					local icon = list:Add("DImage")
					icon:SetPos( 5, 5 )
					icon:SetSize( 50, h - 10 )
					if ( itemInformation.Material ) then
						icon:SetImage( itemInformation.Material )
					else
						icon:SetImage( "" )
					end
					icon:SetToolTip( false )				
				end
			end
			ItemList:AddItem( list )
		end
	end
	
	LoadInventory( )
	
	if ( IsValid( LShop_Menu01Panel ) ) then
		local LShop_Menu01Panel_w, LShop_Menu01Panel_h = 10 + scrW - 30, scrH * 0.8
		local LShop_Menu01Panel_x, LShop_Menu01Panel_y = 10, scrH + LShop_Menu01Panel_h
		LShop_Menu01Panel:MoveTo( LShop_Menu01Panel_x, scrH + LShop_Menu01Panel_w, 0.3, 0 )
		timer.Simple( 0.3, function( )
			if ( !IsValid( LShop_Menu01Panel ) ) then return end
			LShop_Menu01Panel:Remove( )
			LShop_Menu01Panel = nil
		end )	
	end
	
	if ( IsValid( LShop_AdminPanel ) ) then
		local LShop_AdminPanel_w, LShop_AdminPanel_h = 10 + scrW - 30, scrH * 0.8
		local LShop_AdminPanel_x, LShop_AdminPanel_y = 10, scrH + LShop_AdminPanel_h
		LShop_AdminPanel:MoveTo( LShop_AdminPanel_x, scrH + LShop_AdminPanel_w, 0.3, 0 )
		timer.Simple( 0.3, function( )
			if ( !IsValid( LShop_AdminPanel ) ) then return end
			LShop_AdminPanel:Remove( )
			LShop_AdminPanel = nil
		end )	
	end
	
	if ( IsValid( LShop_PlayerManager ) ) then
		local LShop_PlayerManager_w, LShop_PlayerManager_h = 10 + scrW - 30, scrH * 0.8
		local LShop_PlayerManager_x, LShop_PlayerManager_y = 10, scrH + LShop_PlayerManager_h
		LShop_PlayerManager:MoveTo( LShop_PlayerManager_x, scrH + LShop_PlayerManager_w, 0.3, 0 )
		timer.Simple( 0.3, function( )
			if ( !IsValid( LShop_PlayerManager ) ) then return end
			LShop_PlayerManager:Remove()
			LShop_PlayerManager = nil
		end )	
	end
end