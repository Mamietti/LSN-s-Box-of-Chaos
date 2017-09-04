if CLIENT then
	surface.CreateFont( "HL2HUDFONT", {
		font = "HalfLife2",
		size = 120,
		weight = 500,
		blursize = 0,
		scanlines = 16,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = true,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = true,
		outline = false,
	} )
	surface.CreateFont( "CSKillIcons", {
		font = "csd",
		size = 120,
		weight = 500,
		blursize = 0,
		scanlines = 16,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = true,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = true,
		outline = true,
	} )
    language.Add( "GaussEnergy_ammo", "Depleted Uranium-235" )
    language.Add( "SniperRound_ammo", "Sniper Ammo" )
    language.Add( "Manhack_ammo", "Manhacks" )
    language.Add( "FlareRound_ammo", "Flares" )
end

game.AddAmmoType( {
	name = "Manhack",
	dmgtype = DMG_SLASH,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 2000,
	minsplash = 10,
	maxsplash = 5
} )