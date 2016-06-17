function EFFECT:Init( data )
	local emitter = ParticleEmitter(data:GetOrigin())
		for i = 0, 40 do
			local Pos = (data:GetOrigin())
			local particle = emitter:Add("effects/spark", Pos)
			if (particle) then
				particle:SetVelocity(VectorRand() * 150)
				particle:SetLifeTime(0)
				particle:SetDieTime(0.4)
				local vec = data:GetEntity():GetWeaponColor()
				particle:SetColor(vec.x*255,vec.y*255,vec.z*255)					
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(255)
				particle:SetStartSize(3)
				particle:SetEndSize(0.2)
				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))
				particle:SetAirResistance(0)
				particle:SetCollide(false)
			end
		end
	emitter:Finish()	
end

function EFFECT:Think( )
	return true
end

function EFFECT:Render( )
end