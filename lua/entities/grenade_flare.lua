
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "FLARE"
ENT.Author = "Strafe"
ENT.Information = "An edible bouncy ball"
ENT.Category = "Fun + Games"

ENT.Editable = true
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.MinSize = 4
ENT.MaxSize = 128

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/weapons/flare.mdl" )
		self:SetSolid( SOLID_BBOX )
		self:AddSolidFlags( FSOLID_NOT_STANDABLE )
		self:SetMoveType(MOVETYPE_FLYGRAVITY)
		self:SetSaveValue("m_bSmoke", true)
		self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
		self:SetFriction( 0.6 )
		self:SetGravity( 1 )
	end
	--self:EmitSound("Weapon_FlareGun.Burn")
	self.Sound = CreateSound(self,"Weapon_FlareGun.Burn")
	self.Sound:Play()
	self.m_flTimeBurnOut = CurTime() + 30
	self:AddFlags(FL_OBJECT)
	self:NextThink(CurTime() + 0.5)
end

function ENT:Think()
	if SERVER then
		if CurTime() > self.m_flTimeBurnOut then
			self.Sound:Stop()
			self:Remove()
		end
	end
	if self:WaterLevel()>1 then
	else
		if math.random(0,8)==1 then
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetStart( self:GetPos() )
			util.Effect( "Sparks", effectdata )
		end
	end
	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:Draw()

	local emitter = ParticleEmitter( self:GetPos(), true )

	local Pos = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) )
	local particle = emitter:Add( "particles/balloon_bit", self:GetPos() + Pos * 8 )
	if ( particle ) then

		particle:SetVelocity( Pos * 500 )

		particle:SetLifeTime( 0 )
		particle:SetDieTime( 10 )

		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )

		local Size = math.Rand( 1, 3 )
		particle:SetStartSize( Size )
		particle:SetEndSize( 0 )

		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -2, 2 ) )

		particle:SetAirResistance( 100 )
		particle:SetGravity( Vector( 0, 0, -300 ) )

		local RandDarkness = math.Rand( 0.8, 1.0 )
		particle:SetColor( 255 * RandDarkness, 255 * RandDarkness, 255 * RandDarkness )

		particle:SetCollide( true )

		particle:SetAngleVelocity( Angle( math.Rand( -160, 160 ), math.Rand( -160, 160 ), math.Rand( -160, 160 ) ) )

		particle:SetBounce( 1 )
		particle:SetLighting( true )

	end

	emitter:Finish()
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.pos = self:GetPos()
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.brightness = 2
		dlight.Decay = 1000
		dlight.Size = 256
		dlight.DieTime = CurTime() + 1
	end
	
	self:DrawModel()qw
end

function ENT:Touch(ent)
	if IsValid(ent) then
		if !ent:IsSolid() then
			return
		end
	end
end
