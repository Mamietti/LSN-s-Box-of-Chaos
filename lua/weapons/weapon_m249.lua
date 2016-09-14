SWEP.PrintName			= "HECU M249 SAW"
SWEP.Author			= "Strafe"
SWEP.Instructions	= ""
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = "SAWry for suppressing you."
SWEP.Slot				= 3
SWEP.SlotPos			= 2
SWEP.ViewModel			= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"
SWEP.HoldType			= "ar2"
SWEP.FiresUnderwater = false
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 60
SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "HelicopterGun"
SWEP.Primary.Damage = 14
SWEP.Primary.FireSound = "Weapon_HMG1.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.07
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 0.07

SWEP.EASY_DAMPEN = 0.5
SWEP.MAX_VERTICAL_KICK = 2
SWEP.SLIDE_LIMIT = 1.5
SWEP.KICK_MIN_X = 0.8
SWEP.KICK_MIN_Y = 0.8
SWEP.KICK_MIN_Z = 0.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

if CLIENT then
	killicon.AddFont("weapon_m249", "CSKillIcons", "z", Color(255, 100, 0, 255))
end
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( color_transparent )
	surface.SetTextColor( 255, 220, 0, alpha )
	surface.SetFont( "CSKillIcons" )
	local w, h = surface.GetTextSize("z")

	surface.SetTextPos( x + ( wide / 2 ) - ( w / 2 ),
						y + ( tall / 2 ) - ( h / 2 ) )
	surface.DrawText( "z" )
end

function SWEP:WithFire()
    self.Owner:SetVelocity(self.Owner:GetAimVector()*-20)
end

list.Add( "NPCUsableWeapons", { class = "weapon_m249",	title = "HECU M249" }  )