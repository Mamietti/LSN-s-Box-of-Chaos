SWEP.PrintName			= "Test SMG"
SWEP.Author			= "Strafe"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.ViewModelFlip = true
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "smg"
SWEP.FiresUnderwater = false
SWEP.Dual = false
SWEP.ReloadSound = "Weapon_SMG1.Reload"

SWEP.Primary.ClipSize		= 90
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.DamageBase = "sk_plr_dmg_smg1"
SWEP.Primary.DamageMult = 1
SWEP.Primary.FireSound = "Weapon_SMG1.Single"
SWEP.Primary.EmptySound = "Weapon_IRifle.Empty"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.1
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.TracerAmount = 3
SWEP.Primary.FireRate = 0.07
SWEP.Primary.AmmoTake = 1

SWEP.EASY_DAMPEN = 0.5
SWEP.MAX_VERTICAL_KICK = 8.0
SWEP.SLIDE_LIMIT = 5.0
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
    if self:Clip1()<0 then return end
    timer.Stop( "weapon_idle" .. self:EntIndex() )
    self.FireStart	= nil
	if self:DefaultReload(ACT_VM_RELOAD) then
		self:EmitSound(self.ReloadSound)
        self.NextIdle = CurTime() + self:SequenceDuration()
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
end

function SWEP:PrimaryAttack()
	--if ( !self:CanPrimaryAttack() ) then return end
	if (self:Clip1()<0 and (self.Owner:IsNPC() or self:Ammo1()>=self.Primary.AmmoTake)) or self:Clip1()>=self.Primary.AmmoTake then
		if (!self.FiresUnderwater and self.Owner:WaterLevel()!=3) or self.FiresUnderwater then
            self:HandleFunc()
            self:WithFire()
        else
            self.Weapon:EmitSound( self.Primary.EmptySound )
            self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
		end
        if self.Owner:IsNPC() and self.Primary.Automatic then
            if !timer.Exists(tostring(self.Owner:EntIndex())) then
                timer.Create( tostring(self.Owner:EntIndex()), self.Primary.FireRate, 3, function() 
                    if IsValid(self) and IsValid(self.Owner) and self:Clip1()>0 and self.Owner:GetEnemy() then
                        self:PrimaryAttack()
                    end
                end )
            end
        end
    else
        if self:Clip1()!=(-1) then
            if self.Owner:IsNPC() then
                self.Owner:SetSchedule(SCHED_RELOAD)
            elseif self:Ammo1()>0 then
                self:Reload()
            end
        else
            self.Weapon:EmitSound( self.Primary.EmptySound )
            self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
        end
	end
end

function SWEP:HandleFunc()
    self:EmitSound( self.Primary.FireSound )
    if !self.Owner:IsNPC() then
        --self.Owner:ViewPunch(Angle(math.Rand(-self.Primary.Recoil,self.Primary.Recoil)*,math.Rand(-self.Primary.Recoil,self.Primary.Recoil),0))
        self:ShootEffects(self)
        if self.FireStart == nil then
            self.FireStart	= CurTime()
        elseif self.Owner:GetViewModel():SelectWeightedSequence( ACT_VM_RECOIL1 ) then
            self:SendWeaponAnim( ACT_VM_RECOIL1 )
        end
        self:AddViewKick()
        self.NextIdle = CurTime() + self:SequenceDuration()
    end
    self:FireRound()
    self:SetNextPrimaryFire( CurTime() + self.Primary.FireRate)
end

function SWEP:FireRound()
    local bullet = {}
    bullet.Num 		= self.Primary.Number
    bullet.Src 		= self.Owner:GetShootPos()
    bullet.Dir 		= self.Owner:GetAimVector()
    bullet.Spread = Vector(self.Primary.Spread,self.Primary.Spread,0)
    bullet.Tracer	= self.Primary.TracerAmount
    bullet.TracerName = self.Primary.Tracer
    bullet.Damage	= GetConVarNumber( self.Primary.DamageBase ) * self.Primary.DamageMult
    bullet.Force = self.Primary.Force
    bullet.Callback = self:CallBack(attacker, trace, dmginfo)
    self.Owner:FireBullets(bullet)
    self:TakePrimaryAmmo(1)
end

function SWEP:CallBack(attacker, trace, dmginfo)
end

function SWEP:AddViewKick()
	--Find how far into our accuracy degradation we are
	local duration	= math.min(CurTime()-self.FireStart, self.SLIDE_LIMIT)
	local kickPerc = duration / self.SLIDE_LIMIT

	-- do this to get a hard discontinuity, clear out anything under 10 degrees punch
	self.Owner:ViewPunchReset( 15 )
    local vecScratch = Angle(0,0,0)
	--Apply this to the view angles as well
	vecScratch.x = -( self.KICK_MIN_X + ( self.MAX_VERTICAL_KICK * kickPerc ) )
	vecScratch.y = -( self.KICK_MIN_Y + ( self.MAX_VERTICAL_KICK * kickPerc ) ) / 3
	vecScratch.z = self.KICK_MIN_Z + ( self.MAX_VERTICAL_KICK * kickPerc ) / 8

	--Wibble left and right
    vecScratch.y = vecScratch.y*math.random( -1, 1 )
	--Wobble up and down
    vecScratch.z = vecScratch.y*math.random( -1, 1 )
	--Clip this to our desired min/max
	--UTIL_ClipPunchAngleOffset( vecScratch, pPlayer->m_Local.m_vecPunchAngle, QAngle( 24.0f, 3.0f, 1.0f ) );
	--Add it to the view punch
	-- NOTE: 0.5 is just tuned to match the old effect before the punch became simulated
	self.Owner:ViewPunch( vecScratch * 0.5 )
end

function SWEP:WithFire()

end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
	if !self.Owner:KeyDown( IN_ATTACK ) then
		self.FireStart	= nil
	end
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

	return bit.bor( CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1 )

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