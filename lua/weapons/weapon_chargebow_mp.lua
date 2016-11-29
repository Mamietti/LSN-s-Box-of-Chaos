SWEP.PrintName			= "Charge Bow"
SWEP.Author			= "Strafe"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.ViewModel			= "models/weapons/c_chargebow.mdl"
SWEP.WorldModel			= "models/weapons/w_chargebow.mdl"
SWEP.HoldType			= "revolver"
SWEP.FiresUnderwater = false

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
    self.FireStart	= nil
    self.NextIdle = CurTime() + self:SequenceDuration()
    self.TargetIdle = self:GetSequenceActivity( self:LookupSequence( "idle01" ))
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    if self.FireStart==nil then
        self:SendWeaponAnim( self:GetSequenceActivity( self:LookupSequence( "Idle01_to_idle02" ) ) )
        self.FullSpeed = CurTime() + self:SequenceDuration()
        self.NextIdle = CurTime() + self:SequenceDuration()
        self.TargetIdle = self:GetSequenceActivity( self:LookupSequence( "idle02" ))
        self:EmitSound("Weapon_Chargebow.ChargeStart")
    end
end

function SWEP:Think()
	if self.FullSpeed!=nil and !self.Owner:KeyDown( IN_ATTACK ) then
		self:EmitSound("Weapon_Crossbow.Single")
        self:ShootEffects(self)
        self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
        self.Weapon:SetNextPrimaryFire( CurTime() + self:SequenceDuration())
        self.NextIdle = CurTime() + self:SequenceDuration()
        self.TargetIdle = self:GetSequenceActivity( self:LookupSequence( "idle01" ))
        if SERVER then
            local Forward = self.Owner:EyeAngles():Forward()
            local ent = ents.Create( "chargebow_bolt" )
            if ( IsValid( ent ) ) then
                ent:SetPos( self.Owner:GetShootPos() )
                ent:SetAngles( self.Owner:EyeAngles() )
                local col = self.Owner:GetWeaponColor()
                ent.Col = col
                ent:Spawn()
                if CurTime()>=self.FullSpeed then
                    ent:SetVelocity( Forward * 4000 )
                else
                    ent:SetVelocity( Forward * 1000 )
                end
                ent:SetDamage(20 + math.min(math.max(CurTime()-self.FullSpeed,0),1)*30)
                ent:SetOwner( self.Owner )
            end
        end
        self.FullSpeed = nil
        self:TakePrimaryAmmo(1)
	end
    if self:Clip1()==0 and self:Ammo1()>0 and CurTime()>=self.Weapon:GetNextPrimaryFire() + 0.01 then
        self:Reload()
    end
    if self.NextIdle!=nil and CurTime()>=self.NextIdle then
        self:SendWeaponAnim( self.TargetIdle )
        self.NextIdle=nil
    end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DEPLOY)
    self:SetDeploySpeed( 1 )
    self.Weapon:SetNextPrimaryFire( CurTime() + self:SequenceDuration()*0.7 )   
    self.NextIdle = CurTime() + self:SequenceDuration()
    self.TargetIdle = self:GetSequenceActivity( self:LookupSequence( "idle01" ))
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
    self.FullSpeed = nil
    self.FireStart = nil
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