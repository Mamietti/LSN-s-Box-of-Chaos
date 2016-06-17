SWEP.PrintName			= "HECU AR"
SWEP.Author			= "Strafe"
SWEP.Instructions	= ""
SWEP.Purpose = "Standard issue AR for HECU operatives."
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/c_m4.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_mrifle.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "ar2"
SWEP.FiresUnderwater = false
SWEP.Dual = false
SWEP.ReloadSound = ""
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 60

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.DamageBase = "sk_plr_dmg_ar2"
SWEP.Primary.DamageMult = 1
SWEP.Primary.FireSound = "Weapon_M4.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.03
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 0.075*1.3333
SWEP.Primary.Recoil = 0.8
SWEP.Primary.AccMult = 2
SWEP.Primary.AccThreshold = 7

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
    if self:Ammo2()>0 and self.Owner:WaterLevel()!=3 then
        self:SetNextPrimaryFire(CurTime() + 0.5)
        self:SetNextSecondaryFire(CurTime() + 1)
        self:ShootEffects(self)
        self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
        self:EmitSound("Weapon_SMG1.Double")
        local Forward = self.Owner:EyeAngles():Forward()
        local ent = ents.Create( "grenade_ar2" )
        if ( IsValid( ent ) ) then
        
            ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )
            ent:SetAngles( self.Owner:EyeAngles() )
            ent:Spawn()
            
            ent:SetVelocity( Forward * 1000 )
            ent:SetOwner( self.Owner )
            --ent:SetModel("models/props_junk/popcan01a.mdl")
            ent:SetSaveValue("m_flDamage", GetConVarNumber("sk_plr_dmg_smg1_grenade"))
            ent:SetMoveType(MOVETYPE_FLYGRAVITY)
        end
        self:TakeSecondaryAmmo(1)
        timer.Create( "weapon_idle" .. self:EntIndex(), 0.5, 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )
    else
        self:EmitSound("Weapon_IRifle.Empty")
        self:SetNextSecondaryFire(CurTime() + 0.5)
    end
end

list.Add( "NPCUsableWeapons", { class = "weapon_hecuar",	title = "HECU AR" }  )