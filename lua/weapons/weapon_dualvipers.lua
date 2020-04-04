AddCSLuaFile()

SWEP.PrintName = "Dual Vipers"
SWEP.Author = "Strafe"
SWEP.Purpose = "Kill"

SWEP.Slot = 1
SWEP.SlotPos = 9

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_pistol.mdl" )
SWEP.ViewModel1 = Model( "models/weapons/c_pistol.mdl" )
SWEP.ViewModelFlip = true
SWEP.WorldModel = Model( "models/weapons/w_pistol.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = true
SWEP.AdminOnly = false

SWEP.Base = "weapon_base"

local ShootSound = "Weapon_M4A1.Silenced"
local owner = nil
local starttime = 0
local endtime = 0

function SWEP:Initialize()
    self:SetNWBool("left", true)
    self:SetWeaponHoldType("duel")
end

function SWEP:Deploy()

	local viewmodel1 = self.Owner:GetViewModel( 1 )
	if ( IsValid( viewmodel1 ) ) then
		viewmodel1:SetWeaponModel( self.ViewModel , self )
	end
	
	self:SendViewModelAnim( ACT_VM_DEPLOY , 1 )
	
	return true
end

function SWEP:Holster()
	local viewmodel1 = self.Owner:GetViewModel( 1 )
	if ( IsValid( viewmodel1 ) ) then
		viewmodel1:SetWeaponModel( self.ViewModel , nil )
	end
	
	return true
end

function SWEP:CanPrimaryAttack()

	if ( self:Ammo1() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		return false

	end

	return true

end

function SWEP:PrimaryAttack()

	if ( !self:CanPrimaryAttack() ) then return end

	self:EmitSound( ShootSound )
	self:ShootBullet( 10, 1, 0.03, self.Primary.Ammo, 0, 1 )
	self:TakePrimaryAmmo( 1 )
    self:SetNextPrimaryFire(CurTime() + 0.1)
    self:SetNWBool("left", !self:GetNWBool("left"))
end

function SWEP:ShootEffects()
    if self:GetNWBool("left") then
        self:SendViewModelAnim( ACT_VM_PRIMARYATTACK , 0 )
    else
        self:SendViewModelAnim( ACT_VM_PRIMARYATTACK , 1 )
    end
    self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:SendViewModelAnim( act , index , rate )
	
	if ( not game.SinglePlayer() and not IsFirstTimePredicted() ) then
		return
	end
	
	local vm = self.Owner:GetViewModel( index )
	
	if ( not IsValid( vm ) ) then
		return
	end
	
	local seq = vm:SelectWeightedSequence( act )
	
	if ( seq == -1 ) then
		return
	end
	
	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( rate or 1 )
end

function SWEP:CalcViewModelView(ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng)
    if self.Owner:GetVelocity():Length() > self.Owner:GetMaxSpeed() * self.Owner:GetCrouchedWalkSpeed() * 1.1 and (!self.Owner:KeyDown(IN_ATTACK) or self:Ammo1()==0) then
        endtime = CurTime()
        return OldEyePos + Vector(0, 0, math.sin((CurTime() - starttime)*8)), OldEyeAng
    else
        if CurTime() - endtime < 0.5 then
            return OldEyePos + Vector(0, 0, math.sin((CurTime() - starttime)*8))*(1 - 2*(CurTime() - endtime)), OldEyeAng
        else
            starttime = CurTime()
        end
        return OldEyePos, OldEyeAng
    end
end

function SWEP:GetTracerOrigin()
    if !self:GetNWBool("left") then
        local vm = self.Owner:GetViewModel(1)
        local obj = vm:LookupAttachment( "muzzle" )
        return vm:GetAttachment( obj ).Pos
    end
end

function SWEP:ShootBullet( damage, num_bullets, aimcone, ammo_type, force, tracer )

    local eyeang = self.Owner:EyeAngles()
    local shootpos = nil
    if self:GetNWBool("left") then
        shootpos = (self.Owner:EyePos() - eyeang:Right()*4)
    else
        shootpos = (self.Owner:EyePos() + eyeang:Right()*4)
    end
    shootpos = shootpos - eyeang:Up()*2 + eyeang:Forward()*10

    local dir = (self.Owner:GetEyeTrace().HitPos - shootpos):GetNormalized()

    local ent = ents.Create("crossbow_bolt_hl1")
    ent:SetOwner(self.Owner)
    ent:SetPos(shootpos)
    ent:SetAngles(dir:Angle())
    ent:Spawn()
   
    ent:SetVelocity(dir*3000)

	self:ShootEffects()

end
