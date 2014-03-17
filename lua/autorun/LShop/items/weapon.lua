LShop.system.ItemRegister( {
	ID = "crowbar",
	Name = "Crowbar",
	Category = "Weapon",
	Price = 50,
	Weapon_ID = "weapon_crowbar",
	Type = "weapon",
	CanBuy = true,
	CanSell = true,
	CanEquip = true,
	OneUse = true,
	Desc = "This is Crowbar, it's simple!",
	Model = "models/weapons/w_crowbar.mdl",
	Buyed = function( item, ply )
		ply:Give( item.Weapon_ID )
	end,
	Selled = function( item, ply )
		ply:StripWeapon( item.Weapon_ID )
	end,
	Equipped = function( item, ply )
		ply:Give( item.Weapon_ID )
	end,
	Unequipped = function( item, ply )
		ply:StripWeapon( item.Weapon_ID )
	end
} )

LShop.system.ItemRegister( {
	ID = "pistol",
	Name = "Pistol",
	Category = "Weapon",
	Price = 60,
	Weapon_ID = "weapon_pistol",
	Type = "weapon",
	CanBuy = true,
	CanSell = true,
	CanEquip = true,
	OneUse = true,
	Desc = "This is Pistol, it's simple!",
	Model = "models/weapons/W_pistol.mdl",
	Buyed = function( item, ply )
		ply:Give( item.Weapon_ID )
	end,
	Selled = function( item, ply )
		ply:StripWeapon( item.Weapon_ID )
	end,
	Equipped = function( item, ply )
		ply:Give( item.Weapon_ID )
	end,
	Unequipped = function( item, ply )
		ply:StripWeapon( item.Weapon_ID )
	end
} )

LShop.system.ItemRegister( {
	ID = "smg",
	Name = "SMG",
	Category = "Weapon",
	Price = 100,
	Weapon_ID = "weapon_smg1",
	Type = "weapon",
	CanBuy = true,
	CanSell = true,
	CanEquip = true,
	OneUse = true,
	Desc = "This is SMG, it's simple!",
	Model = "models/weapons/w_smg1.mdl",
	Buyed = function( item, ply )
		ply:Give( item.Weapon_ID )
	end,
	Selled = function( item, ply )
		ply:StripWeapon( item.Weapon_ID )
	end,
	Equipped = function( item, ply )
		ply:Give( item.Weapon_ID )
	end,
	Unequipped = function( item, ply )
		ply:StripWeapon( item.Weapon_ID )
	end
} )