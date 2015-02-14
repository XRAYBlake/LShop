--[[
	LShop
	Copyright ( C ) 2014 by 'L7D'
--]]

LShop.system.ItemRegister( {
	ID = "medical_big_healthkit",
	Name = "Health Kit - Large",
	Category = "Medical",
	Price = 200,
	Health_Add = 70,
	CanBuy = true,
	CanSell = false,
	CanEquip = false,
	UseTillDeath = true,
	CanUnLimitedBuy = true,
	Desc = "This is Health Kit - Large size, Ohh you are now sick?",
	Model = "models/items/healthkit.mdl",
	Buyed = function( item, ply )
		if ( SERVER ) then
			ply:SetHealth( ply:Health() + item.Health_Add )
		end
	end,
	Equipped = function( item, ply )
		if ( SERVER ) then
			ply:SetHealth( ply:Health() + item.Health_Add )
		end
	end
} )

LShop.system.ItemRegister( {
	ID = "medical_small_healthkit",
	Name = "Health Kit - Small",
	Category = "Medical",
	Price = 100,
	Health_Add = 30,
	CanBuy = true,
	CanSell = false,
	CanEquip = false,
	UseTillDeath = true,
	CanUnLimitedBuy = true,
	Desc = "This is Health Kit - Small size, Ohh you are now sick?",
	Model = "models/healthvial.mdl",
	Buyed = function( item, ply )
		if ( SERVER ) then
			ply:SetHealth( ply:Health() + item.Health_Add )
		end
	end,
	Equipped = function( item, ply )
		if ( SERVER ) then
			ply:SetHealth( ply:Health() + item.Health_Add )
		end
	end
} )

LShop.system.ItemRegister( {
	ID = "medical_armorkit",
	Name = "Armor Kit",
	Category = "Medical",
	Price = 10,
	Armor_Add = 10,
	CanBuy = true,
	CanSell = false,
	CanEquip = false,
	UseTillDeath = true,
	CanUnLimitedBuy = true,
	Desc = "This is Armor Kit, Bonk!",
	Model = "models/items/battery.mdl",
	Buyed = function( item, ply )
		if ( SERVER ) then
			ply:SetArmor( ply:Armor() + item.Armor_Add )
		end
	end,
	Equipped = function( item, ply )
		if ( SERVER ) then
			ply:SetArmor( ply:Armor() + item.Armor_Add )
		end
	end
} )