--[[
	LShop
	Copyright ( C ) 2014 by 'L7D'
--]]

LShop.system.ItemRegister( {
	ID = "trail_electronic",
	Name = "Electronic Trail",
	Category = "Trail",
	Price = 300,
	CanBuy = true,
	CanSell = true,
	CanEquip = true,
	UseTillDeath = false,
	UnEquipped_IS_NotRemove = true,
	Desc = "This is Electronic Trail!, It's very cool!",
	Material = "trails/electric.vmt",
	Buyed = function( item, ply )
		if ( SERVER ) then
			ply.electronictrailer = util.SpriteTrail( ply, 0, Color( 255, 255, 255, 255 ), false, 15, 1, 4, 0.125, item.Material )
		end
	end,
	Selled = function( item, ply )
		if ( SERVER ) then
			SafeRemoveEntity( ply.electronictrailer )
		end
	end,
	Equipped = function( item, ply )
		if ( SERVER ) then
			ply.electronictrailer = util.SpriteTrail( ply, 0, Color( 255, 255, 255, 255 ), false, 15, 1, 4, 0.125, item.Material )
		end
	end,
	Unequipped = function( item, ply )
		if ( SERVER ) then
			SafeRemoveEntity( ply.electronictrailer )
		end
	end
} )

LShop.system.ItemRegister( {
	ID = "trail_love",
	Name = "Love Trail",
	Category = "Trail",
	Price = 300,
	CanBuy = true,
	CanSell = true,
	CanEquip = true,
	UseTillDeath = false,
	UnEquipped_IS_NotRemove = true,
	Desc = "This is Love Trail!, It's very cool!",
	Material = "trails/love.vmt",
	Buyed = function( item, ply )
		if ( SERVER ) then
			ply.lovetrailer = util.SpriteTrail( ply, 0, Color( 255, 255, 255, 255 ), false, 15, 1, 4, 0.125, item.Material )
		end
	end,
	Selled = function( item, ply )
		if ( SERVER ) then
			SafeRemoveEntity( ply.lovetrailer )
		end
	end,
	Equipped = function( item, ply )
		if ( SERVER ) then
			ply.lovetrailer = util.SpriteTrail( ply, 0, Color( 255, 255, 255, 255 ), false, 15, 1, 4, 0.125, item.Material )
		end
	end,
	Unequipped = function( item, ply )
		if ( SERVER ) then
			SafeRemoveEntity( ply.lovetrailer )
		end
	end
} )