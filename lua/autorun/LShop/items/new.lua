-- NOTE: "UseTillDeath" differs with "OneUse" by restrict only on death. Good for ammo types.
-- Use one from above.
--[[
	LShop.system.ItemRegister( {
		ID = "new_item_code",
		Name = "Test Item",
		Category = "New", -- Very Important!
		Price = 100,
		CanBuy = true,
		CanSell = true,
		CanEquip = true,
		UseTillDeath = false,
		Desc = "This is test item!",
		Model = "models/error.mdl",
		Buyed = function( item, ply )

		end,
		Selled = function( item, ply )

		end,
		Equipped = function( item, ply )

		end,
		Unequipped = function( item, ply )

		end
	} )
--]]