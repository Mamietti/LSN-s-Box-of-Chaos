AddCSLuaFile()
function EFFECT:Init( data )
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	self.Element = data:GetDamageType()
	self.Element = data:GetEntity().Element
	local emitter = ParticleEmitter(self.Position)
		local Pos = (self.Position)
		local particle = emitter:Add("sprites/heatwave", Pos)
		if (particle) then
			particle:SetVelocity(Vector(0,0,0)+self.WeaponEnt:GetOwner():GetVelocity())
			particle:SetLifeTime(0)
			particle:SetDieTime(0.1)
			---particle:SetColor(200,0,255)					
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(10)
			particle:SetEndSize(30)
			--particle:SetRoll(math.Rand(-360, 360))
			--particle:SetRollDelta(math.Rand(-0.21, 0.21))
			particle:SetAirResistance(0)
			particle:SetCollide(false)
		end
		for i=1,15 do
			local particle = emitter:Add("effects/wispy_smoke", Pos+2*VectorRand())
			if (particle) then
				particle:SetVelocity(Vector(0,0,0)+self.Forward*250 + 40*VectorRand() +self.WeaponEnt:GetOwner():GetVelocity())
				particle:SetLifeTime(0)
				particle:SetDieTime(0.1)
				local noes = self.Element
				particle:SetColor(255,100,0)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(200)
				particle:SetStartSize(7)
				particle:SetEndSize(1)
				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))
				particle:SetAirResistance(0)
				particle:SetCollide(false)
			end
		end
		for i=1,5 do
			local particle = emitter:Add("effects/spark", Pos+2*VectorRand())
			if (particle) then
				particle:SetVelocity((Vector(0,0,0)+self.Forward*500 + 100*VectorRand() +self.WeaponEnt:GetOwner():GetVelocity()))
				particle:SetLifeTime(0)
				particle:SetDieTime(0.1)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(0)
				particle:SetStartSize(1)
				particle:SetEndSize(0.1)
				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))
				particle:SetAirResistance(0)
				particle:SetCollide(false)
				local noes = self.Element
				particle:SetColor(255,200,0)
			end
		end
		
	emitter:Finish()
	self:Remove()	
end

function EFFECT:Think( )
	return true
end

function EFFECT:Render( )
end

--VITTU KUN EI TOIMI