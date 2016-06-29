AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.PrintName		= "Realism Potion"
ENT.Author			= "LSN5"
ENT.Information		= "Activate to not go fast."
ENT.Category		= "Fun + Games"

ENT.Editable			= false
ENT.Spawnable			= true
ENT.AdminOnly			= false
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	
	local ent = ents.Create( ClassName )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:Initialize()
	if ( SERVER ) then
		self:SetModel( "models/props_halloween/flask_erlenmeyer.mdl" )
		self:PhysicsInitBox( Vector(-3,-3,-6), Vector(1,1,1) )
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	else
		self:SetColor(Color(95,127,63,255))
	end
end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

function ENT:Use( activator, caller )
	if ( activator:IsPlayer() ) then
		self:EmitSound(Sound("misc/halloween/merasmus_appear.wav"))
		activator:SetRunSpeed(200)
		activator:SetWalkSpeed(90)
		activator:SetCrouchedWalkSpeed( 0.70) 
        activator:SetArmor
	end
	self:Remove()
end