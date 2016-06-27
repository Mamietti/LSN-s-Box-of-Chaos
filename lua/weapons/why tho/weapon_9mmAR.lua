SWEP.PrintName			= "HECU SMG"
SWEP.Author			= "Strafe"
SWEP.Instructions	= "Standard issue SMG for HECU operatives."
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/v_mp51.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_mp51.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "smg"
SWEP.FiresUnderwater = false
SWEP.ReloadSound = "Weapon_9mmAR.Reload"
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 55

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9mmRound"
SWEP.Primary.DamageBase = "sk_plr_dmg_smg1"
SWEP.Primary.DamageMult = 1.25
SWEP.Primary.FireSound = "Weapon_9mmAR.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.02
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 0.075*1.3333

SWEP.EASY_DAMPEN = 0.5
SWEP.MAX_VERTICAL_KICK = 1
SWEP.SLIDE_LIMIT = 2
SWEP.KICK_MIN_X = 0.4
SWEP.KICK_MIN_Y = 0.4
SWEP.KICK_MIN_Z = 0.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "MP5_Grenade"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

if CLIENT then
	killicon.AddFont("weapon_9mmAR", "CSKillIcons", "b", Color(255, 100, 0, 255))
end
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( Color(255, 220, 0, 255) )
    surface.SetMaterial( Material("sprites/640hud4.vmt") )
	--surface.DrawText( "b" )
    surface.DrawTexturedRectUV( x, y+tall*0.2, wide, tall/2, 0, 0.53, 0.65, 0.7 )
end

function SWEP:SecondaryAttack()
    if self:Ammo2()>0 then
        self:SetNextPrimaryFire(CurTime() + 0.5)
        self:SetNextSecondaryFire(CurTime() + 1)
        self:ShootEffects(self)
        self:EmitSound("Weapon_SMG1.Double")
        if SERVER then
            local Forward = self.Owner:EyeAngles():Forward()
            local ent = ents.Create( "grenade_mp5" )
            if ( IsValid( ent ) ) then
            
                ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )
                ent:SetAngles( self.Owner:EyeAngles() )
                ent:Spawn()
                
                ent:SetVelocity( Forward * 1000 )
                ent:SetOwner( self.Owner )
                ent:SetModel("models/props_junk/popcan01a.mdl")
                ent:SetSaveValue("m_flDamage", GetConVarNumber("sk_plr_dmg_smg1_grenade")*0.5)
                ent:SetMoveType(MOVETYPE_FLYGRAVITY)
            end
        end
        self:TakeSecondaryAmmo(1)
        self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
        timer.Create( "weapon_idle" .. self:EntIndex(), self.Owner:GetViewModel():SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )
    else
        self:EmitSound("Weapon_IRifle.Empty")
        self:SetNextSecondaryFire(CurTime() + 0.5)
    end
end

list.Add( "NPCUsableWeapons", { class = "weapon_9mmAR",	title = "HECU SMG" }  )