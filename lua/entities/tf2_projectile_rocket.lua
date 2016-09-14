
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.PrintName		= "NIGGER"
ENT.Author			= "ARNOLD YA-KNOW-WHO"
ENT.Information		= "SUCK MY DICK"
ENT.Category		= "FUCKS I GIVE"

ENT.Editable			= false
ENT.Spawnable			= false
ENT.AdminOnly			= false
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT
--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( SERVER ) then
		self:SetModel( "models/weapons/w_models/w_rocket.mdl" )
		self:PhysicsInitSphere( 0.5, "brakingrubbertire" )
		self:SetCollisionBounds( Vector( -0.5, -0.5, -0.5 ), Vector( 0.5, 0.5, 0.5 ) )
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:SetBuoyancyRatio(0)
		end
        local ent = ents.Create( "info_particle_system" )
        ent:SetPos(self:GetPos()-self:GetAngles():Forward()*30)
        ent:SetAngles(self:GetAngles())
        ent:SetParent(self)
        ent:SetKeyValue( "effect_name", "rockettrail" )
        ent:SetKeyValue( "start_active", "1" )
        ent:Spawn()
        ent:Activate()
	end
end

function ENT:PhysicsCollide( data, physobj )
    self:EmitSound("BaseExplosionEffect.Sound")
    util.BlastDamage( self, self.Owner, self:GetPos(), 146, 60 )
    local ent = ents.Create( "info_particle_system" )
    ent:SetPos(self:GetPos())
    ent:SetAngles(self:GetAngles())
    ent:SetKeyValue( "effect_name", "ExplosionCore_MidAir" )
    ent:SetKeyValue( "start_active", "1" )
    ent:Spawn()
    ent:Activate()
    ent:Fire("kill", 0.1 , 0.1)
    self:Remove()
end