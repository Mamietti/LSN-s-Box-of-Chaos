
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.PrintName		= ""
ENT.Author			= "ARNOLD YA-KNOW-WHO"
ENT.Information		= ""
ENT.Category		= ""

ENT.Editable			= false
ENT.Spawnable			= false
ENT.AdminOnly			= false
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT
ENT.Damage = 20
ENT.Anglor = 0
--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( SERVER ) then
		self:SetModel( "models/items/flare.mdl" )
		self:PhysicsInitSphere( 0.5, "brakingrubbertire" )
		self:SetCollisionBounds( Vector( -0.5, -0.5, -0.5 ), Vector( 0.5, 0.5, 0.5 ) )
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:SetColor(Color(0,0,0,0))
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(false)
			phys:EnableGravity(true)
			phys:SetBuoyancyRatio(0)
		end
		local ent = ents.Create( "env_flare" )
		ent:SetPos(self:GetPos())
		ent:SetParent(self)
		ent:Spawn()
		ent:Activate()
        self:EmitSound("Weapon_FlareGun.Burn")
	end
	--ParticleEffectAttach( "Rocket_Smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0 ) 
end

function ENT:OnRemove()
    self:StopSound("Weapon_FlareGun.Burn")
end

function ENT:PhysicsCollide( data, physobj )
	--ParticleEffect( "heavy_ring_of_fire_fp", self:GetPos(), self:GetAngles(), self )
    if !data.HitEntity:IsWorld() then
        self:EmitSound("PropaneTank.Burst")
        local damage = DamageInfo()
        damage:SetDamage(self.Damage)
        damage:SetAttacker(self.Owner)
        damage:SetInflictor(self)
        --damage:SetDamageType(DMG_CLUB)
        damage:SetDamagePosition(self:GetPos())
        damage:SetDamageForce(self:GetVelocity())
        data.HitEntity:TakeDamageInfo(damage)
        data.HitEntity:Ignite(5,0)
        self:Remove()
    else
        timer.Simple(10, function () if IsValid(self) then self:Remove() end end)
    end
end