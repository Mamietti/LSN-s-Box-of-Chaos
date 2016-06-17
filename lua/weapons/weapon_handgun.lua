SWEP.PrintName			= "Mesa 9mm Pistol"
SWEP.Author			= "Strafe"
SWEP.Instructions	= "Another day in the Mesa"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/v_glock1.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_glock1.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "pistol"
SWEP.FiresUnderwater = true
SWEP.ReloadSound = "Weapon_Handgun.Reload"
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 60

SWEP.Primary.ClipSize		= 18
SWEP.Primary.DefaultClip	= 18
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "9mmRound"
SWEP.Primary.DamageBase = "sk_plr_dmg_pistol"
SWEP.Primary.DamageMult = 8/5
SWEP.Primary.FireSound = "Weapon_Handgun.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.02
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 0.2
SWEP.Primary.Recoil = 0.8
SWEP.Primary.AccMult = 1
SWEP.Primary.AccThreshold = 7

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
if CLIENT then
	killicon.AddFont("weapon_handgun", "CSKillIcons", "c", Color(255, 100, 0, 255))
end
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( Color(255, 220, 0, 255) )
    surface.SetMaterial( Material("sprites/640hud4.vmt") )
	--surface.DrawText( "b" )
    surface.DrawTexturedRectUV( x+wide*0.1, y, wide/1.5, tall/1.5, 0.3, 0.13, 0.65, 0.35 )
end

list.Add( "NPCUsableWeapons", { class = "weapon_handgun",	title = "Mesa 9mm Pistol" }  )