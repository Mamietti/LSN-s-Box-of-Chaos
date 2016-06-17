SWEP.PrintName			= "beta Incendiary Rifle"
SWEP.Author			= "Strafe"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = "Turn up the heat."
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/v_mg1.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_mg1.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "smg"
SWEP.FiresUnderwater = false
SWEP.Dual = false
SWEP.ReloadSound = ""
SWEP.Base = "weapon_hl2_base_strafe"

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Buckshot"
SWEP.Primary.DamageBase = "sk_plr_dmg_buckshot"
SWEP.Primary.DamageMult = 3
SWEP.Primary.Force = 2
SWEP.Primary.FireSound = "Weapon_IRifle.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.04*0.75
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.TracerAmount = 1
SWEP.Primary.FireRate = 1

SWEP.EASY_DAMPEN = 0.5
SWEP.MAX_VERTICAL_KICK = 1
SWEP.SLIDE_LIMIT = 2
SWEP.KICK_MIN_X = 0.2
SWEP.KICK_MIN_Y = 0.2
SWEP.KICK_MIN_Z = 0.1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( Color(255, 220, 0, 255) )
    surface.SetMaterial( Material("sprites/w_icons1b.vmt") )
	--surface.DrawText( "b" )
    surface.DrawTexturedRectUV( x+wide*0.2, y+tall*0.2, wide/1.5, tall/2, 0.5, 0.74, 1, 1 )
end
function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ ACT_STAND ] 						= ACT_STAND
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_SMG1

	self.ActivityTranslateAI [ ACT_MP_RUN ] 					= ACT_HL2MP_RUN_SMG1
	self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_WALK_CROUCH_SMG1

	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_SMG1
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 				= ACT_RANGE_ATTACK_SMG1_LOW

	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_SMG1

end

function SWEP:FireRound()
    local ent = ents.Create( "ent_flareround" )
    if ( IsValid( ent ) ) then
        local Forward = self.Owner:EyeAngles():Forward()    
        ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )
        ent:SetAngles( self.Owner:EyeAngles() )
        ent:Spawn()
        ent.Damage = GetConVarNumber( self.Primary.DamageBase ) * self.Primary.DamageMult
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter( Forward * 2000 )
        ent:SetOwner( self.Owner )
    end
    self:TakePrimaryAmmo(1)
end