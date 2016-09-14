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
    language.Add( "HelicopterGun_ammo", "Heavy Ammo" )
    language.Add( "GaussEnergy_ammo", "Depleted Uranium-235" )
    language.Add( "9mmRound_ammo", "9mm Ammo" )
    language.Add( "SniperRound_ammo", "Sniper Ammo" )
    language.Add( "MP5_Grenade_ammo", "20mm Grenades" )
    language.Add( "Battery_ammo", "Microfusion Cells" )
end

hook.Add("HUDShouldDraw", "Dont Show Kill Feed", function(hudelement)
  if hudelement=='CHudDeathNotice' then return false end
end)
local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end
sound.Add( {
    name = "Weapon_HMG1.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 100,
    sound = {"weapons/hmg1/hmg1_7.wav","weapons/hmg1/hmg1_7.wav","weapons/hmg1/hmg1_7.wav"}
} )
sound.Add( {
    name = "Weapon_SPistol.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = {95,105},
    sound = {"weapons/spistol/gun_silencer.wav"}
} )