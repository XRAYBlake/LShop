local FontList = {}

FontList[1] = {
	Name = "LShop_MainTitle",
	Font = "Segoe UI Light",
	Size = 55
}

FontList[2] = {
	Name = "LShop_SubTitle",
	Font = "Segoe UI Light",
	Size = 40
}

FontList[3] = {
	Name = "LShop_ButtonText",
	Font = "Segoe UI Light",
	Size = 20
}

FontList[4] = {
	Name = "LShop_Category_Text",
	Font = "Segoe UI Light",
	Size = 25
}

FontList[5] = {
	Name = "LShop_MoneyNotice",
	Font = "Segoe UI Light",
	Size = 20
}

FontList[6] = {
	Name = "LShop_ButtonText2",
	Font = "Segoe UI Light",
	Size = 20
}

FontList[7] = {
	Name = "LShop_Intro_TeamText",
	Font = "Segoe UI Light",
	Size = 65
}

for i = 1, #FontList do
	if ( FontList[i].Name && FontList[i].Font && FontList[i].Size ) then
		surface.CreateFont( FontList[i].Name, { font = FontList[i].Font, size = FontList[i].Size, weight = 1000 } )
	else
		MsgC( Color( 255, 0, 0 ), "[LShop] ERROR : Font register failed!\n" )
	end
end

--[[// #################################### //
	= LShop New Font System Document =

	FontList[ Index ] = { -- WARNING : Index value must be number value!
		Name = "Font Unique Name", -- EX : LShop_TESTFont
		Font = "Font Name", -- EX : Arial
		Size = Font Size -- EX : 20 or ScreenScale( 15 )
	}
--]]// #################################### //