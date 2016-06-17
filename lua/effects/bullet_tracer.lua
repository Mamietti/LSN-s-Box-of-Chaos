function EFFECT:Init( data )
	self.WeaponEnt = data:GetEntity()
	self.Element = data:GetDamageType()
	self.Attachment = data:GetAttachment()
    self.Couleur = data:GetEntity():GetOwner():GetWeaponColor()
	
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
    self.Color=Color(self.Couleur.x*255,self.Couleur.y*255,self.Couleur.z*255)
	render.DrawBeam( self.Position+(self.Goal-self.Position)*(1-10*(self.DieTime-CurTime()))*0.3, self.Position+(self.Goal-self.Position)*(1-10*(self.DieTime-CurTime())), 3, 1, 0, self.Color )
end

--VITTU KUN EI TOIMI