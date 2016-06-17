SWEP.PrintName			= "HECU Deagle"
SWEP.Author			= "Strafe"
SWEP.Instructions	= ""
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = "Sidearm for the most bastardous of gunslingers."
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/v_deagle.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_deagle.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "pistol"
SWEP.FiresUnderwater = false
SWEP.Dual = false
SWEP.ReloadSound = "Weapon_Eagle.Reload"
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 60

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip	= 7
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.DamageBase = "sk_plr_dmg_357"
SWEP.Primary.DamageMult = 1.075
SWEP.Primary.FireSound = "Weapon_Eagle.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.04
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 0.224
SWEP.Primary.Recoil = 1
SWEP.Primary.AccMult = 2
SWEP.Primary.AccThreshold = 7

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( color_transparent )
	surface.SetTextColor( 255, 220, 0, alpha )
	surface.SetFont( "CSKillIcons" )
	local w, h = surface.GetTextSize("b")

	surface.SetTextPos( x + ( wide / 2 ) - ( w / 2 ),
						y + ( tall / 2 ) - ( h / 2 ) )
	surface.DrawText( "b" )
end

list.Add( "NPCUsableWeapons", { class = "weapon_eagle",	title = "HECU Deagle" }  )