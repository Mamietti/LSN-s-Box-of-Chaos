if !TFA_CSGO_SKINS then
	TFA_CSGO_SKINS = {}
end

if !TFA_CSGO_SKINS["tfa_csgo_mp7"] then
	TFA_CSGO_SKINS["tfa_csgo_mp7"] = {}
end

TFA_CSGO_SKINS["tfa_csgo_mp7"].carboned =  {
	['name'] = "Carbon Edition",
	['tbl'] = {
	"models/weapons/csgo/carbmp7"                    
	},
	['img'] = nil
}
print("Strafe's Skins Loaded!")

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
    name = "Weapon_9mmAR.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 100,
    sound = "weapons/mp5/smg1_fire1.wav"
} )
sound.Add( {
    name = "Weapon_9mmAR.Reload",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = "weapons/mp5/smg1_reload.wav"
} )
sound.Add( {
    name = "Weapon_HMG1.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 100,
    sound = {"weapons/hmg1/hmg1_7.wav","weapons/hmg1/hmg1_7.wav","weapons/hmg1/hmg1_7.wav"}
} )
sound.Add( {
    name = "Weapon_Eagle.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 100,
    sound = {"weapons/deagle/deagle_fire.wav"}
} )
sound.Add( {
    name = "Weapon_Eagle.Reload",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = {"weapons/deagle/deagle_reload.wav"}
} )
sound.Add( {
    name = "Weapon_SMG2.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 100,
    sound = {"weapons/mp5k/mp5k_fire1.wav"}
} )
sound.Add( {
    name = "Weapon_SMG2.Reload",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = {"weapons/mp5k/mp5k_reload.wav"}
} )
sound.Add( {
    name = "Weapon_Sniper.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 100,
    sound = {"weapons/sniper/sniper_fire.wav"}--sound = {"weapons/sniper_rifle_classic_shoot.wav"}--
} )
sound.Add( {
    name = "Weapon_Handgun.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 100,
    sound = {"weapons/glock/pistol_fire2.wav"}
} )
sound.Add( {
    name = "Weapon_Handgun.Reload",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = {"weapons/glock/pistol_reload1.wav"}
} )