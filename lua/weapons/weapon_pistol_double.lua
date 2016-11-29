SWEP.PrintName			= "Double Pistols"
SWEP.Author			= "Strafe"
SWEP.Instructions	= ""
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = ""
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/c_pistol_dual.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_pistol_dual.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "duel"
SWEP.FiresUnderwater = true
SWEP.ReloadSound = ""
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 60

SWEP.Primary.ClipSize		= 18*2
SWEP.Primary.DefaultClip	= 18*2
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Damage = 5
SWEP.Primary.FireSound = "Weapon_Pistol.Single"
SWEP.Primary.EmptySound = "Weapon_Pistol.Empty"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.04
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.TracerAmount = 3
SWEP.Primary.FireRate = 0.08

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Shot = true
if CLIENT then
	killicon.AddFont("weapon_spistol", "HL2HUDFONT", "z", Color(255, 100, 0, 255))
end
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( color_transparent )
	surface.SetTextColor( 255, 220, 0, alpha )
	surface.SetFont( "HL2HUDFONT" )
	local w, h = surface.GetTextSize("dd")

	surface.SetTextPos( x + ( wide / 2 ) - ( w / 2 ),
						y + ( tall / 2 ) - ( h / 2 ) )
	surface.DrawText( "dd" )
end

function SWEP:AddViewKick()
	--self.Owner:ViewPunchReset( 15 )
    local vecScratch = Angle(math.Rand( 0.25, 0.5 ),math.Rand( -0.6, 0.6 ),0)
	self.Owner:ViewPunch( vecScratch )
end
function SWEP:WithFire()
    local view = self.Owner:GetViewModel()
    if self.Shot then
        view:SetSequence( view:LookupSequence("fire_r") )
    else
        view:SetSequence( view:LookupSequence("fire_l") )
    end
    self.Shot = !self.Shot
end
function SWEP:GetTracerOrigin()
    local view = self.Owner:GetViewModel()
    if self.Shot then
        return view:GetAttachment( view:LookupAttachment("muzzle") ).Pos
    else
        return view:GetAttachment( view:LookupAttachment("muzzle1") ).Pos
    end
end
function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Shot" )
end