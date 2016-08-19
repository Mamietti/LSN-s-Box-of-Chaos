SWEP.PrintName			= "Ice Axe"
SWEP.Author			= "Strafe"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/c_models/c_engineer_gunslinger.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "melee"
SWEP.FiresUnderwater = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.DamageBase = "sk_plr_dmg_crowbar"
SWEP.Primary.DamageMult = 1
SWEP.Primary.FireSound = "Weapon_Crowbar.Single"
SWEP.Primary.HitSound = "Weapon_Crowbar.Melee_Hit"
SWEP.Primary.FireRate = 0.14
SWEP.Primary.Distance = 64
SWEP.Primary.DamageType = DMG_CLUB

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
    local tr2 = util.TraceLine( {
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * self.Primary.Distance ),
        filter = self.Owner
    } )
    if tr2.Hit then
        self:EmitSound(self.Primary.HitSound)
        if tr2.HitNonWorld then
            if ( SERVER ) then
                self.Owner:TraceHullAttack( self.Owner:GetShootPos(), tr2.HitPos, Vector( -16, -16, -16 ), Vector( 36, 36, 36 ), GetConVarNumber( self.Primary.DamageBase ) * self.Primary.DamageMult, self.Primary.DamageType, 1, false );
            end
        end
        self:SendWeaponAnim(ACT_VM_HITCENTER)
        local efe = EffectData()
        local toot			= {};
        toot.Src			= self.Owner:GetShootPos();
        toot.Dir			= self.Owner:GetAimVector();
        toot.Num			= 1;
        toot.Damage			= 20;
        toot.Force			= 20;
        toot.Tracer			= 0;
        toot.Distance       = self.Primary.Distance
        toot.Callback		= function( attacker, tr, dmgtoot )
            return {
                damage		= false,
                effects		= true
            }
        end;
        self.Owner:FireBullets( toot )
    else
        self:SendWeaponAnim(ACT_VM_MISSLEFT)
    end
end

function SWEP:Suck()
    local bullet = {}
    bullet.Num 		= self.Primary.Number
    bullet.Src 		= self.Owner:GetShootPos()
    bullet.Dir 		= self.Owner:GetAimVector()
    bullet.Spread = Vector(self.Primary.Spread,self.Primary.Spread,0)
    bullet.Tracer	= 0
    bullet.Damage	= GetConVarNumber( self.Primary.DamageBase ) * self.Primary.DamageMult
    bullet.Force = self.Primary.Force
    bullet.Distance = self.Primary.Distance
    bullet.CallBack = function(attacker, trace, dmg)
        dmg:SetDamageType(self.Primary.DamageType)
    end
    self.Owner:FireBullets(bullet)
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