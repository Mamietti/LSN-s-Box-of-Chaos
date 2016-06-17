function EFFECT:Init( data )
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Goal	= data:GetStart()
	self.DieTime = (CurTime()+0.1)
	local emitter = ParticleEmitter(self.Position)		
end

function EFFECT:Think( )

	if ( CurTime() > self.DieTime ) then return false end
	
	return true

end

function EFFECT:Render( )
	render.SetMaterial(Material("effects/spark"))
    self.Color=Color(255,255,255)
	render.DrawBeam( self.Position+(self.Goal-self.Position)*(1-10*(self.DieTime-CurTime()))*0.3, self.Position+(self.Goal-self.Position)*(1-10*(self.DieTime-CurTime())), 3, 1, 0, self.Color )
	render.SetMaterial(Material("effects/laser1"))
    self.Color=Color(255,255,255)
	render.DrawBeam( self.Position, self.Goal, 3, 1, 0, self.Color )
end

--VITTU KUN EI TOIMI