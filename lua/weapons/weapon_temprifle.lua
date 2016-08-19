SWEP.PrintName			= "Accurized Placeholder"
SWEP.Author			= "Strafe"
SWEP.Instructions	= ""
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = "[WIP]FIXME"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/v_models/v_desert_rifle.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/w_models/weapons/w_desert_rifle.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "ar2"
SWEP.FiresUnderwater = false
SWEP.Dual = false
SWEP.ReloadSound = "Weapon_TEMP.Reload"
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 70

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.DamageBase = "sk_plr_dmg_ar2"
SWEP.Primary.DamageMult = 1
SWEP.Primary.FireSound = "Weapon_TEMP.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.03
SWEP.Primary.Tracer = ""
SWEP.Primary.FireRate = 0.07

SWEP.EASY_DAMPEN = 0.5
SWEP.MAX_VERTICAL_KICK = 8
SWEP.SLIDE_LIMIT = 20
SWEP.KICK_MIN_X = 0.8
SWEP.KICK_MIN_Y = 0.8
SWEP.KICK_MIN_Z = 0.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "SMG1_Grenade"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

sound.Add( {
	name = "Weapon_TEMP.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = 120,
	sound = "weapons/rescue_ranger_fire.wav"
} )
sound.Add( {
    name = "Weapon_TEMP.Reload",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 90,
    sound = "weapons/ar2/npc_ar2_reload.wav"
} )
sound.Add( {
    name = "Weapon_TEMP.Double",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_IDLE,
    pitch = 100,
    sound = "weapons/loose_cannon_shoot.wav"--"weapons/airstrike_fire_01.wav"
} )

function SWEP:CallBack(attacker, trace, dmginfo)
    local fax 		= EffectData()
    fax:SetEntity(self.Weapon)
    fax:SetStart(trace.HitPos)
    fax:SetOrigin(self.Owner:GetShootPos())
    fax:SetNormal(trace.HitNormal)
    fax:SetAttachment(3)
    util.Effect("evil_tracer",fax)
	local fx 		= EffectData()
	fx:SetEntity(self)
	fx:SetOrigin(self.Owner:GetShootPos())
	fx:SetNormal(self.Owner:GetAimVector())
	fx:SetAttachment(3)
	util.Effect("evil_muzzle",fx)
    dmginfo:SetDamageType(DMG_ENERGYBEAM)
end
function SWEP:SecondaryAttack()
    if self:Ammo2()>0 and self.Owner:WaterLevel()!=3 then
        self:SetNextPrimaryFire(CurTime() + 0.5)
        self:SetNextSecondaryFire(CurTime() + 1)
        self:ShootEffects(self)
        self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
        self:EmitSound("Weapon_TEMP.Double")
        local Forward = self.Owner:EyeAngles():Forward()
        local e = ents.Create("rpg_missile")
        e:SetPos(self.Owner:GetShootPos())
        e:SetAngles(self.Owner:EyeAngles())
        e:Spawn()
        e:SetOwner(self.Owner)
        e:SetVelocity(Forward*1500)
        e:SetSaveValue("m_flDamage", 100)
        e:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
        self:TakeSecondaryAmmo(1)
        self.Owner:ViewPunch(Angle(-5,1*math.Rand(-1,1),1*math.Rand(-1,1)) )
        timer.Create( "weapon_idle" .. self:EntIndex(), 0.5, 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )
    else
        self:EmitSound("Weapon_IRifle.Empty")
        self:SetNextSecondaryFire(CurTime() + 0.5)
    end
end
function SWEP:DrawWorldModel()
	if not self.Owner:IsValid() then
		self:DrawModel()
		return
	else
		local hand, offset, rotate
		hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))
		offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0.2 + hand.Ang:Up() * -0.7

		hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
		hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
		hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

		self:SetRenderOrigin(hand.Pos + offset)
		self:SetRenderAngles(hand.Ang)

		self:DrawModel()
	end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DEPLOY)
    self:EmitSound("weapons/draw_primary.wav")
    self:SetDeploySpeed( 1 )
    self.Weapon:SetNextPrimaryFire( CurTime() + self:SequenceDuration()*0.5 )   
    self.Weapon:SetNextSecondaryFire( CurTime() + self:SequenceDuration()*0.5 )
    self.NextIdle = CurTime() + self:SequenceDuration()  
	return true
end