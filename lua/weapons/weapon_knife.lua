SWEP.PrintName			= "Combat Knife"
SWEP.Author			= "Strafe"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Base = "weapon_hl2_base_melee"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 0
SWEP.SlotPos			= 5
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "melee2"
SWEP.FiresUnderwater = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Damage = 25
SWEP.Primary.FireSound = "Weapon_Knife.Miss"
SWEP.Primary.HitSound = "Weapon_Knife.Hit"
SWEP.Primary.HitWorldSound = "Weapon_Knife.HitWall"
SWEP.Primary.FireRate = 0.4
SWEP.Primary.Distance = 64
SWEP.Primary.DamageType = DMG_SLASH

SWEP.Primary.HitAnim = ACT_VM_PRIMARYATTACK
SWEP.Primary.MissAnim = ACT_VM_MISSCENTER

function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ ACT_STAND ] 						= ACT_STAND
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY
	self.ActivityTranslateAI [ ACT_MP_WALK ] 					= ACT_HL2MP_WALK_MELEE
	self.ActivityTranslateAI [ ACT_MP_RUN ] 					= ACT_HL2MP_RUN_MELEE
	self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_WALK_CROUCH_MELEE

	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_GESTURE_MELEE_ATTACK1

end