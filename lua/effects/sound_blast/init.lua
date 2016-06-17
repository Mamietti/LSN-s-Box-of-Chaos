function EFFECT:Init( data )
	local emitter = ParticleEmitter(data:GetOrigin())
		for i = 0, 400 do
			local Pos = (data:GetOrigin()+Vector(0,0,32))
			local particle = emitter:Add("effects/strider_pinch_dudv", Pos)
			if (particle) then
				particle:SetVelocity(Vector(math.Rand(-1,1),math.Rand(-1,1),0):GetNormalized()*600)
				particle:SetLifeTime(0)
				particle:SetDieTime(0.5)
				particle:SetColor(100,0,255)	-- TÄÄ TÄS ON HOMO PASKA				
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(255)
				particle:SetStartSize(30)
				particle:SetEndSize(20)
				--particle:SetRoll(math.Rand(-360, 360))
				--particle:SetRollDelta(math.Rand(-0.21, 0.21))
				particle:SetAirResistance(20)
				particle:SetCollide(false)
			end
			local particle = emitter:Add("effects/softglow", Pos)
			if (particle) then
				particle:SetVelocity(Vector(math.Rand(-1,1),math.Rand(-1,1),0):GetNormalized()*600)
				particle:SetLifeTime(0)
				particle:SetDieTime(0.5)
				particle:SetColor(100,0,255)	-- TÄÄ TÄS ON HOMO PASKA				
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(255)
				particle:SetStartSize(15)
				particle:SetEndSize(5)
				--particle:SetRoll(math.Rand(-360, 360))
				--particle:SetRollDelta(math.Rand(-0.21, 0.21))
				particle:SetAirResistance(20)
				particle:SetCollide(false)
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