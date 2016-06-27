SWEP.PrintName			= "Beta AR1"
SWEP.Author			= "Strafe"
SWEP.Instructions	= "Glory to Motherland!"
SWEP.Category	= "Half-Life 2"
SWEP.Spawnable			= false
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "ar2"
SWEP.FiresUnderwater = false

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Damage     = 5
SWEP.Primary.FireSound = "Weapon_AR1.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.04
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 0.07*1.5

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
	draw.SimpleText( "b", "CSKillIcons", x + wide/2, y + tall*0.2, Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER )
end
sound.Add( {
	name = "Weapon_AR1.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = 100,
	sound = {"weapons/ar1/ar1_fire1.wav","weapons/ar1/ar1_fire2.wav"}--,"weapons/ar1/ar1_fire3.wav"}
} )
function SWEP:Reload(anim)
	self:SetClip1(30)
    self:SetNextPrimaryFire(CurTime() + 3)
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
    self:SetNextPrimaryFire(CurTime())
end

function SWEP:PrimaryAttack()
    if SERVER then
        if self:Clip1()>0 then
            if (!self.FiresUnderwater and self.Owner:WaterLevel()!=3) or self.FiresUnderwater then
                self:EmitSound( self.Primary.FireSound )
                self:SetNextPrimaryFire( CurTime() + self.Primary.FireRate)
                local bullet = {}
                bullet.Num 		= self.Primary.Number
                bullet.Src 		= self.Owner:GetShootPos()
                bullet.Dir 		= self.Owner:GetAimVector()
                bullet.Spread = Vector(self.Primary.Spread,self.Primary.Spread,0)
                bullet.Tracer	= 1
                bullet.TracerName = self.Primary.Tracer
                bullet.Force	= 10
                bullet.Damage	= self.Primary.Damage
                self:FireBullets(bullet)
                self:TakePrimaryAmmo(1)
            end
        end
    end
end

function SWEP:SecondaryAttack()
	return false
end