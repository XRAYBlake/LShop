LShop = LShop or {}
LShop.system = LShop.system or {}
LShop.ITEMs = {}
LShop.system.WeekDay = {}

LShop.system.WeekDay[1] = {
	WeekName = "Mondey",
	WeekIndex = 2
}

LShop.system.WeekDay[2] = {
	WeekName = "Tuesday",
	WeekIndex = 3
}

LShop.system.WeekDay[3] = {
	WeekName = "Wednesday",
	WeekIndex = 4
}

LShop.system.WeekDay[4] = {
	WeekName = "Thursday",
	WeekIndex = 5
}

LShop.system.WeekDay[5] = {
	WeekName = "Friday",
	WeekIndex = 6
}

LShop.system.WeekDay[6] = {
	WeekName = "Saturday",
	WeekIndex = 7
}

LShop.system.WeekDay[7] = {
	WeekName = "Sunday",
	WeekIndex = 1
}


function LShop.system.ItemRegister( tab )
	if ( !LShop.ITEMs[ tab.Category ] ) then
		LShop.ITEMs[ tab.Category ] = {}
		for k, v in pairs( LShop.ITEMs[ tab.Category ] ) do
			if ( v.ID == tab.ID ) then
				LShop.ITEMs[ tab.Category ][ k ] = nil
			end
		end
		LShop.ITEMs[ tab.Category ][ #LShop.ITEMs[ tab.Category ] + 1 ] = tab
	else
		for k, v in pairs( LShop.ITEMs[ tab.Category ] ) do
			if ( v.ID == tab.ID ) then
				LShop.ITEMs[ tab.Category ][ k ] = nil
			end
		end
		LShop.ITEMs[ tab.Category ][ #LShop.ITEMs[ tab.Category ] + 1 ] = tab
	end
end

function LShop.system.GetItems( )
	return LShop.ITEMs
end

function LShop.system.GetItemsByCategory( category )
	for k, v in pairs( LShop.system.GetItems( ) ) do
		if ( k == category ) then
			return v
		else
			if ( k == #LShop.system.GetItems( ) ) then
				MsgC( Color( 255, 0, 0 ), "[LShop] Item find failed.\n" )
				return nil
			end
		end
	end
end

function LShop.system.ItemFindByID( id, category )
	for k, v in pairs( LShop.system.GetItems( ) ) do
		if ( k == category ) then
			for i, a in pairs( v ) do
				if ( a.ID == id ) then
					return a
				else
					if ( i == #v ) then
						MsgC( Color( 255, 0, 0 ), "[LShop] Item find failed.\n" )
						return nil
					end
				end
			end
		end
	end
end

function LShop.system.ItemFindByModel( model, category )
	for k, v in pairs( LShop.system.GetItems( ) ) do
		if ( k == category ) then
			for i, a in pairs( v ) do
				if ( a.Model ) then
					if ( a.Model == model ) then
						return a
					else
						if ( i == #v ) then
							MsgC( Color( 255, 0, 0 ), "[LShop] Item find failed.\n" )
							return nil
						end
					end
				else
					if ( i == #v ) then
						MsgC( Color( 255, 0, 0 ), "[LShop] Item find failed : Model is nil.\n" )
						return {}
					end				
				end
			end
		end
	end
end

function LShop.system.DaySale( )
	if ( !LShop.Config.DaySaleSystem ) then return end
	local day = os.date("*t")
	for i = 1, #LShop.system.WeekDay do
		if ( day.wday == LShop.Config.DayNumber ) then
			for k, v in pairs( LShop.ITEMs ) do
				for a, h in pairs( LShop.ITEMs[ k ] ) do
					for n = 1, #LShop.ITEMs[ k ] do
						h.Price = LShop.Config.SalePercent( h.Price )
					end
				end
			end
		else
			if ( i == #LShop.system.WeekDay ) then
				return
			end
		end
	end
end

LShop.ITEMs = {}

if ( CLIENT ) then
	function LShop.system.CSLoadItemFiles( )
		local find = file.Find("autorun/LShop/items/*.lua", "LUA") or {}

		if ( find ) then
			for k, v in pairs( find ) do
				include( "autorun/LShop/items/" .. v )
			end
		end
	end
	
	LShop.system.CSLoadItemFiles( )
end



if ( SERVER ) then
	util.AddNetworkString("LShop_ItemBuy")
	util.AddNetworkString("LShop_ItemSell")
	util.AddNetworkString("LShop_ItemEquip")
	util.AddNetworkString("LShop_ItemIsOwnCheck")
	util.AddNetworkString("LShop_ItemIsOwnCheck_SendCL")
	util.AddNetworkString("LShop_SendTable")
	util.AddNetworkString("LShop_SendTable_Request")
	util.AddNetworkString("LShop_SendMessage")
	util.AddNetworkString("LShop_BugNoticeSend")
	util.AddNetworkString("LShop_Admin_ItemGive")
	util.AddNetworkString("LShop_Admin_ItemTake")
	util.AddNetworkString("LShop_ItemSend")
	
	util.AddNetworkString("LShop_ClientFunctionRun")
	
	net.Receive("LShop_SendTable_Request", function( len, cl )
		net.Start("LShop_SendTable")
		net.WriteTable( cl.OwnItems )
		net.WriteString( cl.Money )
		net.Send( cl )
	end)

	net.Receive("LShop_ItemSend", function( len, cl )
		LShop.system.ItemSend( cl, net.ReadEntity(), net.ReadString(), net.ReadString() )
	end)
	
	net.Receive("LShop_Admin_ItemGive", function( len, cl )
		LShop.system.ItemGive( cl, net.ReadEntity(), net.ReadString(), net.ReadString() )
		LShop.system.SendDBToPlayer( cl )
	end)
	
	net.Receive("LShop_Admin_ItemTake", function( len, cl )
		LShop.system.ItemTake( cl, net.ReadEntity(), net.ReadString(), net.ReadString() )
		LShop.system.SendDBToPlayer( cl )
	end)
	
	net.Receive("LShop_ItemIsOwnCheck", function( len, cl )
		local check = self:LShop_IsOwn( net.ReadString() )
		if ( check ) then
			net.Start("LShop_ItemIsOwnCheck_SendCL")
			net.WriteString( "1" )
			net.Send( cl )
		else
			net.Start("LShop_ItemIsOwnCheck_SendCL")
			net.WriteString( "0" )
			net.Send( cl )
		end
	end)
	
	function LShop.system.SendBugNotice( pl, title, value )
		local tab = {}
		tab.BugTitle = title
		tab.BugValue = value
		net.Start("LShop_BugNoticeSend")
		net.WriteTable( tab )
		net.Send( pl )
	end
	
	function LShop.system.ItemSend( pl, target, itemID, category )
		local curretMoney = pl:LShop_GetMoney( )
		local item = LShop.system.ItemFindByID( itemID, category )
		local checkOwn = target:LShop_IsOwn( itemID, category )
		if ( checkOwn ) then
			net.Start("LShop_SendMessage")
			net.WriteString( LShop.lang.GetValue_Replace( pl, "LShop_Notice_5", { target:Name(), item.Name } ) )
			net.Send( pl )
			return
		end
		if ( item ) then
			if ( item.Price <= curretMoney ) then
				target.OwnItems[ #target.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
				if ( item.Buyed ) then
					item.Buyed( item, target )
				end
				net.Start("LShop_ClientFunctionRun")
				net.WriteString( "buy" )
				net.WriteTable( { ID = item.ID, Category = item.Category } )
				net.WriteEntity( target )
				net.Send( target )
				
				pl:LShop_TakeMoney( item.Price )
				net.Start("LShop_SendMessage")
				net.WriteString( LShop.lang.GetValue_Replace( pl, "LShop_Notice_6", { target:Name(), item.Name } ) )
				net.Send( pl )
				
				net.Start("LShop_SendMessage")
				net.WriteString( LShop.lang.GetValue_Replace( target, "LShop_Notice_7", { pl:Name(), item.Name } ) )
				net.Send( target )
				LShop.core.Message( Color( 0, 255, 0 ), "Item send : " .. target:SteamID() )
				return			
			else
				net.Start("LShop_SendMessage")
				net.WriteString( LShop.lang.GetValue( pl, "LShop_Notice_3" ) )
				net.Send( pl )			
			end
		else
			return
		end
	end
	
	function LShop.system.ItemGive( pl, target, itemID, category )
		local curretMoney = target:LShop_GetMoney( )
		local item = LShop.system.ItemFindByID( itemID, category )
		local checkOwn = target:LShop_IsOwn( itemID, category )
		
		if ( checkOwn ) then
			net.Start("LShop_SendMessage")
			net.WriteString( LShop.lang.GetValue_Replace( pl, "LShop_Notice_5", { target:Name(), item.Name } ) )
			net.Send( pl )
			return
		end
		if ( item ) then
				if ( !item.UseTillDeath ) then
					if ( #target.OwnItems != 0 ) then
						for k, v in pairs( target.OwnItems ) do
							if ( v.ID != itemID ) then
								target.OwnItems[ #target.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
								if ( item.Buyed ) then
									item.Buyed( item, target )
								end
								net.Start("LShop_ClientFunctionRun")
								net.WriteString( "buy" )
								net.WriteTable( { ID = item.ID, Category = item.Category } )
								net.WriteEntity( target )
								net.Send( target )
								LShop.core.Message( Color( 0, 255, 0 ), "Item give : " .. target:SteamID() )
								net.Start("LShop_SendMessage")
								net.WriteString( LShop.lang.GetValue_Replace( pl, "LShop_Notice_10", { target:Name(), item.Name } ) )
								net.Send( pl )
								return
							end
						end
					else
						target.OwnItems[ #target.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
						if ( item.Buyed ) then
							item.Buyed( item, target )
						end
						net.Start("LShop_ClientFunctionRun")
						net.WriteString( "buy" )
						net.WriteTable( { ID = item.ID, Category = item.Category } )
						net.WriteEntity( target )
						net.Send( target )
						LShop.core.Message( Color( 0, 255, 0 ), "Item give : " .. target:SteamID() )
						net.Start("LShop_SendMessage")
						net.WriteString( LShop.lang.GetValue_Replace( pl, "LShop_Notice_10", { target:Name(), item.Name } ) )
						net.Send( pl )
						return
					end
				else
					if ( #target.OwnItems != 0 ) then
						for k, v in pairs( target.OwnItems ) do
							if ( v.ID != itemID ) then
								target.OwnItems[ #target.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
								if ( item.Buyed ) then
									item.Buyed( item, target )
								end
								net.Start("LShop_ClientFunctionRun")
								net.WriteString( "buy" )
								net.WriteTable( { ID = item.ID, Category = item.Category } )
								net.WriteEntity( target )
								net.Send( target )
								LShop.core.Message( Color( 0, 255, 0 ), "Item give : " .. target:SteamID() )
								net.Start("LShop_SendMessage")
								net.WriteString( LShop.lang.GetValue_Replace( pl, "LShop_Notice_10", { target:Name(), item.Name } ) )
								net.Send( pl )
								return
							end
						end
					else
						target.OwnItems[ #target.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
						if ( item.Buyed ) then
							item.Buyed( item, target )
						end
						net.Start("LShop_ClientFunctionRun")
						net.WriteString( "buy" )
						net.WriteTable( { ID = item.ID, Category = item.Category } )
						net.WriteEntity( target )
						net.Send( target )
						LShop.core.Message( Color( 0, 255, 0 ), "Item give : " .. target:SteamID() )
						net.Start("LShop_SendMessage")
						net.WriteString( LShop.lang.GetValue_Replace( pl, "LShop_Notice_10", { target:Name(), item.Name } ) )
						net.Send( pl )
						return
					end
				end
		else
			return
		end
	end
	
	function LShop.system.ItemTake( pl, target, itemID, category )
		local item = LShop.system.ItemFindByID( itemID, category )
		local checkOwn = target:LShop_IsOwn( itemID, category )
		if ( checkOwn ) then
			target:LShop_ItemRemoveInventory( itemID, category )
			net.Start("LShop_SendMessage")
			net.WriteString( LShop.lang.GetValue_Replace( pl, "LShop_Notice_8", { item.Name } ) )
			net.Send( pl )
			LShop.core.Message( Color( 0, 255, 0 ), "Item take : " .. target:SteamID() )
			if ( item.Selled ) then
				item.Selled( item, target )
			end
			net.Start("LShop_ClientFunctionRun")
			net.WriteString( "sell" )
			net.WriteTable( { ID = item.ID, Category = item.Category } )
			net.WriteEntity( target )
			net.Send( target )
		else
			LShop.core.Message( Color( 255, 255, 0 ), "Not own this item! : " .. target:SteamID() )
			net.Start("LShop_SendMessage")
			net.WriteString( LShop.lang.GetValue( pl, "LShop_Notice_9" ) )
			net.Send( pl )
		end	
	end
	
	local Player = FindMetaTable("Player")
	
	function Player:LShop_ItemBuyProgress( itemID, category )
		
		local curretMoney = self:LShop_GetMoney( )
		local item = LShop.system.ItemFindByID( itemID, category )
		local price = item.Price
		local checkOwn = self:LShop_IsOwn( itemID, category )
		if ( checkOwn ) then
			if ( item.UseTillDeath ) then
				if ( !item.CanUnLimitedBuy ) then
					net.Start("LShop_SendMessage")
					net.WriteString( LShop.lang.GetValue_Replace( self, "LShop_Notice_4", { item.Name } ) )
					net.Send( self )
					return
				end
			end
		end
		if ( item ) then
			if ( LShop.Config.GroupDiscountEnabled ) then
				price = LShop.Config.GroupDiscount( self, item.Price )
			end
			if ( price <= curretMoney ) then
				if ( !item.UseTillDeath ) then
					if ( item.CanUnLimitedBuy ) then
						self.OwnItems[ #self.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
						self:LShop_TakeMoney( price )
						net.Start("LShop_SendMessage")
						net.WriteString( LShop.lang.GetValue( self, "LShop_Notice_1" ) )
						net.Send( self )
						if ( item.Buyed ) then
							item.Buyed( item, self )
						end
						net.Start("LShop_ClientFunctionRun")
						net.WriteString( "buy" )
						net.WriteTable( { ID = itemID, Category = category } )
						net.WriteEntity( self )
						net.Send( self )
						return					
					end
					if ( #self.OwnItems != 0 ) then
						for k, v in pairs( self.OwnItems ) do
							if ( v.ID != itemID ) then
								self.OwnItems[ #self.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
								self:LShop_TakeMoney( price )
								net.Start("LShop_SendMessage")
								net.WriteString( LShop.lang.GetValue( self, "LShop_Notice_1" ) )
								net.Send( self )
								if ( item.Buyed ) then
									item.Buyed( item, self )
								end
								net.Start("LShop_ClientFunctionRun")
								net.WriteString( "buy" )
								net.WriteTable( { ID = itemID, Category = category } )
								net.WriteEntity( self )
								net.Send( self )
								return
							end
						end
					else
						self.OwnItems[ #self.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
						self:LShop_TakeMoney( price )
						net.Start("LShop_SendMessage")
						net.WriteString( LShop.lang.GetValue( self, "LShop_Notice_1" ) )
						net.Send( self )
						if ( item.Buyed ) then
							item.Buyed( item, self )
						end
						net.Start("LShop_ClientFunctionRun")
						net.WriteString( "buy" )
						net.WriteTable( { ID = itemID, Category = category } )
						net.WriteEntity( self )
						net.Send( self )
						return
					end
				else
					if ( #self.OwnItems != 0 ) then
						for k, v in pairs( self.OwnItems ) do
							if ( v.ID != itemID ) then
								self.OwnItems[ #self.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
								self:LShop_TakeMoney( price )
								net.Start("LShop_SendMessage")
								net.WriteString( LShop.lang.GetValue( self, "LShop_Notice_1" ) )
								net.Send( self )
								if ( item.Buyed ) then
									item.Buyed( item, self )
								end
								net.Start("LShop_ClientFunctionRun")
								net.WriteString( "buy" )
								net.WriteTable( { ID = itemID, Category = category } )
								net.WriteEntity( self )
								net.Send( self )
								return
							end
						end
					else
						self.OwnItems[ #self.OwnItems + 1 ] = { ID = itemID, Category = category, onEquip = true }
						self:LShop_TakeMoney( price )
						net.Start("LShop_SendMessage")
						net.WriteString( LShop.lang.GetValue( self, "LShop_Notice_1" ) )
						net.Send( self )
						if ( item.Buyed ) then
							item.Buyed( item, self )
						end
						net.Start("LShop_ClientFunctionRun")
						net.WriteString( "buy" )
						net.WriteTable( { ID = itemID, Category = category } )
						net.WriteEntity( self )
						net.Send( self )
						return
					end
				end
			else
				net.Start("LShop_SendMessage")
				net.WriteString( LShop.lang.GetValue( self, "LShop_Notice_3" ) )
				net.Send( self )
			end
		else
			return
		end
	end
	
	function Player:LShop_ItemSellProgress( itemID, category )
		local item = LShop.system.ItemFindByID( itemID, category )
		local checkOwn = self:LShop_IsOwn( itemID, category )
		if ( checkOwn ) then
			self:LShop_ItemRemoveInventory( itemID, category )
			if ( LShop.Config.GroupDiscountEnabled ) then
				local price = LShop.Config.GroupDiscount( self, item.Price )
				self:LShop_AddMoney( price or 100 )
			else
				self:LShop_AddMoney( item.Price or 100 )
			end
			
			net.Start("LShop_SendMessage")
			net.WriteString( LShop.lang.GetValue( self, "LShop_Notice_2" ) )
			net.Send( self )
			if ( item.Selled ) then
				item.Selled( item, self )
			end
			net.Start("LShop_ClientFunctionRun")
			net.WriteString( "sell" )
			net.WriteTable( { ID = itemID, Category = category } )
			net.WriteEntity( self )
			net.Send( self )
			return
		end
	end
	
	function Player:LShop_IsOwn( itemID, category )
		local id = LShop.system.ItemFindByID( tostring( itemID ), category )
		if ( id ) then
			for k, v in pairs( self.OwnItems ) do
				if ( v.ID == itemID ) then
					return true
				else
					if ( k == #self.OwnItems ) then
						return nil
					end
				end
			end
		else
			return nil
		end
	end

	function Player:IsEquiped( itemID, category )
		local id = LShop.system.ItemFindByID( tostring( itemID ), category )
		if ( id ) then
			for k, v in pairs( self.OwnItems ) do
				if ( v.ID == itemID ) then
					if ( v.onEquip ) then
						return true
					else
						return false
					end
				else
					if ( k == #self.OwnItems ) then
						return nil
					end
				end
			end
		else
		
		end
	end

	function Player:LShop_ItemRemoveInventory( itemID, category )
		local buffer = {}
		for k, v in pairs( self.OwnItems ) do
			if ( v.ID == itemID ) then
				self.OwnItems[k] = nil
				for n, m in pairs( self.OwnItems ) do
					buffer[ #buffer + 1 ] = m
				end
				self.OwnItems = buffer
				return
			else
				if ( k == #self.OwnItems ) then
					return
				end
			end
		end
	end
	
	function Player:LShop_PlayerSpawn()
		local item = self:LShop_GetOwnedItem( )
		timer.Simple(1, function()
			if ( item ) then
				for k, v in pairs( item ) do
					local findItem = LShop.system.ItemFindByID( v.ID, v.Category )
					if ( findItem ) then
						if ( findItem.UseTillDeath ) then return end
						if ( findItem.Equipped ) then
							findItem.Equipped( findItem, self )
							net.Start("LShop_ClientFunctionRun")
							net.WriteString( "equ" )
							net.WriteTable( { ID = findItem.ID, Category = findItem.Category } )
							net.WriteEntity( self )
							net.Send( self )
						end
					else
						self:LShop_ItemRemoveInventory( v.ID, v.Category )
					end
				end
			end
		end)
	end
	
	function Player:LShop_PlayerDeath()
		local ownitem = self:LShop_GetOwnedItem( )
		for k, v in pairs( ownitem ) do
			local item = LShop.system.ItemFindByID( v.ID, v.Category )
			if ( item ) then
				if ( !self:IsEquiped( item.ID, item.Category ) ) then
					if ( item.UnEquipped_IS_NotRemove ) then
						return
					end
				end
				if ( item.UseTillDeath ) then
					self:LShop_ItemRemoveInventory( item.ID, item.Category )
				end
			else
				self:LShop_ItemRemoveInventory( v.ID, v.Category )
			end
		end
	end
	
	function Player:LShop_SaveData()
		local dirName = string.Replace( self:SteamID(), ":", "_" )
		file.CreateDir("Lshop/" .. dirName)
		file.Write("Lshop/" .. dirName .. "/Ownitems.txt", util.TableToJSON( self.OwnItems ))
		file.Write("Lshop/" .. dirName .. "/Money.txt", tostring( self.Money ))
		LShop.core.Message( Color( 0, 255, 0 ), "Player data saved : " .. self:SteamID() )
	end

	function Player:LShop_LoadData()
		local dirName = string.Replace( self:SteamID(), ":", "_" )
		if ( file.Exists("Lshop/" .. dirName .. "/Ownitems.txt", "DATA") ) then
			if ( file.Exists("Lshop/" .. dirName .. "/Money.txt", "DATA") ) then
				local money = file.Read("Lshop/" .. dirName .. "/Money.txt", "DATA") or 0
				local ownitems = file.Read("Lshop/" .. dirName .. "/Ownitems.txt", "DATA") or "[]"
				if ( ownitems != "" ) then
					self.Money = tonumber( money )
					self.OwnItems = util.JSONToTable( ownitems )
					LShop.core.Message( Color( 0, 255, 0 ), "Player data loaded : " .. self:SteamID() )
				else
					self.Money = 0
					self.OwnItems = {}				
				end
			else
				self.Money = 0
				self.OwnItems = {}
				self:LShop_SaveData()
			end
		else
			self.Money = 0
			self.OwnItems = {}
			self:LShop_SaveData()
		end
	end

	function Player:LShop_PlayerInitialSpawn()
		-- Deleted :)
	end
	
	function Player:LShop_PlayerAuthed()
		self.Money = 0
		self.OwnItems = {}

		timer.Simple( 2, function()
			if ( IsValid( self ) ) then
				self:LShop_LoadData()
				net.Start("LShop_SendTable")
				net.WriteTable( self.OwnItems )
				net.WriteString( self.Money )
				net.Send( self )
				self:LShop_SetMoney( self.Money )
				for k, v in pairs( self.OwnItems ) do
					if ( v.onEquip ) then
						local id = LShop.system.ItemFindByID( v.ID, v.Category )
						if ( id ) then
							if ( id.Equipped ) then
								id.Equipped( id, self )
								net.Start("LShop_ClientFunctionRun")
								net.WriteString( "equ" )
								net.WriteTable( { ID = id.ID, Category = id.Category } )
								net.WriteEntity( self )
								net.Send( self )
							end
						end
					end
				end
			end
		end)
		
		timer.Create("LShop_AutoMoneyGive_" .. self:SteamID(), LShop.Config.MoneyGiveTimer, 0, function() 
			if ( LShop.Config.AutoMoneyGive ) then
				self:LShop_AddMoney( LShop.Config.MoneyAmmount )
				LShop.system.Notify( self, LShop.lang.GetValue_Replace( self, "LShop_Notify_AutoMoneyGive", { LShop.Config.MoneyAmmount } ) )
			end
		end)
	end

	function Player:LShop_PlayerDisconnected()
		self:LShop_SaveData()
		if ( timer.Exists( "LShop_AutoMoneyGive_" .. self:SteamID() ) ) then
			timer.Destroy( "LShop_AutoMoneyGive_" .. self:SteamID() )
		end
	end
	
	function Player:LShop_GetOwnedItem( )
		return self.OwnItems
	end
	
	hook.Add("ShutDown", "LShop_ShutDown", function( )
		for k, v in pairs( player.GetAll() ) do
			v:LShop_SaveData()
		end
	end)

	hook.Add("PlayerSpawn", "LShop_PlayerSpawn", function( pl ) pl:LShop_PlayerSpawn() end)
	hook.Add("PlayerDeath", "LShop_PlayerDeath", function( pl ) pl:LShop_PlayerDeath() end)
	hook.Add("PlayerInitialSpawn", "LShop_PlayerInitialSpawn", function( pl ) pl:LShop_PlayerInitialSpawn() end)
	hook.Add("PlayerDisconnected", "LShop_PlayerDisconnected", function( pl ) pl:LShop_PlayerDisconnected() end)
	hook.Add("PlayerAuthed", "LShop_PlayerAuthed", function( pl ) pl:LShop_PlayerAuthed() end)
	
	net.Receive("LShop_ItemBuy", function( len, cl )
		local category = net.ReadString()
		local itemID = net.ReadString()
		cl:LShop_ItemBuyProgress( itemID, category )
		LShop.system.SendDBToPlayer( cl )
		cl:LShop_SaveData()
	end)
	
	net.Receive("LShop_ItemSell", function( len, cl )
		local category = net.ReadString()
		local itemID = net.ReadString()
		cl:LShop_ItemSellProgress( itemID, category )
		LShop.system.SendDBToPlayer( cl )
		cl:LShop_SaveData()
	end)
	
	net.Receive("LShop_ItemEquip", function( len, cl )
		local category = net.ReadString()
		local itemID = net.ReadString()
		local bool = net.ReadString()
		cl:onEquipProgress( itemID, bool, category )
		cl:LShop_SaveData()
	end)

	function LShop.system.SendDBToPlayer( pl )
		if ( IsValid( pl ) ) then
			net.Start("LShop_SendTable")
			net.WriteTable( pl.OwnItems )
			net.WriteString( pl.Money )
			net.Send( pl )	
		end
	end
	
	function Player:onEquipProgress( itemID, bool, category )
		local id = LShop.system.ItemFindByID( itemID, category )
		if ( id ) then
			for k, v in pairs( self.OwnItems ) do
				if ( v.ID == itemID ) then
					v.onEquip = tobool( bool )
					if ( v.onEquip == true ) then 
						net.Start("LShop_SendMessage")
						net.WriteString( LShop.lang.GetValue( self, "LShop_Notice_11" ) )
						net.Send( self )
					else
						net.Start("LShop_SendMessage")
						net.WriteString( LShop.lang.GetValue( self, "LShop_Notice_12" ) )
						net.Send( self )
					end
					if ( v.onEquip ) then
						if ( id.Equipped ) then
							id.Equipped( id, self )
							net.Start("LShop_ClientFunctionRun")
							net.WriteString( "equ" )
							net.WriteTable( { ID = id.ID, Category = id.Category } )
							net.WriteEntity( self )
							net.Send( self )
						end
					else
						if ( id.Unequipped ) then
							id.Unequipped( id, self )
							net.Start("LShop_ClientFunctionRun")
							net.WriteString( "unequ" )
							net.WriteTable( { ID = id.ID, Category = id.Category } )
							net.WriteEntity( self )
							net.Send( self )
						end
					end
					LShop.system.SendDBToPlayer( self )
					return
				else				
					if ( k == #self.OwnItems ) then
						net.Start("LShop_SendMessage")
						net.WriteString( LShop.lang.GetValue( "LShop_Error_2" ) )
						net.Send( self )
						return
					end
				end
			end
		end
	end
	
	function LShop.system.SVLoadItemFiles( )
		local find = file.Find("autorun/LShop/items/*.lua", "LUA") or {}

		if ( find ) then
			for k, v in pairs( find ) do
				LShop.core.LoadFile( "autorun/LShop/items/" .. v )
				LShop.core.CSLoadFile( "autorun/LShop/items/" .. v )
			end
		end
	end
	
	LShop.system.SVLoadItemFiles( )
end

LShop.system.DaySale( )
