LShop.system.ItemRegister( {
	ID = "trail_electronic",
	Name = "Electronic Trail",
	Category = "Trail",
	Price = 100,
	CanBuy = true,
	CanSell = true,
	CanEquip = true,
	UseTillDeath = false,
	UnEquipped_IS_NotRemove = true,
	Desc = "This is Electronic Trail!, It's very cool!",
	Material = "trails/electric.vmt",
	Buyed = function( item, ply )
		ply.electronictrailer = util.SpriteTrail( ply, 0, Color( 255, 0, 0, 255 ), false, 15, 1, 4, 0.125, item.Material )
	end,
	Selled = function( item, ply )
		SafeRemoveEntity( ply.electronictrailer )
	end,
	Equipped = function( item, ply )
		ply.electronictrailer = util.SpriteTrail( ply, 0, Color( 255, 0, 0, 255 ), false, 15, 1, 4, 0.125, item.Material )
	end,
	Unequipped = function( item, ply )
		SafeRemoveEntity( ply.electronictrailer )
	end
} )