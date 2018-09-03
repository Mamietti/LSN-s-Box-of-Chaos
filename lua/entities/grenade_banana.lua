
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = ""
ENT.Author = ""
ENT.Information = ""
ENT.Category = ""

ENT.Editable = false
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT 

local FLARE_DECAY_TIME = 3

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/weapons/w_models/w_drg_ball.mdl" )
        self:SetColor(Color(255,255,0,255))
		self:SetSolid( SOLID_BBOX )
		self:AddSolidFlags( FSOLID_NOT_STANDABLE )
		self:SetMoveType(MOVETYPE_FLYGRAVITY)
		self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
        self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE )
		self:SetFriction( 0.6 )
		self:SetGravity( 1 )
	end
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Touch(ent)
    if ent:IsNPC() then
        ent:TakeDamage(10,self.Owner,self)
    end
    local effectdata = EffectData()
    effectdata:SetOrigin( self:GetPos() )
    util.Effect( "banana_splash", effectdata )
    self:Remove()
end