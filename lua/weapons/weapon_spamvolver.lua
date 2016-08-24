SWEP.PrintName			= "Spam Revolver"
SWEP.Author			= "Strafe"
SWEP.Instructions	= "Another day in the Mesa"
SWEP.Category	= "Lazy Swep-ensteins"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/c_357.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_357.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "revolver"
SWEP.FiresUnderwater = true
SWEP.ReloadSound = ""
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 60

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.DamageBase = "sk_plr_dmg_pistol"
SWEP.Primary.DamageMult = 3
SWEP.Primary.FireSound = "weapons/loch_n_load_shoot.wav"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.02
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 1/10
SWEP.Primary.Recoil = 0.8

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

function SWEP:CallBack(attacker, trace, dmginfo)
    local types = {
        DMG_BLAST,
        DMG_BURN,
        DMG_ACID,
        DMG_DISSOLVE
    }
    local damage = DamageInfo()
    damage:SetDamage(15)
    damage:SetAttacker(self.Owner)
    damage:SetInflictor(self)
    damage:SetDamageType(types[math.random( 1, #types )])
    damage:SetDamagePosition(self:GetPos())
    damage:SetDamageForce(self:GetVelocity())
    util.BlastDamageInfo( damage, trace.HitPos, 50)
    if SERVER then
        if trace.Entity:IsNPC() then
            trace.Entity:SetSchedule(SCHED_NPC_FREEZE) --SCHED_NPC_FREEZE
            trace.Entity:SetCondition(COND_NPC_FREEZE)
            trace.Entity:SetMaterial("models/player/shared/ice_player.vmt")
        end
    end
end

function SWEP:DoImpactEffect( tr, nDamageType )

	if ( tr.HitSky ) then return end

	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
	effectdata:SetNormal( tr.HitNormal )
	util.Effect( "StunstickImpact", effectdata )

end
