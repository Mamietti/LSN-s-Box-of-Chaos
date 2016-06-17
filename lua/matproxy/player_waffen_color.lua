
matproxy.Add(
{
	name	=	"PlayerWaffenColor",

	init	=	function( self, mat, values )

		self.ResultTo = values.resultvar

	end,

	bind	=	function( self, mat, ent )

		if ( !IsValid( ent ) ) then return end

		local owner = ent:GetOwner();
		if ( !IsValid( owner ) or !owner:IsPlayer() ) then return end

		local col = owner:GetPlayerColor();
		if ( !isvector( col ) ) then return end

		mat:SetVector( self.ResultTo, col );

	end
})
