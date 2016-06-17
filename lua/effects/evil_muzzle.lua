AddCSLuaFile()
function EFFECT:Init( data )
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
    self.Couleur = data:GetEntity():GetOwner():GetWeaponColor()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	local emitter = ParticleEmitter(self.Position)
		local Pos = (self.Position)
		local particle = emitter:Add("sprites/heatwave", Pos)
		if (particle) then
			particle:SetVelocity(data:GetEntity():GetOwner():GetVelocity())
			particle:SetLifeTime(0)
			particle:SetDieTime(0.1)
			particle:SetColor(255,255,255)					
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(10)
			particle:SetEndSize(30)
			particle:SetCollide(false)
		end
		local particle2 = emitter:Add("effects/electric1", Pos)
		if (particle2) then
            particle2:SetVelocity(data:GetEntity():GetOwner():GetVelocity())
			particle2:SetLifeTime(0)
			particle2:SetDieTime(0.1)
			particle2:SetColor(self.Couleur.x*255,self.Couleur.y*255,self.Couleur.z*255)					
			particle2:SetStartAlpha(255)
			particle2:SetEndAlpha(0)
			particle2:SetStartSize(5)
			particle2:SetEndSize(10)
            particle2:SetRoll(math.Rand(-360, 360))
            particle2:SetRollDelta(math.Rand(-0.21, 0.21))
			particle2:SetCollide(false)
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