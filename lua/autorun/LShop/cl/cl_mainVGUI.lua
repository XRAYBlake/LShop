
function LShop.cl.MainShop()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_MainShopPanel_w, LShop_MainShopPanel_h = scrW, scrH -- scrW, scrH
	local LShop_MainShopPanel_x, LShop_MainShopPanel_y = (scrW * 0.5) - (LShop_MainShopPanel_w / 2), (scrH * 0.5) - (LShop_MainShopPanel_h / 2);
	LShop.PlyMoneyAnimation = 0
	LShop.cl.SelectedMenu = nil

	net.Receive("LShop_SendMessage", function( len, cl )
		Derma_Message( net.ReadString(), "NOTICE", "OK" )
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
		if ( LShop_AdminPanel ) then
			LShop_MainShopPanel:MoveToBack()
		end
		if ( LShop_PlayerManager ) then
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
		
		LShop.PlyMoneyAnimation = math.Approach( LShop.PlyMoneyAnimation, LP:LShop_GetMoney(), 100 )
		
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
	end
	CloseButton.Paint = function()
		local w = CloseButton:GetWide()
		local h = CloseButton:GetTall()
		
		surface.SetDrawColor( 255, 100, 100, 50 )
		surface.DrawRect( 0, 0, w, h )
	end
	
	local Bx, By = scrW * 0.25 - LShop_MainShopPanel_w * 0.15 / 2, scrH * 0.05 - 35 / 2

	LShop_MainShopPanel.Menu01 = vgui.Create( "DButton", LShop_MainShopPanel )    
	LShop_MainShopPanel.Menu01:SetText( "Shop" )  
	LShop_MainShopPanel.Menu01:SetFont("LShop_ButtonText")
	LShop_MainShopPanel.Menu01:SetPos( Bx, By )  
	LShop_MainShopPanel.Menu01:SetColor(Color( 0, 0, 0, 255 ))
	LShop_MainShopPanel.Menu01:SetSize( LShop_MainShopPanel_w * 0.15, 35 ) 
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
	
	local Bx, By = scrW * 0.45 - LShop_MainShopPanel_w * 0.15 / 2, scrH * 0.05 - 35 / 2

	LShop_MainShopPanel.Menu01 = vgui.Create( "DButton", LShop_MainShopPanel )    
	LShop_MainShopPanel.Menu01:SetText( "Inventory" )  
	LShop_MainShopPanel.Menu01:SetFont("LShop_ButtonText")
	LShop_MainShopPanel.Menu01:SetPos( Bx, By )  
	LShop_MainShopPanel.Menu01:SetColor(Color( 0, 0, 0, 255 ))
	LShop_MainShopPanel.Menu01:SetSize( LShop_MainShopPanel_w * 0.15, 35 ) 
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
	
	if ( LShop.Config.PermissionCheck( LP ) ) then
		local Bx, By = scrW * 0.65 - LShop_MainShopPanel_w * 0.15 / 2, scrH * 0.05 - 35 / 2

		LShop_MainShopPanel.Admin = vgui.Create( "DButton", LShop_MainShopPanel )    
		LShop_MainShopPanel.Admin:SetText( "Administrator" )  
		LShop_MainShopPanel.Admin:SetFont("LShop_ButtonText")
		LShop_MainShopPanel.Admin:SetPos( Bx, By )  
		LShop_MainShopPanel.Admin:SetColor(Color( 0, 0, 0, 255 ))
		LShop_MainShopPanel.Admin:SetSize( LShop_MainShopPanel_w * 0.15, 35 ) 
		LShop_MainShopPanel.Admin.DoClick = function(  )
			surface.PlaySound( "ui/buttonclick.wav" )
			LShop.cl.Admin( LShop_MainShopPanel )
		end
		LShop_MainShopPanel.Admin.Paint = function()
			local w = LShop_MainShopPanel.Admin:GetWide()
			local h = LShop_MainShopPanel.Admin:GetTall()
			
			surface.SetDrawColor( 10, 10, 10, 10 )
			surface.DrawRect( 0, 0, w, h )
			
			if ( LShop.cl.SelectedMenu == 3 ) then
				surface.SetDrawColor( 10, 255, 10, 50 )
				surface.DrawRect( 0, 0, w, h )		
			end
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
	end
end


