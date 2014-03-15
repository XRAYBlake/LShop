
local function BuildMenuGive( parent, target )
	for category_ID, items in pairs(LShop.ITEMs) do
		local category = parent:AddSubMenu( category_ID )
		
		table.sort(LShop.ITEMs, function(a, b) 
			return a.Name > b.Name
		end)
		
		for i= 1, #items do
			local ownitems = target:LShop_IsOwned( items[i].ID, items[i].Category )
			if ( !ownitems ) then
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
end

local function BuildMenuTake( parent, target )
	for category_ID, items in pairs(LShop.ITEMs) do
		local category = parent:AddSubMenu( category_ID )

		table.sort(LShop.ITEMs, function(a, b) 
			return a.Name > b.Name
		end)

		for i= 1, #items do
			local ownitems = target:LShop_IsOwned( items[i].ID, items[i].Category )
			if ( ownitems ) then
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
end

function LShop.cl.Admin( parent, tab )
	local LP = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()
	local LShop_AdminPanel_w, LShop_AdminPanel_h = 10 + scrW - 30, scrH * 0.8
	local LShop_AdminPanel_x, LShop_AdminPanel_y = 10, scrH + LShop_AdminPanel_h;

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
		
		draw.SimpleText( "Administrator", "LShop_MainTitle", w * 0.01, h * 0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	local PlayerList = vgui.Create( "DPanelList", LShop_AdminPanel )
	PlayerList:SetPos( LShop_AdminPanel_w / 2 - LShop_AdminPanel_w * 0.95 / 2, LShop_AdminPanel_h * 0.1 )
	PlayerList:SetSize( LShop_AdminPanel_w * 0.95 , LShop_AdminPanel_h * 0.85 )
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
					Menu:AddOption( "Money Set", function()
						Derma_StringRequest(
							v:Name() .. " 's money set.",
							"How set ammount target money?",
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
					BuildMenuGive( Menu:AddSubMenu( "Item Give" ), v )
					BuildMenuTake( Menu:AddSubMenu( "Item Take" ), v )
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
		LShop_AdminPanel:MoveTo( LShop_AdminPanel_x, scrH + LShop_AdminPanel_w, 0.3, 0 )
		timer.Simple( 0.3, function()
			if ( LShop_AdminPanel ) then
				LShop_AdminPanel:Remove()
				LShop_AdminPanel = nil
			end
		end)
	end
end
