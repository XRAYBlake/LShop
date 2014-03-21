/*
function LShop.cl.ItemGiftMenu( itemID, category )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_ItemGiftMenu_w, LShop_ItemGiftMenu_h = 10 + scrW - 30, scrH * 0.5
	local LShop_ItemGiftMenu_x, LShop_ItemGiftMenu_y = 10, scrH + LShop_ItemGiftMenu_h;
	if ( !LShop_ItemGiftMenu ) then
	LShop_ItemGiftMenu = vgui.Create("DFrame", parent)
	LShop_ItemGiftMenu:SetPos( LShop_ItemGiftMenu_x , LShop_ItemGiftMenu_y )
	LShop_ItemGiftMenu:MoveTo( LShop_ItemGiftMenu_x, scrH * 0.1, 0.3, 0 )
	LShop_ItemGiftMenu:SetSize( LShop_ItemGiftMenu_w, LShop_ItemGiftMenu_h )
	LShop_ItemGiftMenu:SetTitle( "" )
	LShop_ItemGiftMenu:SetDraggable( false )
	LShop_ItemGiftMenu:ShowCloseButton( true )
	LShop_ItemGiftMenu:MakePopup()
	--LShop_ItemGiftMenu:SetDrawOnTop( true )
	LShop_ItemGiftMenu.Think = function()
		if ( LShop_ItemGiftMenu ) then
			LShop_ItemGiftMenu:MoveToFront()
		end
	end
	LShop_ItemGiftMenu.Paint = function()
		local x = LShop_ItemGiftMenu_x
		local y = LShop_ItemGiftMenu_y
		local w = LShop_ItemGiftMenu_w
		local h = LShop_ItemGiftMenu_h

		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "Item Gift", "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	local Bx, By = 40, LShop_ItemGiftMenu_h - 40

	local CloseButton = vgui.Create( "DButton", LShop_ItemGiftMenu )    
	CloseButton:SetText( "X" )  
	CloseButton:SetFont("LShop_ButtonText")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( 35, 35 ) 
	CloseButton.DoClick = function(  )
		LShop_ItemGiftMenu:MoveTo( LShop_ItemGiftMenu_x, scrH + LShop_ItemGiftMenu_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_ItemGiftMenu ) then
				LShop_ItemGiftMenu:Remove()
				LShop_ItemGiftMenu = nil
			end
		end)	
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 255, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	else
		LShop_ItemGiftMenu:Remove()
		LShop_ItemGiftMenu = nil
	end
end
*/

