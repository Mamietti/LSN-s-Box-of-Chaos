SWEP.PrintName			= "HECU Sniper Rifle"
SWEP.Author			= "Strafe"
SWEP.Instructions	= ""
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = "Abusive long distance relationship."
SWEP.Slot				= 3
SWEP.SlotPos			= 2
SWEP.ViewModel			= "models/weapons/c_m40a1.mdl"
SWEP.WorldModel			= "models/weapons/w_m40a1.mdl"
SWEP.HoldType			= "ar2"
SWEP.FiresUnderwater = false
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 50
SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "SniperRound"
SWEP.Primary.Damage = 100
SWEP.Primary.FireSound = "Weapon_Sniper.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 2

SWEP.EASY_DAMPEN = 0.5
SWEP.MAX_VERTICAL_KICK = 2
SWEP.SLIDE_LIMIT = 1.5
SWEP.KICK_MIN_X = 0.8
SWEP.KICK_MIN_Y = 0.8
SWEP.KICK_MIN_Z = 0.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

function SWEP:WithFire()
    if self.Owner:IsNPC() then return end
    if self:Clip1()>0 then
        self.NextPull = CurTime() + 1
    end
    self.Owner:SetEyeAngles(self.Owner:EyeAngles()+Angle(1-2*math.random( 0, 1 ),1-2*math.random( 0, 1 ),0))
end

function SWEP:Reload()
    if self.Owner:IsNPC() then
        self.Owner:SetSchedule(SCHED_RELOAD)
    else
        self.Owner:SetFOV( 0, 0.3 )
        if self:Clip1()==0 then
            self.NextPull = CurTime() + 1
        end
        if self:DefaultReload(ACT_VM_RELOAD) then
            self.FireStart	= nil
            self.CoolOff = nil
            self:EmitSound(self.ReloadSound)
            self.NextIdle = CurTime() + self:SequenceDuration()
        end
    end
end
function SWEP:SecondaryAttack()
    local fov = 30
    if self.Owner:GetFOV()!=fov then
        self.Owner:SetFOV( fov, 0.3 )
    else
        self.Owner:SetFOV( 0, 0.3 )
    end
    self:SetNextSecondaryFire(CurTime(0.3))
end
function SWEP:AddViewKick()
	self.Owner:ViewPunch( Angle(-5,1*math.random( -1, 1 ),3*math.random( -1, 1 )) )
end

function SWEP:Think()
    if self.NextIdle!=nil and CurTime()>=self.NextIdle then
        self:SendWeaponAnim( ACT_VM_IDLE )
        self.NextIdle=nil
    end
    if self.NextPull!=nil and CurTime()>=self.NextPull then
        self:SendWeaponAnim( ACT_VM_PULLBACK )
        self.NextIdle = CurTime() + self:SequenceDuration()
        self:SetNextPrimaryFire( CurTime() + self:SequenceDuration())
        self.NextPull=nil
    end    
end
function SWEP:GetTracerOrigin()
    if self.Owner:GetFOV()<= 70 then
        return self.Owner:GetShootPos()
    end
end
function SWEP:DrawHUD()
	if self.Owner:GetFOV()<= 70 then
		local x = ScrW()
		local y = ScrH()
		local w = x/2
		local h = y/2
		
		render.UpdateRefractTexture(0)
		
		--[[surface.SetTexture(surface.GetTextureID("gmod/scope-refract")) --the material for that wicked cool water edge!
		surface.SetDrawColor(255, 255, 255, 255) --white!!!
		surface.DrawTexturedRect(x/2-y/2, 0, y*1, y*1)  --gets your screen resolution]]--

		surface.SetTexture(surface.GetTextureID("gmod/scope"))  --regular sCOPE overlay
		surface.SetDrawColor(0, 0, 0, 255) --black!!!
		surface.DrawTexturedRect(x/2-y/2, 0, y*1, y*1) --gets your screen resolution
        surface.DrawRect( 0, 0, x/2-y/2, y )
        surface.DrawRect( x/2+y/2, 0, x/2-y/2, y )
		
		surface.DrawLine( w - x, h, w, h )
		surface.DrawLine( w + x, h, w, h )
		surface.DrawLine( w, h - x, w, h )
		surface.DrawLine( w, h + x, w, h )
	end
end

list.Add( "NPCUsableWeapons", { class = "weapon_sniperrifle",	title = "Sniper Rifle" }  )