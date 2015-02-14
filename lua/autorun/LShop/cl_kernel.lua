LShop = LShop or { cl = { }, OwnItemsCL = { }, PlyMoney = 0, system = { } }
LShop.cl.SelectedCategory = LShop.cl.SelectedCategory or nil
LShop.cl.SelectedMenu = LShop.cl.SelectedMenu or nil

function LShop.cl.LoadFiles( )
	local find = file.Find( "autorun/LShop/cl/*.lua", "LUA" )
	for k, v in pairs( find ) do
		include( "cl/" .. v )
	end
	
	local find2 = file.Find( "autorun/LShop/sh/*.lua", "LUA" )
	for k, v in pairs( find2 ) do
		include( "sh/" .. v )
	end
end

LShop.cl.LoadFiles( )

function LShop.cl.IsOwned( pl, itemID, category )
	local id = LShop.system.ItemFindByID( itemID, category )
	if ( !id ) then return false end
	for k, v in pairs( LShop.OwnItemsCL ) do
		if ( v.ID == itemID ) then
			return true
		end
	end
	
	return false
end

function LShop.cl.IsEquiped( pl, itemID, category )
	local id = LShop.system.ItemFindByID( itemID, category )
	if ( !id ) then return false end
	for k, v in pairs( LShop.OwnItemsCL ) do
		if ( v.ID == itemID and v.onEquip == true ) then
			return true
		end
	end
	
	return false
end

local META = FindMetaTable( "Player" )

function META:LShop_GetMoney( ) 
	return self:GetNWInt( "LShop_Money" )
end

function META:LShop_IsOwned( id, category ) 
	return LShop.cl.IsOwned( self, id, category )
end

function META:LShop_IsEquiped( id, category ) 
	return LShop.cl.IsEquiped( self, id, category )
end

net.Receive("LShop_MenuOpen", function( len, cl )
	LShop.cl.MainShop( )
end )

net.Receive("LShop_SendTable", function( len, cl )
	local ownitemTab = net.ReadTable( ) or { }
	LocalPlayer( ).OwnItemsCL = ownitemTab
	LShop.OwnItemsCL = ownitemTab
	LShop.PlyMoney = net.ReadString( ) or 0
	LShop.PlyMoney = tonumber( LShop.PlyMoney )
	if ( IsValid( LShop_Menu01Panel ) ) then
		ItemListClear( )
		ItemListAdd( LShop.cl.SelectedCategory )
	end
	if ( IsValid( LShop_Menu02Panel ) ) then
		ClearInventory( )
		LoadInventory( )
	end
	if ( IsValid( LShop_AdminPanel ) ) then
		Admin_PlayerListClear( )
		Admin_PlayerListAdd( )
	end
end )

net.Receive("LShop_Lang_SendTable", function( len, cl )
	LShop.lang.tablesCL = net.ReadTable( ) or { }
	LShop.lang.langconfigCL = net.ReadString( ) or LShop.Config.DefaultLanguageFile
end )

net.Receive("LShop_ClientFunctionRun", function( len, cl )
	local types = net.ReadString( )
	local items = net.ReadTable( )
	local target = net.ReadEntity( )
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
end )

concommand.Add( LShop.Config.OpenCommand, function( )
	LShop.cl.MainShop( )
end )