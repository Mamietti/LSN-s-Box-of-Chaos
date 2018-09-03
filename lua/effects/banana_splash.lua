
function EFFECT:Init( data )

	local vOffset = data:GetOrigin()

	sound.Play( "ui/hitsound_squasher.wav", vOffset, 70, math.random( 90, 120 ) )

	local NumParticles = 16

	local emitter = ParticleEmitter( vOffset, false )

	for i = 0, NumParticles do

		local Pos = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) )

		local particle = emitter:Add( "particles/balloon_bit", vOffset + Pos * 8 )
		if ( particle ) then

			particle:SetVelocity( Pos * 100 )

			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.5 )

			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
            
			particle:SetStartSize( 3 )
			particle:SetEndSize( 0 )

			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -2, 2 ) )

			particle:SetAirResistance( 100 )
			particle:SetGravity( Vector( 0, 0, -300 ) )

			particle:SetColor( 255, 255, 0 )

			particle:SetCollide( true )

			particle:SetAngleVelocity( Angle( math.Rand( -160, 160 ), math.Rand( -160, 160 ), math.Rand( -160, 160 ) ) )

			particle:SetBounce( 0 )
			particle:SetLighting( true )

		end

	end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
