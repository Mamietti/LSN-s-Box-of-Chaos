SWEP.PrintName			= "Beta AR1"
SWEP.Author			= "Strafe"
SWEP.Instructions	= "Glory to Motherland!"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = "For those moments you are not Russian enough."
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/c_ar1.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_ar1.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "ar2"
SWEP.FiresUnderwater = false
SWEP.Dual = false
SWEP.ReloadSound = ""
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 50

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.DamageBase = "sk_plr_dmg_smg1"
SWEP.Primary.DamageMult = 1.5
SWEP.Primary.FireSound = "Weapon_AR1.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.04
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 0.075*1.5
SWEP.Primary.Recoil = 0.8
SWEP.Primary.AccMult = 2
SWEP.Primary.AccThreshold = 7

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

if CLIENT then
	killicon.AddFont("weapon_ar1", "CSKillIcons", "b", Color(255, 100, 0, 255))
end
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( color_transparent )
	surface.SetTextColor( 255, 220, 0, alpha )
	surface.SetFont( "CSKillIcons" )
	local w, h = surface.GetTextSize("b")

	surface.SetTextPos( x + ( wide / 2 ) - ( w / 2 ),
						y + ( tall / 2 ) - ( h / 2 ) )
	surface.DrawText( "b" )
end

list.Add( "NPCUsableWeapons", { class = "weapon_ar1",	title = "Beta Ar1" }  )