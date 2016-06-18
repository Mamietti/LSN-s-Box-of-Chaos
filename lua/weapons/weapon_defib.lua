AddCSLuaFile()

SWEP.PrintName				= "Defibrillator"
SWEP.Author					= "Medic"
SWEP.Purpose			= "Revive the fallen"

SWEP.Slot					= 5
SWEP.SlotPos				= 3

SWEP.Spawnable				= true

SWEP.ViewModel				= Model( "models/v_models/v_defibrillator.mdl" )
SWEP.WorldModel				= Model( "models/w_models/weapons/w_eq_defibrillator_paddles.mdl" )
SWEP.ViewModelFOV			= 54
SWEP.UseHands				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HealAmount				= 20	-- Maximum heal amount per use
SWEP.MaxAmmo				= 100	-- Maxumum ammo

local DenySound = Sound( "WallHealth.Deny" )

function SWEP:Initialize()

	self:SetHoldType( "duel" )

end

function SWEP:PrimaryAttack()
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 80,
		filter = self.Owner
	} )
	if tr.Hit then
		local ent = tr.Entity
		if ent:GetOwner()!=nil then
            if ent.GunTable!=nil then
                sound.Play("weapons/neon_sign_hit_0"..math.random(1,4)..".wav", ent:GetPos())
                if CurTime() - ent.DeathTime < 30 then
                    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
                    self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 0.5 )
                    self.Owner:SetAnimation( PLAYER_ATTACK1 )
                    local victim = ent:GetOwner()
                    victim:Spawn()
                    victim:SetHealth(victim:GetMaxHealth()*0.25)
                    victim:SetPos(ent:GetPos())
                    for k,v in pairs(ent.GunTable) do
                        victim:Give(v)
                    end
                    for k,v in pairs(ent.AmmoTable) do
                        victim:SetAmmo( v, k )
                    end
                    if tostring(victim:GetModel())=="models/player/us_00004.mdl" or tostring(victim:GetModel())=="models/player/mw3rangers/us_ranger_02.mdl" or tostring(victim:GetModel())=="models/steinman/bf4/us_04.mdl" then
                        victim:SetRunSpeed(200)
                        victim:SetWalkSpeed(90)
                        victim:SetCrouchedWalkSpeed( 0.70)
                    end
                else
                    self.Owner:ChatPrint("It is too late!")
                    self:EmitSound(DenySound)
                end
            elseif ent:GetClass()=="prop_ragdoll" and ent.OriClass!=nil then
                sound.Play("weapons/neon_sign_hit_0"..math.random(1,4)..".wav", ent:GetPos())
                local ant = ents.Create( ent.OriClass )
                if ( IsValid( ant ) ) then
                    ant:SetPos( ent:GetPos() )
                    ant:Spawn()
                    ant:SetModel(ent:GetModel())
                    ant:SetSkin(ent:GetSkin())
                    ant:SetHealth(ant:GetMaxHealth()*0.25)
                    ent:Remove()
                end
            end
		end
	end
end

function SWEP:OnRemove()

	timer.Stop( "weapon_idle" .. self:EntIndex() )

end

function SWEP:Holster()

	timer.Stop( "weapon_idle" .. self:EntIndex() )
	
	return true

end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DEPLOY )
	self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration())
    return true
end

function SWEP:DrawWorldModel()
	if not self.Owner:IsValid() then
		self:DrawModel()
		return
	else
		local hand, offset, rotate
        if self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh")) then
            hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))
            offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * -1.5 + hand.Ang:Up() * -13
            hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
            hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
            hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

            self:SetRenderOrigin(hand.Pos + offset)
            self:SetRenderAngles(hand.Ang)
        end
		self:DrawModel()
	end
end

function Defibdeath( victim, weapon, killer )
	local raggy = victim:GetRagdollEntity()
	raggy:SetOwner(victim)
	raggy.GunTable = victim:GetWeapons()
	raggy.AmmoTable = {}
	for k,v in pairs(raggy.GunTable) do
		local ammot = v:GetPrimaryAmmoType()
		if raggy.AmmoTable[ammot]==nil then
			raggy.AmmoTable[ammot] = victim:GetAmmoCount(ammot)
		end
		local ammot2 = v:GetSecondaryAmmoType()
		if raggy.AmmoTable[ammot2]==nil then
			raggy.AmmoTable[ammot2] = victim:GetAmmoCount(ammot2)
		end
	end
	for k,v in pairs(raggy.GunTable) do
		raggy.GunTable[k] = v:GetClass()
	end
    raggy.DeathTime = CurTime()
end
hook.Add( "PlayerDeath", "DefibDeath", Defibdeath )

local AcceptedClasses = {CLASS_NONE,CLASS_PLAYER_ALLY,CLASS_PLAYER_ALLY_VITAL,CLASS_CITIZEN_PASSIVE,CLASS_CITIZEN_REBEL}
hook.Add( "CreateEntityRagdoll", "NPCDefibDeath", function(owner, rag)
    if owner:IsNPC() and owner:Classify()!=nil and table.HasValue( AcceptedClasses, owner:Classify() ) then
        rag.OriClass = owner:GetClass()
    end
end)
