SWEP.PrintName			= "Rocket Launcher"
SWEP.Author			= "Strafe"
SWEP.Category	= "TF2"
SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/v_models/v_rocketlauncher_soldier.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_models/w_rocketlauncher.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "rpg"
SWEP.FiresUnderwater = true

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= 34
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.NextReload = nil

function SWEP:DrawWorldModel()
	if not self.Owner:IsValid() then
		self:DrawModel()
	else
		local hand, offset, rotate
		hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))
		offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0 + hand.Ang:Up() * 0

		hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
		hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
		hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

		self:SetRenderOrigin(hand.Pos + offset)
		self:SetRenderAngles(hand.Ang)

		self:DrawModel()
	end
end
function SWEP:Reload()
	if self:Clip1()<4 and self:Ammo1()>0 and self.NextReload==nil and CurTime()>self:GetNextPrimaryFire() then
        self:SendWeaponAnim( ACT_RELOAD_START )
        self.NextReload = CurTime() + self:SequenceDuration()
        self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
	end
end

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if self:Clip1()>0 then
        self.NextReload = nil
        self:TakePrimaryAmmo(1)
        self:EmitSound("weapons/rocket_shoot.wav")
        self:ShootEffects(self)
        self:SetNextPrimaryFire(CurTime()+0.8)
        local Forward = self.Owner:EyeAngles():Forward()
        local Right = self.Owner:EyeAngles():Right()
        local Up = self.Owner:EyeAngles():Up()
        if SERVER then
            local ent = ents.Create( "tf2_projectile_rocket" )
            if ( IsValid( ent ) ) then
                ent:SetPos( self.Owner:GetShootPos() + Forward * 32 + Right * 5 - Up * 5 )
                ent:SetAngles( self.Owner:EyeAngles() )
                ent:Spawn()
                ent:GetPhysicsObject():ApplyForceCenter( Forward * 1100 )
                ent:SetOwner( self.Owner )
            end
        end
    else
        if self:Ammo1()>0 then
            self:Reload()
        else
            self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
        end
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
    if self.NextReload!=nil and CurTime()>=self.NextReload then
        if self:Clip1()<4 and self:Ammo1()>0 then
            self.Owner:RemoveAmmo(1,self.Primary.Ammo)
            self:SetClip1(self:Clip1()+1)
            self:SendWeaponAnim( ACT_VM_RELOAD )
            self.NextReload = CurTime() + self:SequenceDuration()
            self:SetNextPrimaryFire(CurTime() + self:SequenceDuration()*0.8)
        else
            self:SendWeaponAnim( ACT_RELOAD_FINISH )
            self.NextReload = CurTime() + self:SequenceDuration()
            self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
            self.NextReload = nil
        end
    end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DEPLOY)
    self:SetDeploySpeed( 1 )
    self.Weapon:SetNextPrimaryFire( CurTime() + self:SequenceDuration()*0.7 )   
    self.Weapon:SetNextSecondaryFire( CurTime() + self:SequenceDuration()*0.7 ) 
	return true
end
/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:Holster(wep)
	return true
end