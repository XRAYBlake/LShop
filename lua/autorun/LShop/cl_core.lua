LShop = LShop or {}
LShop.cl = LShop.cl or {}
LShop.cl.SelectedCategory = nil
LShop.cl.SelectedMenu = nil
LShop.OwnItemsCL = LShop.OwnItemsCL or {}
LShop.PlyMoney = LShop.PlyMoney or 0

function LShop.cl.LoadSharedFile( )
	local find = file.Find("autorun/LShop/sh/*.lua", "LUA") or nil
	if ( find ) then
		for k, v in pairs( find ) do
			include( "sh/" .. v )
		end
	end
end

LShop.cl.LoadSharedFile( )

function LShop.cl.IsOwned( pl, itemID, category )
	local id = LShop.system.ItemFindByID( tostring( itemID ), category )
	if ( id ) then
		for k, v in pairs( LShop.OwnItemsCL ) do
			if ( v.ID == itemID ) then
				return true
			else
				if ( k == #LShop.OwnItemsCL ) then
					return nil
				end
			end
		end
	else

	end
end

function LShop.cl.IsEquiped( pl, itemID, category )
	local id = LShop.system.ItemFindByID( tostring( itemID ), category )
	if ( id ) then
		for k, v in pairs( LShop.OwnItemsCL ) do
			if ( v.ID == itemID ) then
				if ( v.onEquip ) then
					return true
				else
					return false
				end
			else
				if ( k == #LShop.OwnItemsCL ) then
					return nil
				end
			end
		end
	else
	
	end
end

local meta = FindMetaTable("Player")

function meta:LShop_IsOwned( id, category ) 
	return LShop.cl.IsOwned( self, id, category )
end

function meta:LShop_IsEquiped( id, category ) 
	return LShop.cl.IsEquiped( self, id, category )
end

net.Receive("LShop_ItemIsOwnCheck_SendCL", function( len, cl )

end)

net.Receive("LShop_BugNoticeSend", function( len, cl )
	LShop.cl.BugNotice( net.ReadTable() )
end)

net.Receive("LShop_SendTable", function( len, cl )
	LShop.OwnItemsCL = net.ReadTable() or {}
	LShop.PlyMoney = net.ReadString() or 0
	LShop.PlyMoney = tonumber( LShop.PlyMoney )
	if ( IsValid( LShop_Menu01Panel ) ) then
		ItemListClear()
		ItemListAdd( LShop.cl.SelectedCategory )
	end
end)

surface.CreateFont("LShop_MainTitle", 
{
	font		= "Segoe UI Light",
	size		= 55,
	weight		= 1000
});

surface.CreateFont("LShop_ButtonText", 
{
	font		= "Segoe UI Light",
	size		= 20,
	weight		= 1000
});

surface.CreateFont("LShop_SubTitle", 
{
	font		= "Segoe UI Light",
	size		= 40,
	weight		= 1000
});

surface.CreateFont("LShop_Category_Text", 
{
	font		= "Segoe UI Light",
	size		= 25,
	weight		= 1000
});

surface.CreateFont("LShop_MoneyNotice", 
{
	font		= "Segoe UI Light",
	size		= 20,
	weight		= 1000
});

surface.CreateFont("LShop_ButtonText2", 
{
	font		= "Segoe UI Light",
	size		= 40,
	weight		= 1000
});

concommand.Add("LShop_open", function( pl, cmd, args )
	LShop.cl.MainShop()
end)

function LShop.cl.MainShop()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_MainShopPanel_w, LShop_MainShopPanel_h = scrW, scrH -- scrW, scrH
	local LShop_MainShopPanel_x, LShop_MainShopPanel_y = (scrW * 0.5) - (LShop_MainShopPanel_w / 2), (scrH * 0.5) - (LShop_MainShopPanel_h / 2);
	LShop.PlyMoneyAnimation = 0
	LShop.cl.SelectedMenu = nil

	net.Receive("LShop_SendMessage", function( len, cl )
		Derma_Message( net.ReadString(), "!", "OK" )
	end)
	
	if ( !LShop_MainShopPanel ) then
	LShop_MainShopPanel = vgui.Create("DFrame")
	LShop_MainShopPanel:SetPos( LShop_MainShopPanel_x , ScrH() + LShop_MainShopPanel_h )
	LShop_MainShopPanel:MoveTo( ScrW() / 2 - LShop_MainShopPanel_w / 2, LShop_MainShopPanel_y, 0.3, 0 )
	LShop_MainShopPanel:SetSize( LShop_MainShopPanel_w, LShop_MainShopPanel_h )
	LShop_MainShopPanel:SetTitle( "" )
	LShop_MainShopPanel:SetDraggable( true )
	LShop_MainShopPanel:ShowCloseButton( false )
	LShop_MainShopPanel:MakePopup()
	LShop_MainShopPanel.Think = function()
		if ( LShop_Menu01Panel ) then
			LShop_MainShopPanel:MoveToBack()
		end
		if ( LShop_Menu02Panel ) then
			LShop_MainShopPanel:MoveToBack()
		end
	end
	LShop_MainShopPanel.Paint = function()
		local x = LShop_MainShopPanel_x
		local y = LShop_MainShopPanel_y
		local w = LShop_MainShopPanel_w
		local h = LShop_MainShopPanel_h

		surface.SetDrawColor( 255, 255, 255, 235 )
		surface.DrawRect( 0, 0, w, h )
		
		LShop.PlyMoneyAnimation = math.Approach( LShop.PlyMoneyAnimation, LShop.PlyMoney, 1 )
		
		draw.SimpleText( "You have " .. LShop.PlyMoneyAnimation .. " Moneys.", "LShop_MoneyNotice", w * 0.85, h * 0.97, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		
		draw.SimpleText( "LShop", "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Alpha Version", "LShop_MoneyNotice", w * 0.01, h * 0.97, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( "New Items", "LShop_MainTitle", w * 0.25, h * 0.3, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

	local Bx, By = LShop_MainShopPanel_w - 40, LShop_MainShopPanel_h - 40

	local CloseButton = vgui.Create( "DButton", LShop_MainShopPanel )    
	CloseButton:SetText( "X" )  
	CloseButton:SetFont("LShop_ButtonText")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( 35, 35 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		LShop_MainShopPanel:MoveTo( ScrW() / 2 - LShop_MainShopPanel_w / 2, ScrH() * 1.5, 0.3, 0 )
		timer.Simple(0.3 , function()
			LShop_MainShopPanel:Remove()
			LShop_MainShopPanel = nil
		end)		
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
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 255, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local Bx, By = scrW * 0.3 - LShop_MainShopPanel_w * 0.2 / 2, scrH * 0.05 - 35 / 2

	LShop_MainShopPanel.Menu01 = vgui.Create( "DButton", LShop_MainShopPanel )    
	LShop_MainShopPanel.Menu01:SetText( "Shop" )  
	LShop_MainShopPanel.Menu01:SetFont("LShop_ButtonText")
	LShop_MainShopPanel.Menu01:SetPos( Bx, By )  
	LShop_MainShopPanel.Menu01:SetColor(Color( 0, 0, 0, 255 ))
	LShop_MainShopPanel.Menu01:SetSize( LShop_MainShopPanel_w * 0.2, 35 ) 
	LShop_MainShopPanel.Menu01.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		LShop.cl.Menu01( LShop_MainShopPanel )
	end
	LShop_MainShopPanel.Menu01.Paint = function()
		local w = LShop_MainShopPanel.Menu01:GetWide()
		local h = LShop_MainShopPanel.Menu01:GetTall()
		
		surface.SetDrawColor( 10, 10, 10, 10 )
		surface.DrawRect( 0, 0, w, h )
		
		if ( LShop.cl.SelectedMenu == 1 ) then
			surface.SetDrawColor( 10, 255, 10, 50 )
			surface.DrawRect( 0, 0, w, h )		
		end
	end
	
	local Bx, By = scrW * 0.6 - LShop_MainShopPanel_w * 0.2 / 2, scrH * 0.05 - 35 / 2

	LShop_MainShopPanel.Menu01 = vgui.Create( "DButton", LShop_MainShopPanel )    
	LShop_MainShopPanel.Menu01:SetText( "Inventory" )  
	LShop_MainShopPanel.Menu01:SetFont("LShop_ButtonText")
	LShop_MainShopPanel.Menu01:SetPos( Bx, By )  
	LShop_MainShopPanel.Menu01:SetColor(Color( 0, 0, 0, 255 ))
	LShop_MainShopPanel.Menu01:SetSize( LShop_MainShopPanel_w * 0.2, 35 ) 
	LShop_MainShopPanel.Menu01.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		LShop.cl.Menu02( LShop_MainShopPanel )
	end
	LShop_MainShopPanel.Menu01.Paint = function()
		local w = LShop_MainShopPanel.Menu01:GetWide()
		local h = LShop_MainShopPanel.Menu01:GetTall()
		
		surface.SetDrawColor( 10, 10, 10, 10 )
		surface.DrawRect( 0, 0, w, h )
		
		if ( LShop.cl.SelectedMenu == 2 ) then
			surface.SetDrawColor( 10, 255, 10, 50 )
			surface.DrawRect( 0, 0, w, h )		
		end
	end
	
	local NewItemList = vgui.Create( "DPanelList", LShop_MainShopPanel )
	NewItemList:SetPos( LShop_MainShopPanel_w * 0.25, LShop_MainShopPanel_h * 0.35 )
	NewItemList:SetSize( LShop_MainShopPanel_w * 0.5 , LShop_MainShopPanel_h * 0.2 )
	NewItemList:SetSpacing( 3 )
	NewItemList:SetPadding( 3 )
	NewItemList:EnableHorizontal( true )
	NewItemList:EnableVerticalScrollbar( true )
	NewItemList.Paint = function()
		local w, h = NewItemList:GetWide(), NewItemList:GetTall()
		surface.SetDrawColor( 10, 10, 10, 30 )
		surface.DrawRect( 0, 0, w, h )
	end

	local function NewitemRefresh()
		if ( LShop.ITEMs[ "New" ] ) then
			for k, v in pairs( LShop.ITEMs[ "New" ] ) do
				local list = vgui.Create("SpawnIcon", NewItemList)
				list:SetModel( v.Model )
				list:SetSize( 52, 52 )
				list:SetToolTip("Name : " .. v.Name .. "\nPrice : " .. v.Price .. " $\n")
				NewItemList:AddItem( list )
			end
		end
	end
	
	NewitemRefresh()
	
	net.Start("LShop_SendTable_Request")
	net.SendToServer()
	
	else
		LShop_MainShopPanel:Remove()
		LShop_MainShopPanel = nil
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
		for k, v in pairs( LShop.ITEMs ) do
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
		for k, v in pairs( LShop.ITEMs[ category ] ) do
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
	SelectItemmodel:SetFOV(50) -- 105
	SelectItemmodel:SetCamPos( Vector( 50, 50, 5 ) )
	SelectItemmodel:SetLookAt( Vector( 0, 0, 0 ) )
	SelectItemmodel.OnCursorEntered = function() end
	SelectItemmodel:SetDisabled(true)
	SelectItemmodel:SetCursor("none")
	SelectItemmodel:MoveToBack()
	SelectItemmodel:SetVisible( true )
	SelectItemmodel.PaintOver = function()
		local w, h = SelectItemmodel:GetWide(), SelectItemmodel:GetTall()
	end
		
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
			net.Start("LShop_ItemBuy")
			net.WriteString( SelectItem.Category )
			net.WriteString( SelectItem.ID )
			net.SendToServer()			
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

function LShop.cl.Menu02( parent, tab )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_Menu02Panel_w, LShop_Menu02Panel_h = 10 + scrW - 30, scrH * 0.8
	local LShop_Menu02Panel_x, LShop_Menu02Panel_y = 10, scrH + LShop_Menu02Panel_h;

	if ( !LShop_Menu02Panel ) then
	LShop_Menu02Panel = vgui.Create("DFrame", parent)
	LShop_Menu02Panel:SetPos( LShop_Menu02Panel_x , LShop_Menu02Panel_y )
	LShop_Menu02Panel:MoveTo( LShop_Menu02Panel_x, scrH * 0.1, 0.3, 0 )
	LShop_Menu02Panel:SetSize( LShop_Menu02Panel_w, LShop_Menu02Panel_h )
	LShop_Menu02Panel:SetTitle( "" )
	LShop_Menu02Panel:SetDraggable( false )
	LShop_Menu02Panel:ShowCloseButton( false )
	LShop_Menu02Panel:MakePopup()
	LShop_Menu02Panel:SetDrawOnTop( true )
	LShop_Menu02Panel.Paint = function()
		local x = LShop_Menu02Panel_x
		local y = LShop_Menu02Panel_y
		local w = LShop_Menu02Panel_w
		local h = LShop_Menu02Panel_h

		surface.SetDrawColor( 255, 255, 255, 230 )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( "Inventory", "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	LShop.cl.SelectedMenu = 2
	
	local ItemList = vgui.Create( "DPanelList", LShop_Menu02Panel )
	ItemList:SetPos( LShop_Menu02Panel_w * 0.1, LShop_Menu02Panel_h * 0.1 )
	ItemList:SetSize( LShop_Menu02Panel_w * 0.8 , LShop_Menu02Panel_h * 0.85 )
	ItemList:SetSpacing( 3 )
	ItemList:EnableHorizontal( false )
	ItemList:EnableVerticalScrollbar( true )
	ItemList.Paint = function()
		local w, h = ItemList:GetWide(), ItemList:GetTall()
		surface.SetDrawColor( 10, 10, 10, 10 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local Tab = {}
	Tab = {}
	local function ClearInventory()
		ItemList:Clear()
	end
	
	local function LoadInventory()
		for k, v in pairs( LShop.OwnItemsCL ) do
			local itemInformation = LShop.system.ItemFindByID( v.ID, v.Category ) or 1
			local list = vgui.Create("DButton", ItemList)
			list:SetSize( ItemList:GetWide(), 70 )
			list:SetText("")
			list.DoClick = function()
				local Menu = DermaMenu()
				if ( itemInformation != 1 ) then
					if ( itemInformation.CanSell && LP:LShop_IsOwned( v.ID, v.Category ) ) then
						Menu:AddOption("Sell", function() 
							net.Start("LShop_ItemSell")
							net.WriteString( v.Category )
							net.WriteString( v.ID )
							net.SendToServer()	
						end
						)
					end
							
					if ( itemInformation.CanEquip && LP:LShop_IsOwned( v.ID, v.Category ) ) then
						if ( !LP:LShop_IsEquiped( v.ID, v.Category ) ) then
							Menu:AddOption("Equip", function() 
								net.Start("LShop_ItemEquip")
								net.WriteString( v.Category )
								net.WriteString( v.ID )
								net.WriteString( "true" )
								net.SendToServer()
								ClearInventory()
								LoadInventory()
							end
							)
						else
							Menu:AddOption("Unequip", function() 
								net.Start("LShop_ItemEquip")
								net.WriteString( v.Category )
								net.WriteString( v.ID )
								net.WriteString( "false" )
								net.SendToServer()
								ClearInventory()
								LoadInventory()
										
							end
							)							
						end
					end
					Menu:Open()	
				end
			end
			list.Paint = function()
				local w, h = list:GetWide(), list:GetTall()
				
				if ( itemInformation != 1 ) then
					draw.SimpleText( itemInformation.Name, "LShop_SubTitle", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "Can't use this item.", "LShop_SubTitle", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
			end
			
			local items = vgui.Create("SpawnIcon", list)
			items:SetSize( 70 - 10, 70 - 10 )
			items:SetPos( 5, 5 )
			if ( itemInformation != 1 ) then
				items:SetModel( itemInformation.Model )
			else
				items:SetModel( "models/error.mdl" )
			end
			items.PaintOver = function( items, w, h )
				if ( v ) then
					if ( v.onEquip ) then
						surface.SetMaterial( Material("icon16/accept.png") )
						surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
						surface.DrawTexturedRect( 5, 5, 16, 16 )
					end
				end
			end
			ItemList:AddItem( list )
		end
	end
	
	LoadInventory()

	local Bx, By = scrW * 0.05, scrH * 0.1

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
	
	else
		LShop.cl.SelectedMenu = nil
		LShop_Menu02Panel:MoveTo( LShop_Menu02Panel_x, scrH + LShop_Menu02Panel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_Menu02Panel ) then
				LShop_Menu02Panel:Remove()
				LShop_Menu02Panel = nil
			end
		end)
	end
end

function LShop.cl.BugNotice( tab )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_BugNoticePanel_w, LShop_BugNoticePanel_h = scrW * 0.6, scrH * 0.6
	local LShop_BugNoticePanel_x, LShop_BugNoticePanel_y = scrW / 2 - LShop_BugNoticePanel_w / 2, scrH / 2 - LShop_BugNoticePanel_h / 2;


	if ( !LShop_BugNoticePanel ) then
	LShop_BugNoticePanel = vgui.Create("DFrame", parent)
	LShop_BugNoticePanel:SetPos( LShop_BugNoticePanel_x , LShop_BugNoticePanel_y )
	LShop_BugNoticePanel:SetSize( LShop_BugNoticePanel_w, LShop_BugNoticePanel_h )
	LShop_BugNoticePanel:SetTitle( "" )
	LShop_BugNoticePanel:SetDraggable( true )
	LShop_BugNoticePanel:ShowCloseButton( false )
	LShop_BugNoticePanel:MakePopup()
	LShop_BugNoticePanel.Paint = function()
		local x = LShop_BugNoticePanel_x
		local y = LShop_BugNoticePanel_y
		local w = LShop_BugNoticePanel_w
		local h = LShop_BugNoticePanel_h

		surface.SetDrawColor( 200, 100, 100, 230 )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( "경고", "LShop_MainTitle", w * 0.05, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "LShop 에서 심각한 버그를 발견하여 시스템을 복구 하였습니다.", "LShop_ButtonText", w * 0.05, h * 0.13, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		if ( tab ) then
			if ( tab.BugTitle ) then
				draw.SimpleText( tab.BugTitle, "LShop_ButtonText", w * 0.5, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			if ( tab.BugValue ) then
				draw.SimpleText( tab.BugValue, "LShop_ButtonText", w * 0.5, h * 0.6, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		
		draw.SimpleText( "참고 : LShop 은 알파 버전 입니다, 버그가 많을 수 있습니다.", "LShop_ButtonText", w * 0.5, h * 0.7, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local Bx, By = LShop_BugNoticePanel_w / 2 - LShop_BugNoticePanel_w * 0.9 / 2, LShop_BugNoticePanel_h - 40

	local CloseButton = vgui.Create( "DButton", LShop_BugNoticePanel )    
	CloseButton:SetText( "OK" )  
	CloseButton:SetFont("LShop_ButtonText")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( LShop_BugNoticePanel_w * 0.9, 35 ) 
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		if ( LShop_MainShopPanel ) then
			LShop_MainShopPanel:Remove()
			LShop_MainShopPanel = nil
		end
		
		if ( LShop_MainShopPanel ) then
			LShop_MainShopPanel:Remove()
			LShop_MainShopPanel = nil
		end

		if ( LShop_Menu01Panel ) then
			LShop_Menu01Panel:Remove()
			LShop_Menu01Panel = nil
		end
		
		if ( LShop_BugNoticePanel ) then
			LShop_BugNoticePanel:Remove()
			LShop_BugNoticePanel = nil
		end
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 255, 100, 100, 100 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	if ( LShop_MainShopPanel ) then
		LShop_MainShopPanel:Remove()
		LShop_MainShopPanel = nil
	end

	if ( LShop_Menu01Panel ) then
		LShop_Menu01Panel:Remove()
		LShop_Menu01Panel = nil
	end
	
	if ( LShop_Menu02Panel ) then
		LShop_Menu02Panel:Remove()
		LShop_Menu02Panel = nil
	end
	
	else
		if ( LShop_BugNoticePanel ) then
			LShop_BugNoticePanel:Remove()
			LShop_BugNoticePanel = nil
		end
	end
end