SWEP.PrintName			= "Test SMG"
SWEP.Author			= "Strafe"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= false
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "smg"
SWEP.FiresUnderwater = false
SWEP.ReloadSound = ""

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Damage = 5
SWEP.Primary.FireSound = "Weapon_SMG1.Single"
SWEP.Primary.NPCFireSound = nil
SWEP.Primary.EmptySound = "Weapon_IRifle.Empty"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.05
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.TracerAmount = 3
SWEP.Primary.FireRate = 0.07
SWEP.Primary.AmmoTake = 1

SWEP.Primary.CoolDownTime = nil

SWEP.EASY_DAMPEN = 0.5
SWEP.MAX_VERTICAL_KICK = 8
SWEP.SLIDE_LIMIT = 4
SWEP.KICK_MIN_X = 0.2
SWEP.KICK_MIN_Y = 0.2
SWEP.KICK_MIN_Z = 0.1

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

function SWEP:Reload()
    if self.Owner:IsNPC() then
        self.Owner:SetSchedule(SCHED_RELOAD)
    else
        if self:DefaultReload(ACT_VM_RELOAD) then
            self.FireStart	= nil
            self.CoolOff = nil
            self:EmitSound(self.ReloadSound)
            self.NextIdle = CurTime() + self:SequenceDuration()
        end
    end
end

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
    self.CoolDown = CurTime()
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		if self.FiresUnderwater or self.Owner:WaterLevel()!=3 then
            local acc = self.Primary.Spread
            if !self.Owner:IsNPC() then
                self:EmitSound( self.Primary.FireSound )
                self:ShootEffects(self)
                if CurTime()>=self.CoolDown then
                    self.FireStart	= CurTime()
                else
                    acc = self:HandleRecoil()
                end
                self:AddViewKick()
                self.CoolDown = CurTime() + (self.Primary.CoolDownTime or self.Primary.FireRate+0.01)
                self.NextIdle = CurTime() + self:SequenceDuration()
            else
                self:EmitSound( self.Primary.NPCFireSound or self.Primary.FireSound )
            end
            self:FireRound(acc)
            self:SetNextPrimaryFire( CurTime() + self.Primary.FireRate)
            self:WithFire()
        else
            self.Weapon:EmitSound( self.Primary.EmptySound )
            self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
		end
        if self.Owner:IsNPC() and self.Primary.Automatic then
            if !timer.Exists(tostring(self.Owner:EntIndex())) then
                timer.Create( tostring(self.Owner:EntIndex()), self.Primary.FireRate, 3, function() 
                    if IsValid(self) and IsValid(self.Owner) and self.Owner:GetEnemy() then
                        self:PrimaryAttack()
                    end
                end )
            end
        end
	end
end

function SWEP:HandleRecoil()
    if self.Primary.Automatic and self.Owner:GetViewModel():SelectWeightedSequence( ACT_VM_RECOIL1 ) then
        self:SendWeaponAnim( ACT_VM_RECOIL1 )
    end
    return self.Primary.Spread
end

function SWEP:CanPrimaryAttack()
	if ( self.Weapon:Clip1() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return false

	end
    if self.Owner:IsNPC() and CurTime()<self:GetNextPrimaryFire() then
        return false
    end

	return true

end

function SWEP:WithFire()
end

function SWEP:FireRound(acc)
    local bullet = {}
    bullet.Num 		= self.Primary.Number
    bullet.Src 		= self.Owner:GetShootPos()
    bullet.Dir 		= self.Owner:GetAimVector()
    bullet.Spread = Vector(acc,acc,0)
    bullet.Tracer	= self.Primary.TracerAmount
    bullet.TracerName = self.Primary.Tracer
    bullet.Damage	= self.Primary.Damage
    bullet.Force = self.Primary.Force
    bullet.Callback = function(attacker, trace, dmginfo)
        self:CallBack(attacker, trace, dmginfo)
    end
    self.Owner:FireBullets(bullet)
    self:TakePrimaryAmmo(self.Primary.AmmoTake)
end

function SWEP:CallBack(attacker, trace, dmginfo)
end

function SWEP:AddViewKick()
	local duration	= math.min(CurTime()-self.FireStart, self.SLIDE_LIMIT)
	local kickPerc = duration / self.SLIDE_LIMIT
	self.Owner:ViewPunchReset( 15 )
    local vecScratch = Angle(0,0,0)
	vecScratch.x = -( self.KICK_MIN_X + ( self.MAX_VERTICAL_KICK * kickPerc ) )
	vecScratch.y = -( self.KICK_MIN_Y + ( self.MAX_VERTICAL_KICK * kickPerc ) ) / 3*math.random( -1, 1 )
	vecScratch.z = self.KICK_MIN_Z + ( self.MAX_VERTICAL_KICK * kickPerc ) / 8*math.random( -1, 1 )
	--UTIL_ClipPunchAngleOffset( vecScratch, pPlayer->m_Local.m_vecPunchAngle, QAngle( 24.0f, 3.0f, 1.0f ) );
	self.Owner:ViewPunch( vecScratch * 0.5 )
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
    self:SetDeploySpeed( 1 )
	self:SendWeaponAnim(ACT_VM_DEPLOY)
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

	return bit.bor( CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1 )

end

function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ ACT_STAND ] 						= ACT_STAND
	self.ActivityTranslateAI [ ACT_IDLE ] 						= ACT_IDLE_SMG1
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_SMG1
	self.ActivityTranslateAI [ ACT_IDLE_RELAXED ] 				= ACT_IDLE_SMG1_RELAXED
	self.ActivityTranslateAI [ ACT_IDLE_STIMULATED ] 			= ACT_IDLE_SMG1_STIMULATED
	self.ActivityTranslateAI [ ACT_IDLE_AGITATED ] 				= ACT_IDLE_ANGRY_SMG1

	self.ActivityTranslateAI [ ACT_MP_RUN ] 					= ACT_HL2MP_RUN_SMG1
	self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_WALK_CROUCH_SMG1

	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_SMG1
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 				= ACT_RANGE_ATTACK_SMG1_LOW

	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_SMG1

end