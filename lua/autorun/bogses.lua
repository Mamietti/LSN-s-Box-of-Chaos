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
sound.Add( {
    name = "Weapon_HMG1.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 100,
    sound = {"weapons/hmg1/hmg1_7.wav","weapons/hmg1/hmg1_7.wav","weapons/hmg1/hmg1_7.wav"}
} )
sound.Add( {
    name = "Weapon_Chargebow.ChargeStart",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 80,
    sound = {"weapons/drink_up.wav"}
} )
sound.Add( {
    name = "Weapon_Sniper.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 100,
    sound = {"weapons/sniper/sniper_fire1.wav"}
} )
sound.Add( {
    name = "Weapon_Sniper.BoltBack",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = {"weapons/sniper/sniper_boltback.wav"}
} )
sound.Add( {
    name = "Weapon_Sniper.BoltForward",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = {"weapons/sniper/sniper_boltforward.wav"}
} )
sound.Add( {
    name = "Weapon_Sniper.ClipIn",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = {"weapons/sniper/sniper_clipin.wav"}
} )
sound.Add( {
    name = "Weapon_Sniper.ClipOut",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = {"weapons/sniper/sniper_clipout.wav"}
} )
sound.Add( {
    name = "Weapon_9mmAR.Reload",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = {"weapons/9mmar/9mmar_reload.wav"}
} )
sound.Add( {
    name = "Weapon_TripleSMG.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = 120,
    sound = "weapons/smg1/smg1_triple_fire1.wav"
} )
local NPC = {
	Name = "Robo Grunt",
	Class = "npc_robo_grunt",
	Category = "Robot",
	KeyValues = { SquadName = "robot" }
}
list.Set( "NPC", NPC.Class, NPC )
Add_NPC_Class( "CLASS_ROBOT" )