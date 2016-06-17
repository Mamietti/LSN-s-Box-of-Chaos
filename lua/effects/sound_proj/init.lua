function EFFECT:Init( data )
	self.Ent = data:GetEntity().Owner
	local emitter = ParticleEmitter(data:GetOrigin())
		local Pos = (data:GetOrigin())
		local particle = emitter:Add("effects/circle3_str", Pos)
		if (particle) then
			particle:SetVelocity(Vector(0,0,0))
			particle:SetLifeTime(0)
			particle:SetDieTime(0.2)
			local color = self.Ent:GetWeaponColor()
			particle:SetColor(color.x*255,color.y*255,color.z*255)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(7)
			particle:SetEndSize(0.2)
			particle:SetAirResistance(0)
			particle:SetCollide(false)
		end
		local particle = emitter:Add("effects/strider_pinch_dudv", Pos)
		if (particle) then
			particle:SetVelocity(Vector(0,0,0))
			particle:SetLifeTime(0)
			particle:SetDieTime(0.2)
			particle:SetColor(200,0,255)					
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(10)
			particle:SetEndSize(5)
			particle:SetRoll(math.Rand(-360, 360))
			particle:SetRollDelta(math.Rand(-0.21, 0.21))
			particle:SetAirResistance(0)
			particle:SetCollide(false)
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