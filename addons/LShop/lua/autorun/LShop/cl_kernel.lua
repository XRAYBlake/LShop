LShop = LShop or {}
LShop.cl = LShop.cl or {}
LShop.cl.SelectedCategory = nil
LShop.cl.SelectedMenu = nil
LShop.OwnItemsCL = LShop.OwnItemsCL or {}
LShop.PlyMoney = LShop.PlyMoney or 0

LShop.cl.IntroPlaying = LShop.cl.IntroPlaying or false
LShop.cl.IntroDone = LShop.cl.IntroDone or false
LShop.cl.IntroLoadText = {}

function LShop.cl.LoadClientFile( )
	local find = file.Find("autorun/LShop/cl/*.lua", "LUA") or nil
	if ( find ) then
		for k, v in pairs( find ) do
			include( "cl/" .. v )
		end
	end
end

function LShop.cl.LoadSharedFile( )
	local find = file.Find("autorun/LShop/sh/*.lua", "LUA") or nil
	if ( find ) then
		for k, v in pairs( find ) do
			include( "sh/" .. v )
		end
	end
end

LShop.cl.LoadSharedFile( )
LShop.cl.LoadClientFile( )

LShop.lang.tablesCL = LShop.lang.tablesCL or {}
LShop.lang.langconfigCL = LShop.lang.langconfigCL or LShop.Config.DefaultLanguageFile

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

function LShop.cl.IsOwned_Global( target, itemID, category )
	local id = LShop.system.ItemFindByID( tostring( itemID ), category )
	if ( id ) then
		for k, v in pairs( target.OwnItemsCL ) do
			if ( v.ID == itemID ) then
				return true
			else
				if ( k == #target.OwnItemsCL ) then
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

function meta:LShop_GetMoney( ) 
	return self:GetNWInt( "LShop_Money" )
end

function meta:LShop_IsOwned( id, category ) 
	return LShop.cl.IsOwned( self, id, category )
end

function meta:LShop_IsEquiped( id, category ) 
	return LShop.cl.IsEquiped( self, id, category )
end

net.Receive("LShop_BugNoticeSend", function( len, cl )
	LShop.cl.BugNotice( net.ReadTable() )
end)

net.Receive("LShop_MenuOpen", function( len, cl )
	LShop.cl.Intro()
end)

net.Receive("LShop_SendTable", function( len, cl )
	local ownitemTab = net.ReadTable() or {}
	LocalPlayer().OwnItemsCL = ownitemTab
	LShop.OwnItemsCL = ownitemTab
	LShop.PlyMoney = net.ReadString() or 0
	LShop.PlyMoney = tonumber( LShop.PlyMoney )
	if ( IsValid( LShop_Menu01Panel ) ) then
		ItemListClear()
		ItemListAdd( LShop.cl.SelectedCategory )
	end
	if ( IsValid( LShop_Menu02Panel ) ) then
		ClearInventory()
		LoadInventory()
	end
	if ( IsValid( LShop_AdminPanel ) ) then
		Admin_PlayerListClear()
		Admin_PlayerListAdd()
	end
end)

net.Receive("LShop_Lang_SendTable", function( len, cl )
	LShop.lang.tablesCL = net.ReadTable() or {}
	LShop.lang.langconfigCL = net.ReadString() or LShop.Config.DefaultLanguageFile
end)

net.Receive("LShop_ClientFunctionRun", function( len, cl )
	local types = net.ReadString()
	local items = net.ReadTable()
	local target = net.ReadEntity()
	local itemFunc = LShop.system.ItemFindByID( items.ID, items.Category )
	if ( itemFunc ) then
		if ( types == "buy" ) then
			if ( itemFunc.Buyed ) then
				itemFunc.Buyed( itemFunc, target )
			end	
		elseif ( types == "sell" ) then
			if ( itemFunc.Selled ) then
				itemFunc.Selled( itemFunc, target )
			end			
		elseif ( types == "equ" ) then
			if ( itemFunc.Equipped ) then
				itemFunc.Equipped( itemFunc, target )
			end			
		elseif ( types == "unequ" ) then
			if ( itemFunc.Unequipped ) then
				itemFunc.Unequipped( itemFunc, target )
			end			
		end
	end
end)

concommand.Add( LShop.Config.OpenCommand , function( pl, cmd, args )
	LShop.cl.Intro()
end)