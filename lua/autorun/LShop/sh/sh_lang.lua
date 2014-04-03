LShop.lang = LShop.lang or {}



if ( SERVER ) then
	function LShop.lang.Register( langid )
		local langFile = CompileFile( "autorun/LShop/lang/" .. langid .. ".lua" )()

	end

	LShop.lang.Register( "en" )
end