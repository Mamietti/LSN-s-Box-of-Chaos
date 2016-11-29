SWEP.PrintName			= "ASDCombat Knife"
SWEP.Author			= "Strafe"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= false
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

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
    self.FireStart = nil
end

function SWEP:PrimaryAttack()
    self:EmitSound(self.Primary.FireSound)
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self:SetNextPrimaryFire(CurTime()+self.Primary.FireRate)
    local tracedata = {}
    tracedata.start   = self.Owner:GetShootPos()
    tracedata.endpos  = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.Primary.Distance )
    tracedata.filter  = self.Owner
    tracedata.mask    = MASK_SOLID
    tracedata.mins    = Vector( -4, -4, -4 )
    tracedata.maxs    = Vector( 4, 4, 4 )
    local tr = util.TraceHull(tracedata)
    if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsNPC() and tr.Entity:GetOwner()!=self.Owner then
        local damage = DamageInfo()
        damage:SetDamage(self.Primary.Damage)
        damage:SetAttacker(self.Owner)
        damage:SetInflictor(self)
        damage:SetDamageType(self.Primary.DamageType)
        damage:SetDamagePosition(self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.Primary.Distance ))
        damage:SetDamageForce(self.Owner:EyeAngles():Forward()*1000)
        tr.Entity:DispatchTraceAttack( damage, tr, self.Owner:GetAimVector() )--:TakeDamageInfo(damage)
        self:EmitSound(self.Primary.HitSound)
        self:SendWeaponAnim(self.Primary.HitAnim)
    else
        tr = util.TraceLine(tracedata)
        if tr.Hit then
            self:SendWeaponAnim(self.Primary.HitAnim)
            if tr.HitWorld then
                self:EmitSound(self.Primary.HitWorldSound)
                local effectdata2 = EffectData()
                effectdata2:SetOrigin( tr.HitPos-tr.HitNormal)
                effectdata2:SetStart( tr.HitPos)
                effectdata2:SetAngles( tr.HitNormal:Angle())
                effectdata2:SetNormal(tr.HitNormal )
                effectdata2:SetSurfaceProp( tr.SurfaceProps )
                effectdata2:SetDamageType(self.Primary.DamageType)
                util.Effect( "Impact", effectdata2, false, true)
            elseif IsValid(tr.Entity) and tr.Entity:GetOwner()!=self.Owner then
                local damage = DamageInfo()
                damage:SetDamage(self.Primary.Damage)
                damage:SetAttacker(self.Owner)
                damage:SetInflictor(self)
                damage:SetDamageType(self.Primary.DamageType)
                damage:SetDamagePosition(tr.HitPos)
                damage:SetDamageForce(self.Owner:EyeAngles():Forward()*1000)
                tr.Entity:DispatchTraceAttack( damage, tr, self.Owner:GetAimVector() )--:TakeDamageInfo(damage)
                self:EmitSound(self.Primary.HitSound)
            end
        else
            self:SendWeaponAnim(self.Primary.MissAnim)
        end
    end
    self.NextIdle = CurTime() + self:SequenceDuration()
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
    if self.NextIdle!=nil and CurTime()>=self.NextIdle then
        self:SendWeaponAnim( ACT_VM_IDLE )
        self.NextIdle=nil
    end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DEPLOY)
    self:SetDeploySpeed( 1 )
    self.Weapon:SetNextPrimaryFire( CurTime() + self:SequenceDuration()*1 )   
    self.Weapon:SetNextSecondaryFire( CurTime() + self:SequenceDuration()*1 )
    self.NextIdle = CurTime() + self:SequenceDuration()  
	return true
end
/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Holster(wep)
	return true
end

function SWEP:OnRemove()
end

function SWEP:GetCapabilities()

	return bit.bor( CAP_WEAPON_MELEE_ATTACK1, CAP_INNATE_MELEE_ATTACK1)

end

function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ ACT_STAND ] 						= ACT_STAND
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY
	self.ActivityTranslateAI [ ACT_MP_WALK ] 					= ACT_HL2MP_WALK_MELEE
	self.ActivityTranslateAI [ ACT_MP_RUN ] 					= ACT_HL2MP_RUN_MELEE
	self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_WALK_CROUCH_MELEE

	self.ActivityTranslateAI [ ACT_GESTURE_MELEE_ATTACK1 ] 				= ACT_GESTURE_MELEE_ATTACK1

end