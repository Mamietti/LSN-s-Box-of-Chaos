return
SWEP.PrintName			= "HECU Sniper"
SWEP.Author			= "Strafe"
SWEP.Instructions	= ""
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = "When a long-distance 'screw you' is required."
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= true
SWEP.Slot				= 3
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/c_m40a1.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_m40a1.mdl"
SWEP.CSMuzzleFlashes	= true
SWEP.HoldType			= "ar2"
SWEP.FiresUnderwater = false
SWEP.ReloadSound = ""
SWEP.Base = "weapon_hl2_base_strafe"
SWEP.ViewModelFOV = 60
SWEP.DrawCrosshair = false
SWEP.Slow = true

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "SniperRound"
SWEP.Primary.DamageBase = "sk_plr_dmg_crossbow"
SWEP.Primary.DamageMult = 1
SWEP.Primary.FireSound = "Weapon_Sniper.Single"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.FireRate = 2

SWEP.EASY_DAMPEN = 0.5
SWEP.MAX_VERTICAL_KICK = 1
SWEP.SLIDE_LIMIT = 0.01
SWEP.KICK_MIN_X = 6
SWEP.KICK_MIN_Y = 2
SWEP.KICK_MIN_Z = 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

if CLIENT then
	killicon.AddFont("weapon_sniperrifle", "CSKillIcons", "r", Color(255, 100, 0, 255))
end
function SWEP:Initialize()
	if ( SERVER ) then
		self:SetNPCMinBurst( 1 )
		self:SetNPCMaxBurst( 1 )
		self:SetNPCFireRate( self.Primary.Delay )
        self:SetNPCMinRest(0)
        self:SetNPCMaxRest(0)
	end
    --self.Weapon.Owner:SetKeyValue( "spawnflags", "256" )
	self:SetWeaponHoldType(self.HoldType)
    if self.Owner:IsNPC() and SERVER then
        self:SetWeaponHoldType("shotgun")
        self.Weapon.Owner:SetKeyValue( "spawnflags", "256" )
        if self.Owner:GetClass()=="npc_combine_s" then
            hook.Add( "Think", self, function()
                if IsValid(self.Owner) and self.Owner:IsNPC() then
                    if self.Owner:GetEnemy() and self.Owner:GetActivity() == 11 and CurTime()>=self:GetNextPrimaryFire() then
                        self:PrimaryAttack()
                    end
                end
            end)
        end
    end
end
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( color_transparent )
	surface.SetTextColor( 255, 220, 0, alpha )
	surface.SetFont( "CSKillIcons" )
	local w, h = surface.GetTextSize("r")

	surface.SetTextPos( x + ( wide / 2 ) - ( w / 2 ),
						y + ( tall / 2 ) - ( h / 2 ) )
	surface.DrawText( "r" )
end
function SWEP:Reload()
	if self:DefaultReload(ACT_VM_RELOAD) then
		self:EmitSound(self.ReloadSound)
        --if self.Owner:GetFOV()==30 then
        self.Owner:SetFOV( 0, 0.3 )
        self.DrawCrosshair = true
        --end      
	end
end
function SWEP:SecondaryAttack()
    local fov = 30
    if self.Owner:GetFOV()!=fov then
        self.Owner:SetFOV( fov, 0.3 )
        self.DrawCrosshair = false
    else
        self.Owner:SetFOV( 0, 0.3 )
        self.DrawCrosshair = true
    end
    self:SetNextSecondaryFire(CurTime(0.3))
end

function SWEP:Holster(wep)
    if IsValid(self.Owner) and !self.Owner:IsNPC() then
        self.Owner:SetFOV( 0, 0 )
    end
	return true
end

function SWEP:DrawHUD()
	if self.Owner:GetFOV()<= 70 then
		local x = ScrW()
		local y = ScrH()
		local w = x/2
		local h = y/2
		
		render.UpdateRefractTexture(0)
		
		surface.SetTexture(surface.GetTextureID("gmod/scope-refract")) --the material for that wicked cool water edge!
		surface.SetDrawColor(255, 255, 255, 255) --white!!!
		surface.DrawTexturedRect(x/2-y/2, 0, y*1, y*1)  --gets your screen resolution

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

function SWEP:DrawWorldModel()
	if not self.Owner:IsValid() then
		self:DrawModel()
	else
        if self.Owner:Health()>0 then
            local hand, offset, rotate
            hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))
            offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 2 + hand.Ang:Up() * 0

            hand.Ang:RotateAroundAxis(hand.Ang:Right(), 20)
            hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
            hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

            self:SetRenderOrigin(hand.Pos + offset)
            self:SetRenderAngles(hand.Ang)

            self:DrawModel()
        else
            self:DrawModel()
        end
	end
end

--list.Add( "NPCUsableWeapons", { class = "weapon_sniperrifle",	title = "HECU Sniper" }  )