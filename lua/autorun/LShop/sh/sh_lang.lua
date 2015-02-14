--[[
	LShop
	Copyright ( C ) 2014 by 'L7D'
--]]

LShop.lang = LShop.lang or { }

if ( SERVER ) then
	LShop.lang.tables = LShop.lang.tables or { }
	
	util.AddNetworkString( "LShop_Lang_SendTable" )
	util.AddNetworkString( "LShop_Lang_SaveConfig" )
	
	net.Receive("LShop_Lang_SaveConfig", function( len, cl )
		local newLangConfig = net.ReadString( )
		cl.LangConfig = newLangConfig
		cl:LShop_Lang_SaveData( )
	end )
	
	local META = FindMetaTable( "Player" )

	function META:LShop_Lang_SaveData( )
		local dirName = string.Replace( self:SteamID( ), ":", "_" )
		file.CreateDir( "Lshop/" .. dirName )
		file.Write( "Lshop/" .. dirName .. "/Language.txt", tostring( self.LangConfig ) )	
	end
	
	function META:LShop_Lang_LoadData( )
		local dirName = string.Replace( self:SteamID( ), ":", "_" )
		if ( file.Exists("Lshop/" .. dirName .. "/Language.txt", "DATA") ) then	
			local languageFile = file.Read("Lshop/" .. dirName .. "/Language.txt", "DATA") or LShop.Config.DefaultLanguageFile
			if ( languageFile != "nil" ) then
				self.LangConfig = languageFile
				LShop.lang.SendTableToPlayer( self )
			else
				languageFile = file.Read("Lshop/" .. dirName .. "/Language.txt", "DATA") or LShop.Config.DefaultLanguageFile
				self.LangConfig = LShop.Config.DefaultLanguageFile or "en"
				self:LShop_Lang_SaveData( )
				self.LangConfig = languageFile
				LShop.lang.SendTableToPlayer( self )				
			end
		else
			self.LangConfig = LShop.Config.DefaultLanguageFile or "en"
		end
	end

	function META:LShop_Lang_PlayerDisconnected( )
		self:LShop_Lang_SaveData( )
	end
	
	function META:LShop_Lang_PlayerAuthed( )
		self.LangConfig = LShop.Config.DefaultLanguageFile or "en"
		
		self:LShop_Lang_LoadData()
		LShop.lang.SendTableToPlayer( self )
	end
	
	hook.Add("ShutDown", "LShop_Lang_ShutDown", function( )
		for k, v in pairs( player.GetAll( ) ) do
			v:LShop_Lang_SaveData( )
		end
	end )
	
	hook.Add("PlayerDisconnected", "LShop_Lang_PlayerDisconnected", function( pl ) pl:LShop_Lang_PlayerDisconnected( ) end )
	hook.Add("PlayerAuthed", "LShop_Lang_PlayerAuthed", function( pl ) pl:LShop_Lang_PlayerAuthed( ) end )
	
	function LShop.lang.Register( langid )
		local exists = file.Read( "autorun/LShop/lang/" .. langid .. ".lua", "LUA" ) or nil
		if ( !exists ) then
			return ErrorNoHalt( "[LShop] Can't found language file!!! - " .. langid .. ".lua\n" )
		end
		local langFile = CompileFile( "autorun/LShop/lang/" .. langid .. ".lua" )( )
		LShop.lang.tables[ langid ] = langFile
	end
	
	function LShop.lang.SendTableToPlayer( pl )
		if ( !IsValid( pl ) ) then return end
		net.Start( "LShop_Lang_SendTable" )
		net.WriteTable( LShop.lang.tables )
		net.WriteString( pl.LangConfig )
		net.Send( pl )
	end
	
	function LShop.lang.SendTableToAllPlayers( )
		for k, v in pairs( player.GetAll( ) ) do
			net.Start( "LShop_Lang_SendTable" )
			net.WriteTable( LShop.lang.tables )
			net.WriteString( v.LangConfig )
			net.Send( v )
		end
	end

	LShop.lang.Register( "en" )
	LShop.lang.Register( "ko" )
	LShop.lang.SendTableToAllPlayers( )
	
	concommand.Add("LShop_lang_resend", function( pl )
		if ( IsValid( pl ) ) then
			if ( !LShop.Config.PermissionCheck( pl ) ) then return end
			LShop.lang.SendTableToAllPlayers( )
		else
			LShop.lang.SendTableToAllPlayers( )
		end
	end )
	
	function LShop.lang.GetValue( pl, langValueCode )
		local langID = pl.LangConfig or LShop.Config.DefaultLanguageFile
		local codeCount = 0
		local progressCount = 0
		if ( LShop.lang.tables[ langID ] ) then
			for k1, _ in pairs( LShop.lang.tables[ langID ] ) do
				codeCount = codeCount + 1
			end
			for k, v in pairs( LShop.lang.tables[ langID ] ) do
				progressCount = progressCount + 1
				if ( k == langValueCode ) then
					return v
				else
					if ( codeCount == progressCount ) then
						return "ERROR!"
					end
				end
			end
		else
			return "ERROR!"
		end
	end
	
	function LShop.lang.GetValue_Replace( pl, langValueCode, tab )
		local langID = pl.LangConfig or LShop.Config.DefaultLanguageFile
		local codeCount = 0
		local progressCount = 0
		local replaceCount = 1
		
		if ( LShop.lang.tables[ langID ] ) then
			for k1, _ in pairs( LShop.lang.tables[ langID ] ) do
				codeCount = codeCount + 1
			end
			for k, v in pairs( LShop.lang.tables[ langID ] ) do
				progressCount = progressCount + 1
				if ( k == langValueCode ) then
					local ex = string.Explode( " ", v )
					
					for k3, v3 in pairs( ex ) do
						if ( string.match( v3, "#" ) ) then
							if ( tab[ replaceCount ] ) then
								v3 = string.Replace( v3, v3, tostring( tab[ replaceCount ] ) )
								ex[ k3 ] = v3
								replaceCount = replaceCount + 1
							else
								v3 = string.Replace( v3, v3, "ERROR" )
								ex[ k3 ] = v3							
							end
						end
						if ( k3 == #ex ) then
							return string.Implode( " ", ex )
						end
					end
				else
					if ( codeCount == progressCount ) then
						return "ERROR!"
					end
				end
			end
		else
			return "ERROR!"
		end
	end
else
	LShop.lang.tablesCL = LShop.lang.tablesCL or { }
	LShop.lang.langconfigCL = LShop.lang.langconfigCL or LShop.Config.DefaultLanguageFile

	function LShop.lang.GetValue( langValueCode )
		local langID = LShop.lang.langconfigCL or LShop.Config.DefaultLanguageFile
		local codeCount = 0
		local progressCount = 0
		if ( LShop.lang.tablesCL[ langID ] ) then
			for k1, _ in pairs( LShop.lang.tablesCL[ langID ] ) do
				codeCount = codeCount + 1
			end
			for k, v in pairs( LShop.lang.tablesCL[ langID ] ) do
				progressCount = progressCount + 1
				if ( k == langValueCode ) then
					return v
				else
					if ( codeCount == progressCount ) then
						return "ERROR!"
					end
				end
			end
		else
			return "ERROR!"
		end
	end
	
	function LShop.lang.GetValue_Replace( langValueCode, tab )
		local langID = LShop.lang.langconfigCL or LShop.Config.DefaultLanguageFile
		local codeCount = 0
		local progressCount = 0
		local replaceCount = 1
		
		if ( LShop.lang.tablesCL[ langID ] ) then
			for k1, _ in pairs( LShop.lang.tablesCL[ langID ] ) do
				codeCount = codeCount + 1
			end
			for k, v in pairs( LShop.lang.tablesCL[ langID ] ) do
				progressCount = progressCount + 1
				if ( k == langValueCode ) then
					local ex = string.Explode( " ", v )
					
					for k3, v3 in pairs( ex ) do
						if ( string.match( v3, "#" ) ) then
							if ( tab[ replaceCount ] ) then
								v3 = string.Replace( v3, v3, tostring( tab[ replaceCount ] ) )
								ex[ k3 ] = v3
								replaceCount = replaceCount + 1
							else
								v3 = string.Replace( v3, v3, "ERROR" )
								ex[ k3 ] = v3							
							end
						end
						if ( k3 == #ex ) then
							return string.Implode( " ", ex )
						end
					end
				else
					if ( codeCount == progressCount ) then
						return "ERROR!"
					end
				end
			end
		else
			return "ERROR!"
		end
	end
end