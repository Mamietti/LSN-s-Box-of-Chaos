SWEP.PrintName			= "Ice Axe"
SWEP.Author			= "Strafe"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands			= false
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/v_gra_grove_b.mdl"
SWEP.WorldModel			= "models/weapons/W_gra_glove.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "fist"
SWEP.FiresUnderwater = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Damage = 15
SWEP.Primary.FireSound = "Weapon_StunStick.Swing"
SWEP.Primary.HitSound = "NPC_RollerMine.Shock"
SWEP.Primary.HitWorldSound = "Weapon_StunStick.Melee_HitWorld"
SWEP.Primary.FireRate = 1
SWEP.Primary.Distance = 64
SWEP.Primary.DamageType = bit.bor(DMG_PHYSGUN)

SWEP.NPCMinBurst = 3
SWEP.NPCMaxBurst = 3
SWEP.NPCMinRest = 0
SWEP.NPCMaxRest = 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

AccessorFunc( SWEP, "fNPCMinBurst",                 "NPCMinBurst" )
AccessorFunc( SWEP, "fNPCMaxBurst",                 "NPCMaxBurst" )
AccessorFunc( SWEP, "fNPCFireRate",                 "NPCFireRate" )
AccessorFunc( SWEP, "fNPCMinRestTime",         "NPCMinRest" )
AccessorFunc( SWEP, "fNPCMaxRestTime",         "NPCMaxRest" )
/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/

function SWEP:Initialize()
    self:SetNPCMinBurst( self.NPCMinBurst )
    self:SetNPCMaxBurst( self.NPCMaxBurst )
    self:SetNPCFireRate( self.Primary.FireRate )
    self:SetNPCMinRest( self.NPCMinRest )
    self:SetNPCMaxRest( self.NPCMaxRest )
    if self.Owner:IsNPC() and SERVER then
        if self.Owner:GetClass()=="npc_combine_s" then
            hook.Add( "Think", self, function()
                if IsValid(self.Owner) and self.Owner:IsNPC() then
                    if self.Owner:GetEnemy() and self.Owner:GetActivity() == 11 and CurTime()>=self:GetNextPrimaryFire() then
                        self.Owner:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_PERFECT )
                        self:PrimaryAttack()
                    end
                end
            end)
        end
    end
    self:SetHoldType(self.HoldType)
    self.FireStart = nil
end

function SWEP:PrimaryAttack()
    self:EmitSound(self.Primary.FireSound)
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self:SetNextPrimaryFire(CurTime()+self.Primary.FireRate)
    ---local ent = self.Owner:TraceHullAttack( self.Owner:GetShootPos(), self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.Primary.Distance ), Vector( -16, -16, -16 ), Vector( 36, 36, 36 ), self.Primary.Damage, self.Primary.DamageType, 1, false );
    --if IsValid(ent) then
        --self:EmitSound(self.Primary.HitSound)
        --ent:SetVelocity(Vector(0,0,200))
    --end
    local tracedata = {}
    tracedata.start   = self.Owner:GetShootPos()
    tracedata.endpos  = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.Primary.Distance )
    tracedata.filter  = self.Owner
    tracedata.mask    = MASK_SOLID
    tracedata.mins    = Vector( -16, -16, -18 ) -- head_hull_mins
    tracedata.maxs    = Vector( 16, 16, 18 ) -- head_hull_maxs
    local tr = util.TraceHull(tracedata)
    if tr.Hit and IsValid(tr.Entity) then
        self:EmitSound(self.Primary.HitSound)
        local damage = DamageInfo()
        damage:SetDamage(self.Primary.Damage)
        damage:SetAttacker(self.Owner)
        damage:SetInflictor(self)
        damage:SetDamageType(self.Primary.DamageType)
        damage:SetDamagePosition(self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.Primary.Distance ))
        damage:SetDamageForce(Vector(0,0,200) + Angle(0,self.Owner:EyeAngles().y,0):Forward()*1000)
        tr.Entity:TakeDamageInfo(damage)
        tr.Entity:SetVelocity(Vector(0,0,200) + Angle(0,self.Owner:EyeAngles().y,0):Forward()*1000)
        tr.Entity:SetSchedule(SCHED_FLINCH_PHYSICS)
    elseif tr.HitWorld then
        tr = util.TraceLine(tracedata)
        self:EmitSound(self.Primary.HitWorldSound)
        util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
    end
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
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
    self.Weapon:SetNextPrimaryFire( CurTime() + self:SequenceDuration()*0.7 )   
    self.Weapon:SetNextSecondaryFire( CurTime() + self:SequenceDuration()*0.7 )
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
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_SMG1

	self.ActivityTranslateAI [ ACT_MP_RUN ] 					= ACT_HL2MP_RUN_SMG1
	self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_WALK_CROUCH_SMG1

	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_SMG1
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 				= ACT_RANGE_ATTACK_SMG1_LOW

	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_SMG1

end