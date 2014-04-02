

function LShop.cl.MainShop()
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_MainShopPanel_w, LShop_MainShopPanel_h = scrW, scrH
	local LShop_MainShopPanel_x, LShop_MainShopPanel_y = (scrW * 0.5) - (LShop_MainShopPanel_w / 2), (scrH * 0.5) - (LShop_MainShopPanel_h / 2);
	LShop.cl.SelectedMenu = nil
	local day = os.date("*t")
	local schematicIntro_alpha = 0
	local schematicIntro_back_h = 0
	local closefunc = false
	local viewSin = 0
	local effect_color = 1
	
	net.Receive("LShop_SendMessage", function( len, cl )
		Derma_Message( net.ReadString(), "NOTICE", "OK" )
	end)
	
	hook.Add( "CalcView", "LAdmin.main.SchematicView", function( ply, pos, angles, fov )
		if ( IsValid( ply ) ) then
			local sin = math.sin( CurTime() / 2 )
			viewSin = ( 30 / 1 ) * sin
			local view = {}
			view.origin = Vector( pos.x, pos.y, pos.z + 100 )
			view.angles = Angle( angles.p, angles.y + viewSin, angles.r ) 
			view.fov = fov
				 
			return view
		end
	end)	
	
	hook.Add( "RenderScreenspaceEffects", "LAdmin.main.SchematicView_Func2", function( ply, pos, angles, fov )
		local color = {}
		color["$pp_colour_addr"] = 0
		color["$pp_colour_addg"] = 0
		color["$pp_colour_addb"] = 0
		color["$pp_colour_brightness"] = 0
		color["$pp_colour_contrast"] = 1
		color["$pp_colour_colour"] = effect_color
		color["$pp_colour_mulr"] = 0
		color["$pp_colour_mulg"] = 0
		color["$pp_colour_mulb"] = 0
			
		if ( LShop_MainShopPanel ) then
			effect_color = math.Approach( effect_color, 0, 0.01 )
			DrawColorModify(color)
		else
			effect_color = math.Approach( effect_color, 1.1, 0.01 )
			DrawColorModify(color)
			if ( effect_color >= 1 ) then
				hook.Remove( "RenderScreenspaceEffects", "LAdmin.main.SchematicView_Func2" )
			end
		end
	end)	

	hook.Add( "ShouldDrawLocalPlayer", "LAdmin.main.SchematicView_Func", function()
		return true
	end)
	
	if ( !LShop_MainShopPanel ) then
	LShop_MainShopPanel = vgui.Create("DFrame")
	LShop_MainShopPanel:SetPos( LShop_MainShopPanel_x, LShop_MainShopPanel_y )
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
		surface.DrawRect( 0, 0, w, schematicIntro_back_h )
		
		surface.SetDrawColor( 255, 255, 255, 235 )
		surface.DrawRect( 0, h - schematicIntro_back_h, w, schematicIntro_back_h )
		
		if ( closefunc == false ) then
			schematicIntro_alpha = math.Approach( schematicIntro_alpha, 255, 3 )
			schematicIntro_back_h = math.Approach( schematicIntro_back_h, h * 0.1, 3 )
		else
			schematicIntro_alpha = math.Approach( schematicIntro_alpha, 0, 10 )
			schematicIntro_back_h = math.Approach( schematicIntro_back_h, 0, 3 )		
		end
		
		draw.SimpleText( "You have " .. LP:LShop_GetMoney() .. " $.", "LShop_MoneyNotice", w * 0.97, h * 0.95, Color( 0, 0, 0, schematicIntro_alpha ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( "LShop", "LShop_MainTitle", w * 0.03, h * 0.05, Color( 0, 0, 0, schematicIntro_alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		draw.SimpleText( "Version : " .. LShop.Config.Version, "LShop_MoneyNotice", w * 0.03, h * 0.95, Color( 0, 0, 0, schematicIntro_alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Copyright ( C ) 2014 ~ 'Solar Team'", "LShop_MoneyNotice", w * 0.5, h * 0.95, Color( 0, 0, 0, schematicIntro_alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		if ( LShop.Config.DaySaleSystem ) then
			if ( day.wday == LShop.Config.DayNumber ) then
				draw.SimpleText( "Sale Day!", "LShop_SubTitle", w * 0.5, h * 0.95, Color( 0, 0, 0, schematicIntro_alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
	end

	local Bx, By = LShop_MainShopPanel_w - 45, 10

	local CloseButton = vgui.Create( "DButton", LShop_MainShopPanel )    
	CloseButton:SetText( "X" )  
	CloseButton:SetFont("LShop_ButtonText")
	CloseButton:SetPos( Bx, By )  
	CloseButton:SetColor(Color( 0, 0, 0, 255 ))
	CloseButton:SetSize( 35, 35 ) 
	CloseButton:SetAlpha( 0 )
	CloseButton:AlphaTo( 255, 0.3, 0 )
	CloseButton.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		closefunc = true
		LShop_MainShopPanel.Menu01:AlphaTo( 0, 0.3, 0 )
		LShop_MainShopPanel.Menu02:AlphaTo( 0, 0.3, 0 )
		LShop_MainShopPanel.Admin:AlphaTo( 0, 0.3, 0 )
		hook.Remove( "CalcView", "LAdmin.main.SchematicView" )
		hook.Remove( "ShouldDrawLocalPlayer", "LAdmin.main.SchematicView_Func" )
		
		timer.Simple( 0.5, function()
			if ( LShop_MainShopPanel ) then
				LShop_MainShopPanel:Remove()
				LShop_MainShopPanel = nil
			end
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
	LShop_MainShopPanel.Menu01:SetAlpha( 0 )
	LShop_MainShopPanel.Menu01:AlphaTo( 255, 0.3, 0 )
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

	LShop_MainShopPanel.Menu02 = vgui.Create( "DButton", LShop_MainShopPanel )    
	LShop_MainShopPanel.Menu02:SetText( "Inventory" )  
	LShop_MainShopPanel.Menu02:SetFont("LShop_ButtonText")
	LShop_MainShopPanel.Menu02:SetPos( Bx, By )  
	LShop_MainShopPanel.Menu02:SetColor(Color( 0, 0, 0, 255 ))
	LShop_MainShopPanel.Menu02:SetSize( LShop_MainShopPanel_w * 0.15, 35 ) 
	LShop_MainShopPanel.Menu02:SetAlpha( 0 )
	LShop_MainShopPanel.Menu02:AlphaTo( 255, 0.3, 0 )
	LShop_MainShopPanel.Menu02.DoClick = function(  )
		surface.PlaySound( "ui/buttonclick.wav" )
		LShop.cl.Menu02( LShop_MainShopPanel )
	end
	LShop_MainShopPanel.Menu02.Paint = function()
		local w = LShop_MainShopPanel.Menu02:GetWide()
		local h = LShop_MainShopPanel.Menu02:GetTall()
		
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
		LShop_MainShopPanel.Admin:SetAlpha( 0 )
		LShop_MainShopPanel.Admin:AlphaTo( 255, 0.3, 0 )
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
	
	--[[
	
	local NewItemList = vgui.Create( "DPanelList", LShop_MainShopPanel )
	NewItemList:SetPos( LShop_MainShopPanel_w * 0.25, LShop_MainShopPanel_h * 0.35 )
	NewItemList:SetSize( LShop_MainShopPanel_w * 0.5 , LShop_MainShopPanel_h * 0.2 )
	NewItemList:SetSpacing( 3 )
	NewItemList:SetPadding( 3 )
	NewItemList:EnableHorizontal( true )
	NewItemList:EnableVerticalScrollbar( true )
	NewItemList.Paint = function()
		local w, h = NewItemList:GetWide(), NewItemList:GetTall()
		surface.SetDrawColor( 10, 10, 10, 10 )
		surface.DrawRect( 0, 0, w, h )
	end

	local function NewitemRefresh()
		if ( LShop.system.GetItems( )[ "New" ] ) then
			for k, v in pairs( LShop.system.GetItems( )[ "New" ] ) do
				local list = vgui.Create("SpawnIcon", NewItemList)
				list:SetModel( v.Model )
				list:SetSize( 72, 72 )
				list:SetToolTip("Name : " .. v.Name .. "\nPrice : " .. v.Price .. " $\n")
				NewItemList:AddItem( list )
			end
		end
	end
	
	NewitemRefresh()
	
	--]] -- Deleted. :)
	
	net.Start("LShop_SendTable_Request")
	net.SendToServer()
	
	else
		LShop_MainShopPanel:Remove()
		LShop_MainShopPanel = nil
		hook.Remove( "CalcView", "LAdmin.main.SchematicView" )
		hook.Remove( "ShouldDrawLocalPlayer", "LAdmin.main.SchematicView_Func" )
		hook.Remove( "RenderScreenspaceEffects", "LAdmin.main.SchematicView_Func2" )
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