SWEP.PrintName			= "Hand Minigun"
SWEP.Author			= "Strafe"
SWEP.Instructions	= ""
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= false
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/workshop/weapons/c_frearm/c_dex_arm/c_dex_arm.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/workshop/weapons/c_frearm/c_dex_arm/c_dex_arm.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "shotgun"
SWEP.FiresUnderwater = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 300
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.DamageBase = "sk_plr_dmg_smg1"
SWEP.Primary.DamageMult = 1
SWEP.Primary.FireSound = "NPC_Antlion.PoisonShoot"
SWEP.Primary.EmptySound = "Weapon_IRifle.Empty"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.1
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 0.1
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
    return false
end
function SWEP:GetViewModelPosition( pos, ang )
	ang = ang*1
	pos = self.Owner:GetShootPos() + ang:Forward()*0 + ang:Right()*9.445 + ang:Up()*-40-- + ang:Forward()*21.295 + ang:Right()*9.445 + ang:Up()*-15.742
	return pos, ang
end

function SWEP:DrawWorldModel()
	if not self.Owner:IsValid() then
		self:DrawModel()
	else
		local hand, offset, rotate
		hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))
		offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * -3 + hand.Ang:Up() * -10

		hand.Ang:RotateAroundAxis(hand.Ang:Right(), 20)
		hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
		hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

		self:SetRenderOrigin(hand.Pos + offset)
		self:SetRenderAngles(hand.Ang)
        self:SetModelScale( 0.5, 0)

		self:DrawModel()
	end
end

function SWEP:PrimaryAttack()
	if self.Owner:IsNPC() or self:Ammo1()>1 then
		if (!self.FiresUnderwater and self.Owner:WaterLevel()!=3) or self.FiresUnderwater then
			self:EmitSound( self.Primary.FireSound )
			self:SetNextPrimaryFire( CurTime() + self.Primary.FireRate)
            if !self.Owner:IsNPC() then
                self:TakePrimaryAmmo(2)
                self:ShootEffects(self)
                self:SendWeaponAnim( ACT_RANGE_ATTACK1 ) 
            end
            local bullet = {}
            bullet.Num 		= self.Primary.Number
            bullet.Src 		= self.Owner:GetShootPos()
            bullet.Dir 		= self.Owner:GetAimVector()
            bullet.Spread = Vector(self.Primary.Spread,self.Primary.Spread,0)
            bullet.Tracer	= self.Primary.TracerAmount
            bullet.TracerName = self.Primary.Tracer
            bullet.Damage	= GetConVarNumber( self.Primary.DamageBase ) * self.Primary.DamageMult
            bullet.Force = self.Primary.Force
            self.Owner:FireBullets(bullet)
            self:TakePrimaryAmmo(1)
		end
	end
end

function SWEP:Initialize()
	if ( SERVER ) then
		self:SetNPCMinBurst( 2 )
		self:SetNPCMaxBurst( 5 )
		self:SetNPCFireRate( self.Primary.Delay )
	end
	self:SetWeaponHoldType("pistol")
end

function SWEP:Deploy()
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

list.Add( "NPCUsableWeapons", { class = "weapon_workerhead",	title = "Worker Head" }  )

function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}
	if ( t == "shotgun" ) then
	self.ActivityTranslateAI [ ACT_IDLE ] 						= ACT_IDLE
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_PISTOL
	self.ActivityTranslateAI [ ACT_IDLE_RELAXED ] 				= ACT_IDLE_PISTOL_RELAXED
	self.ActivityTranslateAI [ ACT_IDLE_STIMULATED ] 			= ACT_IDLE_PISTOL_STIMULATED
	self.ActivityTranslateAI [ ACT_IDLE_AGITATED ] 				= ACT_IDLE_ANGRY_PISTOL

	self.ActivityTranslateAI [ ACT_RUN ] 					= ACT_RUN_AIM_PISTOL
	self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_WALK_CROUCH_PISTOL

	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 			= ACT_RANGE_ATTACK_PISTOL_LOW
	
	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_PISTOL
	return end	
end