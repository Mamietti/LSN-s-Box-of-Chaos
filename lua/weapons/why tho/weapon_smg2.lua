return
SWEP.PrintName			= "Beta SMG2"
SWEP.Author			= "Strafe"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = "When you are so beta you use HL2 Beta weapons."
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/c_MP5K.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_mp5k.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "smg"
SWEP.FiresUnderwater = false
SWEP.Dual = false
SWEP.ReloadSound = "Weapon_SMG2.Reload"
SWEP.Base = "weapon_hl2_base_strafe"

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.DamageBase = "sk_plr_dmg_smg1"
SWEP.Primary.DamageMult = 1.25
SWEP.Primary.Force = 2
SWEP.Primary.FireSound = "Weapon_SMG2.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.04*0.75
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.TracerAmount = 3
SWEP.Primary.FireRate = 0.075*1.25

SWEP.EASY_DAMPEN = 0.5
SWEP.MAX_VERTICAL_KICK = 1
SWEP.SLIDE_LIMIT = 2
SWEP.KICK_MIN_X = 0.2
SWEP.KICK_MIN_Y = 0.2
SWEP.KICK_MIN_Z = 0.1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( Color(255, 220, 0, 255) )
    surface.SetMaterial( Material("sprites/w_icons1b.vmt") )
	--surface.DrawText( "b" )
    surface.DrawTexturedRectUV( x+wide*0.2, y+tall*0.2, wide/1.5, tall/2, 0.5, 0.74, 1, 1 )
end
function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ ACT_STAND ] 						= ACT_STAND
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_SMG1

	self.ActivityTranslateAI [ ACT_MP_RUN ] 					= ACT_HL2MP_RUN_SMG1
	self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_WALK_CROUCH_SMG1

	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_SMG1
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 				= ACT_RANGE_ATTACK_SMG1_LOW

	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_SMG1

end
list.Add( "NPCUsableWeapons", { class = "weapon_smg2",	title = "Beta SMG2" }  )