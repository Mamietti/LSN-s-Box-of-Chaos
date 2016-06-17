SWEP.PrintName			= "Hive Hand"
SWEP.Author			= "Strafe"
SWEP.Instructions	= "NOT THE BEES"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= false
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/v_hgun.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/w_hgun.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "shotgun"
SWEP.FiresUnderwater = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Hornet"
SWEP.Primary.DamageBase = "sk_plr_dmg_smg1"
SWEP.Primary.DamageMult = 1
SWEP.Primary.FireSound = "Weapon_Hornetgun.Single"
SWEP.Primary.EmptySound = "Weapon_IRifle.Empty"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.1
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 0.25
SWEP.Primary.Recoil = 0.5
SWEP.Primary.AccMult = 2
SWEP.Primary.AccThreshold = 10

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.RecoilNow = 0
SWEP.ViewModelFOV = 100
/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
end

function SWEP:DrawWorldModel()
	if not self.Owner:IsValid() then
		self:DrawModel()
	else
		local hand, offset, rotate
		hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))
		offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 2 + hand.Ang:Up() * 0

		hand.Ang:RotateAroundAxis(hand.Ang:Right(), 20)
		hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
		hand.Ang:RotateAroundAxis(hand.Ang:Up(), 170)

		self:SetRenderOrigin(hand.Pos + offset)
		self:SetRenderAngles(hand.Ang)
        self:SetModelScale( 0.5, 0)

		self:DrawModel()
	end
end
function SWEP:Initialize()
	if ( SERVER ) then
		self:SetNPCMinBurst( 2 )
		self:SetNPCMaxBurst( 5 )
		self:SetNPCFireRate( self.Primary.Delay )
	end
	self:SetWeaponHoldType("shotgun")
end

--[[function SWEP:DrawWorldModel()
	if self.Dual then
		local lhand, LHandAT
		if !IsValid(self.Owner) then
			self:DrawModel()
			return
		end	
		if !LHandAT then
			LHandAT = self.Owner:LookupAttachment("anim_attachment_lh")
		end
		lhand = self.Owner:GetAttachment(LHandAT)		
		if !lhand then
			self:DrawModel()
			return
		end
		loffset = lhand.Ang:Right() * 1 + lhand.Ang:Forward() * 8 + lhand.Ang:Up() * 3
		lhand.Ang:RotateAroundAxis(lhand.Ang:Up(), 0)		
		self.LeftModel:SetRenderOrigin(lhand.Pos + loffset)
		self.LeftModel:SetRenderAngles(lhand.Ang)	
		self.LeftModel:DrawModel()
	end
	self:DrawModel()
end]]--

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() or self:Ammo1()>0 then
		if (!self.FiresUnderwater and self.Owner:WaterLevel()!=3) or self.FiresUnderwater then
			self:EmitSound( self.Primary.FireSound )
			self:SetNextPrimaryFire( CurTime() + self.Primary.FireRate)
            if !self.Owner:IsNPC() then
                self:TakePrimaryAmmo(1)
                self:ShootEffects(self)
            end
            local Forward = self.Owner:EyeAngles():Forward()
            local Right = self.Owner:EyeAngles():Right()
            local Up = self.Owner:EyeAngles():Up()
            local ent = ents.Create( "hornet" )
            if ( IsValid( ent ) ) then
                ent:SetPos( self.Owner:GetShootPos() + Forward * 32 + Right * 5 - Up * 5 )
                ent:SetAngles( self.Owner:EyeAngles() )
                ent:Spawn()
                ent:SetVelocity( Forward * 800 )
                ent:SetOwner( self.Owner )
                --PrintTable(ent:GetSaveTable())
                --ent:SetModel("models/gibs/antlion_gib_small_1.mdl")
                ent:SetSaveValue("m_iHornetType", 2)
                --ent:SetMoveType(MOVETYPE_FLYGRAVITY)
            end
            self.NextRegain = CurTime() + 1
            timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )
		end
	end
end

function SWEP:WithFire()

end
function SWEP:SecondaryAttack()
	self:SendWeaponAnim(ACT_VM_FIDGET)
    timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )
    self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
end

function SWEP:Think()
    if self.Owner:IsNPC() then return end
    if self:Ammo1()>8 then
        self.Owner:SetAmmo(8, "Hornet")
    end
    if self.NextRegain!=nil and CurTime()>=self.NextRegain and self:Clip1()<8 then
        self.Owner:SetAmmo(self:Ammo1()+1, "Hornet")
        self.NextRegain = CurTime() + 0.5
    end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DEPLOY)
    timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )
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
	timer.Stop( "weapon_idle" .. self:EntIndex() )
	return true
end

function SWEP:OnRemove()
	timer.Stop( "weapon_idle" .. self:EntIndex() )
end

function SWEP:OnDrop()
    self:Remove()
end

list.Add( "NPCUsableWeapons", { class = "weapon_hivehand",	title = "Hivehand" }  )

function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}
	if ( t == "shotgun" ) then
	self.ActivityTranslateAI [ ACT_IDLE ] 						= ACT_IDLE_SMG1
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_SHOTGUN
	self.ActivityTranslateAI [ ACT_IDLE_RELAXED ] 				= ACT_IDLE_SMG1_RELAXED
	self.ActivityTranslateAI [ ACT_IDLE_STIMULATED ] 			= ACT_IDLE_SMG1_STIMULATED
	self.ActivityTranslateAI [ ACT_IDLE_AGITATED ] 				= ACT_IDLE_ANGRY_SMG1

	self.ActivityTranslateAI [ ACT_RUN ] 					= ACT_RUN_AIM_SHOTGUN
	self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_WALK_CROUCH_SHOTGUN

	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_SHOTGUN
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 			= ACT_RANGE_ATTACK_SHOTGUN_LOW
	
	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_SHOTGUN
	return end	
end