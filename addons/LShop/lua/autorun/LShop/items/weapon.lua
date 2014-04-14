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
	UseTillDeath = true,
	UnEquipped_IS_NotRemove = true,
	Desc = "This is Crowbar, it's simple!",
	Model = "models/weapons/w_crowbar.mdl",
	Buyed = function( item, ply )
		if ( SERVER ) then
			ply:Give( item.Weapon_ID )
		end
	end,
	Selled = function( item, ply )
		if ( SERVER ) then
			ply:StripWeapon( item.Weapon_ID )
		end
	end,
	Equipped = function( item, ply )
		if ( SERVER ) then
			ply:Give( item.Weapon_ID )
		end
	end,
	Unequipped = function( item, ply )
		if ( SERVER ) then
			ply:StripWeapon( item.Weapon_ID )
		end
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
	UseTillDeath = true,
	UnEquipped_IS_NotRemove = true,
	Desc = "This is Pistol, it's simple!",
	Model = "models/weapons/W_pistol.mdl",
	Buyed = function( item, ply )
		if ( SERVER ) then
			ply:Give( item.Weapon_ID )
		end
	end,
	Selled = function( item, ply )
		if ( SERVER ) then
			ply:StripWeapon( item.Weapon_ID )
		end
	end,
	Equipped = function( item, ply )
		if ( SERVER ) then
			ply:Give( item.Weapon_ID )
		end
	end,
	Unequipped = function( item, ply )
		if ( SERVER ) then
			ply:StripWeapon( item.Weapon_ID )
		end
	end
} )

LShop.system.ItemRegister( {
	ID = "smg",
	Name = "SMG",
	Category = "Weapon",
	Price = 120,
	Weapon_ID = "weapon_smg1",
	Type = "weapon",
	CanBuy = true,
	CanSell = true,
	CanEquip = true,
	UseTillDeath = true,
	UnEquipped_IS_NotRemove = true,
	Desc = "This is SMG, it's simple!",
	Model = "models/weapons/w_smg1.mdl",
	Buyed = function( item, ply )
		if ( SERVER ) then
			ply:Give( item.Weapon_ID )
		end
	end,
	Selled = function( item, ply )
		if ( SERVER ) then
			ply:StripWeapon( item.Weapon_ID )
		end
	end,
	Equipped = function( item, ply )
		if ( SERVER ) then
			ply:Give( item.Weapon_ID )
		end
	end,
	Unequipped = function( item, ply )
		if ( SERVER ) then
			ply:StripWeapon( item.Weapon_ID )
		end
	end
} )

LShop.system.ItemRegister( {
	ID = "ar2",
	Name = "AR2",
	Category = "Weapon",
	Price = 180,
	Weapon_ID = "weapon_ar2",
	Type = "weapon",
	CanBuy = true,
	CanSell = true,
	CanEquip = true,
	UseTillDeath = true,
	UnEquipped_IS_NotRemove = true,
	Desc = "This is AR2, it's simple!",
	Model = "models/weapons/w_irifle.mdl",
	Buyed = function( item, ply )
		if ( SERVER ) then
			ply:Give( item.Weapon_ID )
		end
	end,
	Selled = function( item, ply )
		if ( SERVER ) then
			ply:StripWeapon( item.Weapon_ID )
		end
	end,
	Equipped = function( item, ply )
		if ( SERVER ) then
			ply:Give( item.Weapon_ID )
		end
	end,
	Unequipped = function( item, ply )
		if ( SERVER ) then
			ply:StripWeapon( item.Weapon_ID )
		end
	end
} )