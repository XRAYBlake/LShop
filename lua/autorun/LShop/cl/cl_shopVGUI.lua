
function LShop.cl.ItemRunProgress( itemID, category )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_ItemRunProgress_w, LShop_ItemRunProgress_h = scrW, scrH
	local LShop_ItemRunProgress_x, LShop_ItemRunProgress_y = scrW / 2 - LShop_ItemRunProgress_w / 2, scrH + LShop_ItemRunProgress_h;
	local Find = LShop.system.ItemFindByID( itemID, category )
	local backgroundAlpha = 0
	local modelStop = false
	
	if ( !LShop_ItemRunProgress ) then
	LShop_ItemRunProgress = vgui.Create("DFrame", parent)
	LShop_ItemRunProgress:SetPos( LShop_ItemRunProgress_x , LShop_ItemRunProgress_y )
	LShop_ItemRunProgress:MoveTo( LShop_ItemRunProgress_x, scrH / 2 - LShop_ItemRunProgress_h / 2, 0.3, 0 )
	LShop_ItemRunProgress:SetSize( LShop_ItemRunProgress_w, LShop_ItemRunProgress_h )
	LShop_ItemRunProgress:SetTitle( "" )
	LShop_ItemRunProgress:SetDraggable( false )
	LShop_ItemRunProgress:ShowCloseButton( true )
	LShop_ItemRunProgress:MakePopup()
	LShop_ItemRunProgress.Think = function()
		if ( LShop_ItemRunProgress ) then
			if ( itemID && category ) then
				
				if ( Find.CanBuy && !LP:LShop_IsOwned( itemID, category )  ) then
					LShop_ItemRunProgress.MainAction:SetVisible( true )
					LShop_ItemRunProgress.MainAction:SetText( "Buy" )  
					LShop_ItemRunProgress.ItemGiftAction:SetVisible( true )
					local Bx, By = LShop_ItemRunProgress_w / 2 - LShop_ItemRunProgress_w * 0.39 / 2, LShop_ItemRunProgress_h * 0.9
					LShop_ItemRunProgress.MainAction:SetPos( Bx, By )  
					ButtonMode = 1
				elseif ( Find.CanSell && LP:LShop_IsOwned( itemID, category )  ) then
					LShop_ItemRunProgress.MainAction:SetVisible( true )
					LShop_ItemRunProgress.MainAction:SetText( "Sell" )  
					LShop_ItemRunProgress.ItemGiftAction:SetVisible( false )
					local Bx, By = LShop_ItemRunProgress_w / 2 - LShop_ItemRunProgress_w * 0.39 / 2, LShop_ItemRunProgress_h * 0.95
					LShop_ItemRunProgress.MainAction:SetPos( Bx, By )  
					ButtonMode = 0
				end
			end
		end
	end
	LShop_ItemRunProgress.Paint = function()
		local x = LShop_ItemRunProgress_x
		local y = LShop_ItemRunProgress_y
		local w = LShop_ItemRunProgress_w
		local h = LShop_ItemRunProgress_h
		
		backgroundAlpha = math.Approach( backgroundAlpha, 210, 3 )
		
		surface.SetDrawColor( 0, 0, 0, backgroundAlpha )
		surface.DrawRect( 0, 0, w, h )
		
		surface.SetDrawColor( 255, 255, 255, 200 )
		surface.DrawRect( w / 2 - w * 0.4 / 2, 0, w * 0.4, h )
		
		surface.SetDrawColor( 0, 0, 0, 30 )
		surface.DrawRect( w / 2 - w * 0.4 / 2, 0, w * 0.4, h * 0.1 )
		
		if ( Find.CanSell && !LP:LShop_IsOwned( itemID, category )  ) then
			draw.SimpleText( "Item Buy", "LShop_MainTitle", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif ( Find.CanSell && LP:LShop_IsOwned( itemID, category )  ) then
			draw.SimpleText( "Item Sell", "LShop_MainTitle", w * 0.5, h * 0.1 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		if ( Find.Name ) then
			draw.SimpleText( Find.Name, "LShop_SubTitle", w * 0.5, h * 0.65, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "NULL ITEM NAME", "LShop_SubTitle", w * 0.5, h * 0.65, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		if ( Find.Desc ) then
			draw.SimpleText( Find.Desc, "LShop_Category_Text", w * 0.5, h * 0.7, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "", "LShop_SubTitle", w * 0.5, h * 0.65, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		if ( Find.Price ) then
			if ( Find.CanSell && LP:LShop_IsOwned( itemID, category )  ) then
				draw.SimpleText( " + " .. Find.Price .. " $", "LShop_MainTitle", w * 0.5, h * 0.8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( " - " .. Find.Price .. " $", "LShop_MainTitle", w * 0.5, h * 0.8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		else
			draw.SimpleText( "NULL ITEM PRICE", "LShop_SubTitle", w * 0.5, h * 0.8, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		if ( Find.CanSell && LP:LShop_IsOwned( itemID, category )  ) then
		
		else
			draw.SimpleText( "You have " .. LP:LShop_GetMoney() .. " $.", "LShop_Category_Text", w * 0.5, h * 0.85, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	local Bx, By = LShop_ItemRunProgress_w * 0.32, LShop_ItemRunProgress_h * 0.1 / 2 - 35 / 2

	local CloseButton = vgui.Create( "DButton", LShop_ItemRunProgress )    
	CloseButton:SetText( "<" )  
	CloseButton:SetFont("LShop_ButtonText")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( 35, 35 ) 
	CloseButton.DoClick = function(  )
		LShop_ItemRunProgress:MoveTo( LShop_ItemRunProgress_x, scrH + LShop_ItemRunProgress_h, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_ItemRunProgress ) then
				LShop_ItemRunProgress:Remove()
				LShop_ItemRunProgress = nil
			end
		end)	
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 100, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local Bx, By = LShop_ItemRunProgress_w / 2 - LShop_ItemRunProgress_w * 0.39 / 2, LShop_ItemRunProgress_h * 0.85

	LShop_ItemRunProgress.MainAction = vgui.Create( "DButton", LShop_ItemRunProgress )    
	LShop_ItemRunProgress.MainAction:SetText( "" )  
	LShop_ItemRunProgress.MainAction:SetFont("LShop_ButtonText2")
	LShop_ItemRunProgress.MainAction:SetPos( Bx, By )  
	LShop_ItemRunProgress.MainAction:SetColor(Color( 0, 0, 0, 255 ))
	LShop_ItemRunProgress.MainAction:SetVisible( false )
	LShop_ItemRunProgress.MainAction:SetSize( LShop_ItemRunProgress_w * 0.39, 35 ) 
	LShop_ItemRunProgress.MainAction.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		local id = itemID
		local c = category
		if ( ButtonMode == 1 ) then
			net.Start("LShop_ItemBuy")
			net.WriteString( c )
			net.WriteString( id )
			net.SendToServer()	
			if ( LShop_ItemRunProgress ) then
				LShop_ItemRunProgress:MoveTo( LShop_ItemRunProgress_x, scrH + LShop_ItemRunProgress_h, 0.3, 0 )
				timer.Simple( 0.3, function()
					if ( LShop_ItemRunProgress ) then
						LShop_ItemRunProgress:Remove()
						LShop_ItemRunProgress = nil
					end
				end)	
			end
		else
			net.Start("LShop_ItemSell")
			net.WriteString( c )
			net.WriteString( id )
			net.SendToServer()	
			if ( LShop_ItemRunProgress ) then
				LShop_ItemRunProgress:MoveTo( LShop_ItemRunProgress_x, scrH + LShop_ItemRunProgress_h, 0.3, 0 )
				timer.Simple( 0.3, function()
					if ( LShop_ItemRunProgress ) then
						LShop_ItemRunProgress:Remove()
						LShop_ItemRunProgress = nil
					end
				end)	
			end			
		end
	end
	LShop_ItemRunProgress.MainAction.Paint = function()
		local w = LShop_ItemRunProgress.MainAction:GetWide()
		local h = LShop_ItemRunProgress.MainAction:GetTall()
		if ( ButtonMode == 1 ) then
			surface.SetDrawColor( 10, 255, 10, 50 )
			surface.DrawRect( 0, 0, w, h )
		else
			surface.SetDrawColor( 255, 10, 10, 50 )
			surface.DrawRect( 0, 0, w, h )		
		end
	end
	
	
	
	
	LShop_ItemRunProgress.SelectItemmodel = vgui.Create("DModelPanel", LShop_ItemRunProgress)
	LShop_ItemRunProgress.SelectItemmodel:SetSize( LShop_ItemRunProgress_w * 0.35, LShop_ItemRunProgress_h * 0.5 )
	LShop_ItemRunProgress.SelectItemmodel:SetPos( LShop_ItemRunProgress_w * 0.5 - LShop_ItemRunProgress_w * 0.35 / 2, LShop_ItemRunProgress_h * 0.1 )
	LShop_ItemRunProgress.SelectItemmodel.OnCursorEntered = function() 
		modelStop = true
	end
	LShop_ItemRunProgress.SelectItemmodel.OnCursorExited = function() 
		modelStop = false
	end
	LShop_ItemRunProgress.SelectItemmodel:SetDisabled( true )
	// LShop_ItemRunProgress.SelectItemmode:SetCursor( "none" ) -- Deleted :)
	LShop_ItemRunProgress.SelectItemmodel:MoveToBack()
	if ( !Find.Material ) then
		if ( Find.Model ) then
			LShop_ItemRunProgress.SelectItemmodel:SetModel( Model( Find.Model ) )
		else
			LShop_ItemRunProgress.SelectItemmodel:SetVisible( false )
		end
	else
		LShop_ItemRunProgress.SelectItemmodel:SetModel( "" )
		LShop_ItemRunProgress.SelectItemmodel:SetVisible( false )
	end
	LShop_ItemRunProgress.SelectItemmodel:SetVisible( true )
	LShop_ItemRunProgress.SelectItemmodel.PaintOver = function( pnl, w, h ) 
		
	end
	LShop_ItemRunProgress.SelectItemmodel.LayoutEntity = function( pnl, entity ) 
		local PrevMins, PrevMaxs = entity:GetRenderBounds()
		
		if ( modelStop == false ) then
			entity:SetAngles( Angle( 0, entity:GetAngles().y + 0.5, 0 ) )
		end
		
		LShop_ItemRunProgress.SelectItemmodel:SetCamPos( PrevMins:Distance( PrevMaxs ) * Vector( 0.5, 0.5, 0.5 ) )
		LShop_ItemRunProgress.SelectItemmodel:SetLookAt( ( PrevMaxs + PrevMins ) / 2 )		
	end
	
	
	local Bx, By = LShop_ItemRunProgress_w / 2 - LShop_ItemRunProgress_w * 0.39 / 2, LShop_ItemRunProgress_h * 0.95

	LShop_ItemRunProgress.ItemGiftAction = vgui.Create( "DButton", LShop_ItemRunProgress )    
	LShop_ItemRunProgress.ItemGiftAction:SetText( "Item Gift to" )  
	LShop_ItemRunProgress.ItemGiftAction:SetFont("LShop_ButtonText2")
	LShop_ItemRunProgress.ItemGiftAction:SetPos( Bx, By )  
	LShop_ItemRunProgress.ItemGiftAction:SetColor(Color( 0, 0, 0, 255 ))
	LShop_ItemRunProgress.ItemGiftAction:SetVisible( false )
	LShop_ItemRunProgress.ItemGiftAction:SetSize( LShop_ItemRunProgress_w * 0.39, 35 ) 
	LShop_ItemRunProgress.ItemGiftAction.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		local id = itemID
		local c = category
		local Menu = DermaMenu()
		for k, v in pairs( player.GetAll() ) do
			if ( k != 1 ) then
				if ( v:SteamID() != LP:SteamID() ) then
					Menu:AddOption( v:Name(), function()
						net.Start("LShop_ItemSend")
						net.WriteEntity( v )
						net.WriteString( id )
						net.WriteString( c )
						net.SendToServer()
						if ( LShop_ItemRunProgress ) then
							LShop_ItemRunProgress:MoveTo( LShop_ItemRunProgress_x, scrH + LShop_ItemRunProgress_h, 0.3, 0 )
							timer.Simple( 0.3, function()
								if ( LShop_ItemRunProgress ) then
									LShop_ItemRunProgress:Remove()
									LShop_ItemRunProgress = nil
								end
							end)	
						end
					end)
				end
			else
				Derma_Message( "Can't find other players!", "ERROR!", "OK" )
			end
		end
		Menu:Open()
	end
	LShop_ItemRunProgress.ItemGiftAction.Paint = function()
		local w = LShop_ItemRunProgress.ItemGiftAction:GetWide()
		local h = LShop_ItemRunProgress.ItemGiftAction:GetTall()
		surface.SetDrawColor( 10, 255, 10, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	LShop_ItemRunProgress:MoveToFront()
	
	else
		LShop_ItemRunProgress:Remove()
		LShop_ItemRunProgress = nil
	end
end


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
	LShop_Menu01Panel:SetDrawOnTop( false )
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

		surface.SetDrawColor( 10, 10, 10, 0 )
		surface.DrawRect( w * 0.75, h * 0.1, w * 0.25 - 20, h * 0.85 )

		draw.SimpleText( "Shop", "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		if ( itemInformation.Name != "" ) then
			draw.SimpleText( itemInformation.Name, "LShop_SubTitle", w * 0.87, h * 0.7, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		if ( itemInformation.Desc != "" ) then
			draw.SimpleText( itemInformation.Desc, "LShop_Category_Text", w * 0.87, h * 0.75, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		if ( itemInformation.Price != 0 ) then
			draw.SimpleText( itemInformation.Price .. " $", "LShop_SubTitle", w * 0.87, h * 0.8, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
		surface.SetDrawColor( 10, 10, 10, 0 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local ItemList = vgui.Create( "DPanelList", LShop_Menu01Panel )
	ItemList:SetPos( LShop_Menu01Panel_w * 0.2, LShop_Menu01Panel_h * 0.1 )
	ItemList:SetSize( LShop_Menu01Panel_w * 0.8 - 10 , LShop_Menu01Panel_h * 0.85 )
	ItemList:SetSpacing( 3 )
	ItemList:EnableHorizontal( false )
	ItemList:EnableVerticalScrollbar( true )
	ItemList.Paint = function()
		local w, h = ItemList:GetWide(), ItemList:GetTall()
		surface.SetDrawColor( 10, 10, 10, 0 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	function CategoryListClear()
		CategoryList:Clear()
	end

	function CategoryListAdd()
		for k, v in pairs( LShop.system.GetItems( ) ) do
			local color = Color( 10, 10, 10, 10 )
			local list = vgui.Create( "DButton", CategoryList )    
			list:SetSize( CategoryList:GetWide(), 50 ) 
			list:SetText("")
			list.DoClick = function()
				LShop.cl.SelectedCategory = k
				ItemListClear()
				ItemListAdd( LShop.cl.SelectedCategory )
			end
			list.OnCursorEntered = function()
				color = Color( 10, 255, 10, 100 )
			end
			list.OnCursorExited = function()
				color = Color( 10, 10, 10, 10 )
			end
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				
				surface.SetDrawColor( color )
				surface.DrawRect( 0, 0, w, h )
				
				if ( LShop.cl.SelectedCategory == k ) then
					surface.SetDrawColor( 10, 10, 10, 30 )
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
		local delta = 0
		for k, v in pairs( LShop.system.GetItems( )[ category ] ) do
			
			local list = vgui.Create( "DButton", ItemList )    
			list:SetSize( ItemList:GetWide(), 50 ) 
			list:SetText("")
			list:SetAlpha( 0 )
			list:AlphaTo( 255, 0.05, delta )
			delta = delta + 0.07
			list.DoClick = function()
				surface.PlaySound( "ui/buttonclick.wav" )		
				LShop.cl.ItemRunProgress( v.ID, v.Category )
				LShop_Menu01Panel:MoveToBack()
			end
			list.OnCursorEntered = function() end
			list.OnCursorExited = function() end
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				surface.SetDrawColor( 10, 10, 10, 10 )
				surface.DrawRect( 0, 0, w, h )
				
				draw.SimpleText( v.Name, "LShop_Category_Text", w * 0.1, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( v.Price, "LShop_Category_Text", w * 0.96, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				
				surface.SetMaterial( Material("icon16/money_dollar.png") )
				surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
				surface.DrawTexturedRect( w - 20, h / 2 - 16 / 2, 16, 16 )
			end
			
			local w, h = list:GetWide(), list:GetTall()
			if ( !v.Material ) then
				local icon = list:Add("SpawnIcon")
				icon:SetPos( 5, 5 )
				icon:SetSize( 50 - 10, h - 10 )
				if ( v.Model ) then
					icon:SetModel( v.Model )
				else
					icon:SetModel( "models/error.mdl" )
				end
				icon:SetToolTip( false )
			else
				local icon = list:Add("DImage")
				icon:SetPos( 5, 5 )
				icon:SetSize( 50 - 10, h - 10 )
				if ( v.Material ) then
					icon:SetImage( v.Material )
				else
					icon:SetImage( "" )
				end
				icon:SetToolTip( false )			
			end
			
			ItemList:AddItem( list )
		end
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