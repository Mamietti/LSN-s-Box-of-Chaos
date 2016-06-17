AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.PrintName		= "Risky Protect Potion"
ENT.Author			= "LSN5"
ENT.Information		= "May or may not contain an evil spirit."
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
		self:SetColor(Color(0,0,0,255))
	end
end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

function ENT:Use( activator, caller )
	if ( activator:IsPlayer() ) then
		
		local num = math.random(0,1)
		if num==0 then
			activator:SetHealth( 100 )
			activator:SetArmor( math.min( 100, activator:Armor() + 20 ) )
			self:EmitSound(Sound("misc/halloween/merasmus_appear.wav"))
			ParticleEffect("healthgained_red",self:GetPos(),Angle(0,0,0),nil)
		else
			local sound = math.random(0,2)
			activator:Ignite(6,0)
			ParticleEffect("halloween_player_death",self:GetPos(),Angle(0,0,0),nil)
			if sound == 0 then
				self:EmitSound(Sound("youmustdie.wav"),500,100)
			elseif sound == 1 then
				self:EmitSound(Sound("cortex_laugh.wav"),500,100)
			else
				self:EmitSound(Sound("itburns.wav"),500,100)
			end
		end
		
	end
	self:Remove()
end