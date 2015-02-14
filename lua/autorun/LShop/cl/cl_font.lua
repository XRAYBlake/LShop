--[[
	LShop
	Copyright ( C ) 2014 by 'L7D'
--]]

local FontList = { }

FontList[ 1 ] = {
	Name = "LShop_MainTitle",
	Font = "Segoe UI Light",
	Size = 55
}

FontList[ 2 ] = {
	Name = "LShop_SubTitle",
	Font = "Segoe UI Light",
	Size = 40
}

FontList[ 3 ] = {
	Name = "LShop_ButtonText",
	Font = "Segoe UI Light",
	Size = 20
}

FontList[ 4 ] = {
	Name = "LShop_Category_Text",
	Font = "Segoe UI Light",
	Size = 25
}

FontList[ 5 ] = {
	Name = "LShop_MoneyNotice",
	Font = "Segoe UI Light",
	Size = 20
}

FontList[ 6 ] = {
	Name = "LShop_ButtonText2",
	Font = "Segoe UI Light",
	Size = 20
}

FontList[ 7 ] = {
	Name = "LShop_Intro_TeamText",
	Font = "Segoe UI Light",
	Size = 35
}

FontList[ 8 ] = {
	Name = "LShop_Intro_Title",
	Font = "Consolas Bold",
	Size = 65
}

FontList[ 9 ] = {
	Name = "LShop_Intro_Title_2",
	Font = "Consolas Bold",
	Size = 55
}

FontList[ 10 ] = {
	Name = "LShop_Intro_Version",
	Font = "Consolas Bold",
	Size = 15
}

FontList[ 11 ] = {
	Name = "LShop_Intro_LoadText",
	Font = "Consolas Bold",
	Size = 20
}

FontList[ 12 ] = {
	Name = "LShop_Intro_LoadText_2",
	Font = "Segoe UI Light",
	Size = 20
}

FontList[ 13 ] = {
	Name = "LShop_SU_Notice",
	Font = "Consolas Bold",
	Size = 17
}

for i = 1, #FontList do
	surface.CreateFont( FontList[i].Name, { font = FontList[i].Font, size = FontList[i].Size, weight = 1000 } )
end