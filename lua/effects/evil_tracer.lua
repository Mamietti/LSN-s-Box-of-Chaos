function EFFECT:Init( data )
	self.WeaponEnt = data:GetEntity()
	self.Element = data:GetDamageType()
	self.Attachment = data:GetAttachment()
    self.Couleur = data:GetEntity():GetOwner():GetWeaponColor()
    self.Origin = data:GetOrigin()
	
	self.Position = self:GetTracerShootPos(self.Origin, self.WeaponEnt, self.Attachment)
	self.Goal	= data:GetStart()
	self.DieTime = (CurTime()+0.1)
	local emitter = ParticleEmitter(self.Position)	
	local emitter2 = ParticleEmitter(self.Goal)
		for i = 0, 20 do
			local Pos = (self.Goal)
			local particle = emitter:Add("effects/spark", Pos)
			if (particle) then
				particle:SetVelocity(VectorRand() * 150)
				particle:SetLifeTime(0)
				particle:SetDieTime(1)
				particle:SetColor(self.Couleur.x*255,self.Couleur.y*255,self.Couleur.z*255)					
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(255)
				particle:SetStartSize(2)
				particle:SetEndSize(0.2)
				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))
				particle:SetAirResistance(0)
				particle:SetCollide(true)
                particle:SetGravity(Vector(0,0,-600))
			end
		end
	emitter2:Finish()	
end

function EFFECT:Think( )

	if ( CurTime() > self.DieTime ) then return false end
	
	return true

end

function EFFECT:Render( )
	--render.SetMaterial(Material("effects/spark"))
    --self.Color=Color(255,255,200)
	--render.DrawBeam( self.Position+(self.Goal-self.Position)*(1-10*(self.DieTime-CurTime()))*0.3, self.Position+(self.Goal-self.Position)*(1-10*(self.DieTime-CurTime())), 3, 1, 0, self.Color )
    render.SetMaterial(Material("effects/laser1"))
    self.Color=Color(self.Couleur.x*255,self.Couleur.y*255,self.Couleur.z*255)
    render.DrawBeam( self:GetTracerShootPos(self.Origin, self.WeaponEnt, self.Attachment), self.Goal, 5, 1, 0, self.Color )
end

--VITTU KUN EI TOIMI