function LShop.cl.Menu01( parent, tab )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_Menu01Panel_w, LShop_Menu01Panel_h = 10 + scrW - 30, scrH * 0.8
	local LShop_Menu01Panel_x, LShop_Menu01Panel_y = 10, scrH + LShop_Menu01Panel_h;
	local itemInformation = {}
	itemInformation.Name = ""
	itemInformation.Price = 0
	itemInformation.Desc = ""
	local SelectItem = {}
	SelectItem.ID = nil
	SelectItem.Category = nil
	SelectItem.EquBool = nil
	
	net.Start("LShop_SendTable_Request")
	net.SendToServer()
	
	local ButtonMode = 1
	
	if ( !LShop_Menu01Panel ) then
	LShop_Menu01Panel = vgui.Create("DFrame", parent)
	LShop_Menu01Panel:SetPos( LShop_Menu01Panel_x , LShop_Menu01Panel_y )
	LShop_Menu01Panel:MoveTo( LShop_Menu01Panel_x, scrH * 0.1, 0.3, 0 )
	LShop_Menu01Panel:SetSize( LShop_Menu01Panel_w, LShop_Menu01Panel_h )
	LShop_Menu01Panel:SetTitle( "" )
	LShop_Menu01Panel:SetDraggable( false )
	LShop_Menu01Panel:ShowCloseButton( false )
	LShop_Menu01Panel:MakePopup()
	LShop_Menu01Panel:SetDrawOnTop( true )
	LShop_Menu01Panel.Think = function()
		if ( LShop_Menu01Panel ) then
			if ( SelectItem.ID ) then
				local Find = LShop.system.ItemFindByID( SelectItem.ID, SelectItem.Category )

				if ( Find.CanEquip && LP:LShop_IsOwned( SelectItem.ID, SelectItem.Category ) ) then
					if ( !LP:LShop_IsEquiped( SelectItem.ID, SelectItem.Category ) ) then
						LShop_Menu01Panel.Action:SetVisible( true )
						LShop_Menu01Panel.Action:SetText( "Equip" )  
					else
						LShop_Menu01Panel.Action:SetVisible( true )
						LShop_Menu01Panel.Action:SetText( "Unequip" )  
					end
				else
					LShop_Menu01Panel.Action:SetVisible( false )
				end
				if ( Find.CanBuy && !LP:LShop_IsOwned( SelectItem.ID, SelectItem.Category )  ) then
					LShop_Menu01Panel.Buy:SetVisible( true )
					LShop_Menu01Panel.Buy:SetText( "Buy" )  
					ButtonMode = 1
				elseif ( Find.CanSell && LP:LShop_IsOwned( SelectItem.ID, SelectItem.Category )  ) then
					LShop_Menu01Panel.Buy:SetVisible( true )
					LShop_Menu01Panel.Buy:SetText( "Sell" )  
					ButtonMode = 0
				end
				if ( !LP:LShop_IsEquiped( SelectItem.ID, SelectItem.Category ) ) then
					SelectItem.EquBool = true
				else
					SelectItem.EquBool = false
				end
			end
		end
	end
	LShop_Menu01Panel.Paint = function()
		local x = LShop_Menu01Panel_x
		local y = LShop_Menu01Panel_y
		local w = LShop_Menu01Panel_w
		local h = LShop_Menu01Panel_h

		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )
		
		
		surface.SetDrawColor( 10, 10, 10, 10 )
		surface.DrawRect( w * 0.75, h * 0.1, w * 0.25 - 20, h * 0.85 )

		draw.SimpleText( "Shop", "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		if ( itemInformation.Name != "" ) then
			draw.SimpleText( itemInformation.Name, "LShop_SubTitle", w * 0.87, h * 0.7, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		if ( itemInformation.Desc != "" ) then
			draw.SimpleText( itemInformation.Desc, "LShop_Category_Text", w * 0.87, h * 0.75, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		if ( itemInformation.Price != 0 ) then
			draw.SimpleText( itemInformation.Price .. " $", "LShop_SubTitle", w * 0.87, h * 0.85, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	LShop.cl.SelectedMenu = 1
	
	local CategoryList = vgui.Create( "DPanelList", LShop_Menu01Panel )
	CategoryList:SetPos( LShop_Menu01Panel_w * 0.01, LShop_Menu01Panel_h * 0.1 )
	CategoryList:SetSize( LShop_Menu01Panel_w * 0.15 , LShop_Menu01Panel_h * 0.85 )
	CategoryList:SetSpacing( 3 )
	CategoryList:EnableHorizontal( false )
	CategoryList:EnableVerticalScrollbar( true )
	CategoryList.Paint = function()
		local w, h = CategoryList:GetWide(), CategoryList:GetTall()
		surface.SetDrawColor( 10, 10, 10, 30 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local ItemList = vgui.Create( "DPanelList", LShop_Menu01Panel )
	ItemList:SetPos( LShop_Menu01Panel_w * 0.2, LShop_Menu01Panel_h * 0.1 )
	ItemList:SetSize( LShop_Menu01Panel_w * 0.5 , LShop_Menu01Panel_h * 0.85 )
	ItemList:SetSpacing( 3 )
	ItemList:EnableHorizontal( false )
	ItemList:EnableVerticalScrollbar( true )
	ItemList.Paint = function()
		local w, h = ItemList:GetWide(), ItemList:GetTall()
		surface.SetDrawColor( 10, 10, 10, 10 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	function CategoryListClear()
		CategoryList:Clear()
	end

	function CategoryListAdd()
		for k, v in pairs( LShop.system.GetItems( ) ) do
			local color = Color( 10, 10, 10, 10 )
			local list = vgui.Create( "DButton", CategoryList )    
			list:SetSize( CategoryList:GetWide(), 70 ) 
			list:SetText("")
			list.DoClick = function()
				LShop.cl.SelectedCategory = k
				ItemListClear()
				ItemListAdd( LShop.cl.SelectedCategory )
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
				
				if ( LShop.cl.SelectedCategory == k ) then
					surface.SetDrawColor( 10, 10, 10, 100 )
					surface.DrawRect( 0, 0, w, h )				
				end
				
				draw.SimpleText( k, "LShop_Category_Text", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			CategoryList:AddItem( list )
		end
	end
	
	function ItemListClear()
		ItemList:Clear()
	end
	
	function ItemListAdd( category )
		if ( !category ) then
			return
		end
		for k, v in pairs( LShop.system.GetItems( )[ category ] ) do
			local list = vgui.Create( "DButton", ItemList )    
			list:SetSize( ItemList:GetWide(), 50 ) 
			list:SetText("")
			list.DoClick = function()
				surface.PlaySound( "ui/buttonclick.wav" )		
				local Menu = DermaMenu( )
				SelectItem.ID = v.ID
				SelectItem.Category = v.Category
				if ( v.CanEquip && LP:LShop_IsOwned( v.ID, SelectItem.Category ) ) then
					if ( !LP:LShop_IsEquiped( v.ID, v.Category ) ) then
						SelectItem.EquBool = true
					else
						SelectItem.EquBool = false
					end
				end
				itemInformation.Name = v.Name
				itemInformation.Price = v.Price
				itemInformation.Desc = v.Desc
				SelectItemmodel:SetModel( v.Model )
			end
			list.OnCursorEntered = function() end
			list.OnCursorExited = function() end
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				surface.SetDrawColor( 10, 10, 10, 30 )
				surface.DrawRect( 0, 0, w, h )
				
				draw.SimpleText( v.Name, "LShop_Category_Text", w * 0.1, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v.Price, "LShop_Category_Text", w * 0.96, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				
				surface.SetMaterial( Material("icon16/money_dollar.png") )
				surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
				surface.DrawTexturedRect( w - 20, h / 2 - 16 / 2, 16, 16 )
				
			end
			
			local w, h = list:GetWide(), list:GetTall()
			
			local icon = list:Add("SpawnIcon")
			icon:SetPos( 5, 5 )
			icon:SetSize( 50 - 10, h - 10 )
			if ( v.Model ) then
				icon:SetModel( v.Model )
			else
				icon:SetModel( "models/error.mdl" )
			end
			icon:SetToolTip( false )
			ItemList:AddItem( list )
		end
	end
	
	SelectItemmodel = vgui.Create("DModelPanel", LShop_Menu01Panel)
	SelectItemmodel:SetSize( LShop_Menu01Panel_w * 0.2, LShop_Menu01Panel_h * 0.65 )
	SelectItemmodel:SetPos( LShop_Menu01Panel_w * 0.87 - LShop_Menu01Panel_w * 0.2 / 2, LShop_Menu01Panel_h * 0.13 )
	SelectItemmodel:SetFOV( 50 )
	SelectItemmodel:SetCamPos( Vector( 50, 50, 5 ) )
	SelectItemmodel:SetLookAt( Vector( 0, 0, 0 ) )
	SelectItemmodel.OnCursorEntered = function() end
	SelectItemmodel:SetDisabled( true )
	SelectItemmodel:SetCursor( "none" )
	SelectItemmodel:MoveToBack()
	SelectItemmodel:SetVisible( true )
	SelectItemmodel.PaintOver = function() end
		
	local Bx, By = scrW * 0.75, LShop_Menu01Panel_h * 0.9 - 10

	LShop_Menu01Panel.Buy = vgui.Create( "DButton", LShop_Menu01Panel )    
	LShop_Menu01Panel.Buy:SetText( "" )  
	LShop_Menu01Panel.Buy:SetFont("LShop_ButtonText2")
	LShop_Menu01Panel.Buy:SetPos( Bx, By )  
	LShop_Menu01Panel.Buy:SetColor(Color( 0, 0, 0, 255 ))
	LShop_Menu01Panel.Buy:SetVisible( false )
	LShop_Menu01Panel.Buy:SetSize( LShop_Menu01Panel_w * 0.22, 35 ) 
	LShop_Menu01Panel.Buy.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		if ( ButtonMode == 1 ) then
			if ( LShop.Config.ItemGiftSystem ) then
				local Menu = DermaMenu()
				Menu:AddOption( "Buy", function()
					net.Start("LShop_ItemBuy")
					net.WriteString( SelectItem.Category )
					net.WriteString( SelectItem.ID )
					net.SendToServer()					
				end)
				local submenu = Menu:AddSubMenu( "Gift to player" )
				for k, v in pairs( player.GetAll() ) do
					if ( v:SteamID() != LP:SteamID() ) then
						submenu:AddOption( v:Name(), function()
							net.Start("LShop_ItemSend")
							net.WriteEntity( v )
							net.WriteString( SelectItem.ID )
							net.WriteString( SelectItem.Category )
							net.SendToServer()
						end)
					end
				end
				Menu:Open()
			else
				net.Start("LShop_ItemBuy")
				net.WriteString( SelectItem.Category )
				net.WriteString( SelectItem.ID )
				net.SendToServer()				
			end
		else
			net.Start("LShop_ItemSell")
			net.WriteString( SelectItem.Category )
			net.WriteString( SelectItem.ID )
			net.SendToServer()			
		end
	end
	LShop_Menu01Panel.Buy.Paint = function()
		local w = LShop_Menu01Panel.Buy:GetWide()
		local h = LShop_Menu01Panel.Buy:GetTall()
		if ( ButtonMode == 1 ) then
			surface.SetDrawColor( 10, 255, 10, 50 )
			surface.DrawRect( 0, 0, w, h )
		else
			surface.SetDrawColor( 255, 10, 10, 50 )
			surface.DrawRect( 0, 0, w, h )		
		end
	end
	
	local Bx, By = scrW * 0.86 - LShop_Menu01Panel_w * 0.15 / 2, LShop_Menu01Panel_h * 0.11

	LShop_Menu01Panel.Action = vgui.Create( "DButton", LShop_Menu01Panel )    
	LShop_Menu01Panel.Action:SetText( "" )  
	LShop_Menu01Panel.Action:SetFont("LShop_ButtonText")
	LShop_Menu01Panel.Action:SetPos( Bx, By )  
	LShop_Menu01Panel.Action:SetVisible( false )
	LShop_Menu01Panel.Action:SetColor(Color( 0, 0, 0, 255 ))
	LShop_Menu01Panel.Action:SetSize( LShop_Menu01Panel_w * 0.15, 35 ) 
	LShop_Menu01Panel.Action.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		local Find = LShop.system.ItemFindByID( SelectItem.ID, SelectItem.Category )
		if ( Find.CanEquip && LP:LShop_IsOwned( SelectItem.ID, SelectItem.Category ) ) then
			if ( !LP:LShop_IsEquiped( SelectItem.ID, SelectItem.Category ) ) then
				net.Start("LShop_ItemEquip")
				net.WriteString( SelectItem.Category )
				net.WriteString( SelectItem.ID )
				net.WriteString( tostring( SelectItem.EquBool ) )
				net.SendToServer()		
			else
				net.Start("LShop_ItemEquip")
				net.WriteString( SelectItem.Category )
				net.WriteString( SelectItem.ID )
				net.WriteString( tostring( SelectItem.EquBool ) )
				net.SendToServer()		
			end
		end
	end
	LShop_Menu01Panel.Action.Paint = function()
		local w = LShop_Menu01Panel.Action:GetWide()
		local h = LShop_Menu01Panel.Action:GetTall()
		
		surface.SetDrawColor( 10, 10, 10, 30 )
		surface.DrawRect( 0, 0, w, h )
	end

	CategoryListClear()
	CategoryListAdd()
	
	if ( LShop.cl.SelectedCategory ) then
		ItemListClear()
		ItemListAdd( LShop.cl.SelectedCategory )
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

	else
		LShop.cl.SelectedMenu = nil
		LShop_Menu01Panel:MoveTo( LShop_Menu01Panel_x, scrH + LShop_Menu01Panel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_Menu01Panel ) then
				LShop_Menu01Panel:Remove()
				LShop_Menu01Panel = nil
			end
		end)
	end
end