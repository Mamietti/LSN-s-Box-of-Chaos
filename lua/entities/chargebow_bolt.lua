
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
ENT.Col = nil
--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( SERVER ) then
		self:SetModel( "models/weapons/chagebow_bolt.mdl" )
		self:PhysicsInit(MOVETYPE_VPHYSICS)
		self:SetMoveType(MOVETYPE_FLYGRAVITY)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		--self:SetRenderMode(RENDERMODE_TRANSALPHA)

        local trail = util.SpriteTrail(self, 0, Color(self.Col.x*255,self.Col.y*255,self.Col.z*255), false, 6, 0.1, 0.2, 1/(3)*0.5, "effects/laser1.vmt")
	end
end
function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Damage" )
end
function ENT:Think()
    self:SetAngles(self:GetVelocity():Angle())
end
function ENT:Touch( ent )
    if ent:Health() then
        local damage = DamageInfo()
        damage:SetDamage(self:GetDamage())
        damage:SetAttacker(self.Owner)
        damage:SetInflictor(self)
        damage:SetDamageType(DMG_DISSOLVE)
        damage:SetDamagePosition(self:GetPos())
        damage:SetDamageForce(self:GetVelocity())
        ent:TakeDamageInfo(damage)
    end
    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetStart(self:GetPos())
    effectdata:SetMagnitude(3)
    effectdata:SetRadius(1)
    effectdata:SetScale(1)
    util.Effect( "StunstickImpact", effectdata )
    self:EmitSound("Weapon_Crossbow.BoltElectrify")
    self:Remove()
end