LShop.system.ItemRegister( {
	ID = "pistol",
	Name = "Pistol",
	Category = "Weapon",
	Price = 100,
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