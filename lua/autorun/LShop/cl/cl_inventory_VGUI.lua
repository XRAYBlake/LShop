
function LShop.cl.Menu02( parent, tab )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_Menu02Panel_w, LShop_Menu02Panel_h = scrW, scrH * 0.8
	local LShop_Menu02Panel_x, LShop_Menu02Panel_y = 0, scrH + LShop_Menu02Panel_h;

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
		
		draw.RoundedBox( 0, 0, 0, w, 2, Color( 0, 0, 0, 255 ) )
		draw.RoundedBox( 0, 0, h - 2, w, 2, Color( 0, 0, 0, 255 ) )
		
		draw.SimpleText( "Inventory", "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( "You have " .. #LShop.OwnItemsCL .. "'s items.", "LShop_MoneyNotice", w * 0.99, h * 0.975, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
	
	LShop.cl.SelectedMenu = 2
	
	local ItemList = vgui.Create( "DPanelList", LShop_Menu02Panel )
	ItemList:SetPos( LShop_Menu02Panel_w * 0.5 - LShop_Menu02Panel_w * 0.98 / 2, LShop_Menu02Panel_h * 0.1 )
	ItemList:SetSize( LShop_Menu02Panel_w * 0.98 , LShop_Menu02Panel_h * 0.85 )
	ItemList:SetSpacing( 3 )
	ItemList:EnableHorizontal( false )
	ItemList:EnableVerticalScrollbar( true )
	ItemList.Paint = function()
		local w, h = ItemList:GetWide(), ItemList:GetTall()
		surface.SetDrawColor( 10, 10, 10, 0 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	function ClearInventory()
		ItemList:Clear()
	end
	
	function LoadInventory()
		for k, v in pairs( LShop.OwnItemsCL ) do
			local itemInformation = LShop.system.ItemFindByID( v.ID, v.Category ) or nil
			local list = vgui.Create("DButton", ItemList)
			list:SetSize( ItemList:GetWide(), 70 )
			list:SetText("")
			list.DoClick = function()
				local Menu = DermaMenu()
				if ( itemInformation ) then
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
				surface.SetDrawColor( 10, 10, 10, 10 )
				surface.DrawRect( 0, 0, w, h )
				
				if ( itemInformation ) then
					draw.SimpleText( itemInformation.Name, "LShop_SubTitle", w * 0.2, h * 0.5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "Can't use this item.", "LShop_SubTitle", w * 0.2, h * 0.5, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
			end
			
			local w, h = list:GetWide(), list:GetTall()
			
			if ( itemInformation ) then
				if ( !itemInformation.Material ) then
					local items = list:Add("SpawnIcon")
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
				else
					local icon = list:Add("DImage")
					icon:SetPos( 5, 5 )
					icon:SetSize( 60, h - 10 )
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
	
	LoadInventory()
	
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
		LShop_Menu02Panel:MoveTo( LShop_Menu02Panel_x, scrH + LShop_Menu02Panel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_Menu02Panel ) then
				LShop_Menu02Panel:Remove()
				LShop_Menu02Panel = nil
			end
		end)
	end
end