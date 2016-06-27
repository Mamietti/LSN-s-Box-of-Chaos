--return
SWEP.PrintName			= "Tau Cannon"
SWEP.Author			= "Strafe"
SWEP.Instructions	= "One Energy Weapon to rule 'em all"
SWEP.Category	= "Half-Life 2 Plus"
SWEP.Purpose = "Bullets just aren't cool enough."
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= false
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/v_gauss.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel			= "models/weapons/w_gauss.mdl"
SWEP.CSMuzzleFlashes	= false
SWEP.HoldType			= "shotgun"
SWEP.FiresUnderwater = false
SWEP.Base = "weapon_hl2_base_strafe"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 25
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "GaussEnergy"
SWEP.Primary.DamageBase = "sk_plr_dmg_smg1"
SWEP.Primary.DamageMult = 1
SWEP.Primary.FireSound = "PropJeep.FireCannon"
SWEP.Primary.EmptySound = "Weapon_IRifle.Empty"
SWEP.Primary.Number = 1
SWEP.Primary.Spread = 0.01
SWEP.Primary.Tracer = "GaussTracer"
SWEP.Primary.TracerAmount = 1
SWEP.Primary.FireRate = 0.2
SWEP.Primary.Recoil = 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.ViewModelFOV = 55

SWEP.DamageMult = 0
SWEP.FireStart = nil
SWEP.Sound = nil
/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( color_transparent )
	surface.SetTextColor( 255, 220, 0, alpha )
	surface.SetFont( "HL2HUDFONT" )
	local w, h = surface.GetTextSize("h")

	surface.SetTextPos( x + ( wide / 2 ) - ( w / 2 ),
						y + ( tall / 2 ) - ( h / 2 ) )
	surface.DrawText( "h" )
end
function SWEP:FireBeam(dmgbonus)
    self:EmitSound( self.Primary.FireSound )
    local bullet = {}
    bullet.Attacker = self.Owner
    bullet.Inflictor = self
    bullet.Num 		= self.Primary.Number
    bullet.HullSize = 0
    bullet.Src 		= self.Owner:GetShootPos()
    bullet.Dir 		= self.Owner:GetAimVector()
    bullet.TracerName = 0
    bullet.Tracer	= 0
    bullet.Damage	= 20 + dmgbonus*20
    bullet.Force    = 5 + dmgbonus*10
    bullet.Callback = function(attacker, trace, dmginfo)
        if dmginfo then dmginfo:SetDamageType(DMG_ENERGYBEAM) end
        local forward = self.Owner:EyeAngles():Forward()
        local up = self.Owner:EyeAngles():Up()
        local right = self.Owner:EyeAngles():Right()
        local shootpos = self.Owner:GetShootPos()+right*10+forward*10-up*10
        
        local effectdata = EffectData()
        effectdata:SetOrigin( trace.HitPos)
        effectdata:SetScale(1)
        effectdata:SetMagnitude(1)
        effectdata:SetRadius(10)
        util.Effect( "Sparks", effectdata )--sparks
        
        local effectdata2 = EffectData()
        effectdata2:SetOrigin( trace.HitPos)
        effectdata2:SetStart(shootpos)
        effectdata2:SetScale(6000)
        effectdata2:SetAngles( Vector(trace.HitPos-shootpos):Angle())
        effectdata2:SetNormal(trace.HitNormal )
        effectdata2:SetEntity( trace.Entity )
        effectdata2:SetSurfaceProp( trace.SurfaceProps )
        effectdata2:SetHitBox( trace.HitBox )
        effectdata2:SetFlags(0)
        util.Effect( "GaussTracer", effectdata2, false, true)
        
        if SERVER then
        local hit = ents.Create("info_particle_system")
        hit:SetPos(trace.HitPos)
        hit:SetName("target"..tostring(self.Owner))
        hit:SetAngles(self:GetAngles())

        local zappy = ents.Create( "env_beam" )
            zappy:SetPos(shootpos)
            zappy:SetKeyValue( "life", "0" )
            zappy:SetKeyValue( "BoltWidth", "0.5" )
            zappy:SetKeyValue( "NoiseAmplitude", "1" )
            zappy:SetKeyValue( "damage", "0" )
            zappy:SetKeyValue( "Spawnflags", "17" )
            zappy:SetKeyValue( "texture", "sprites/laserbeam.vtf" )
            zappy:SetName("beam"..tostring(self.Owner))
            zappy:SetKeyValue( "LightningStart", zappy:GetName() )
            zappy:SetKeyValue("LightningEnd", hit:GetName() )
            zappy:SetColor(Color(255,255,255,100))
            zappy:Spawn()
            zappy:Activate()
            
            hit:Fire("kill",0,0.1)
            zappy:Fire("kill",0,0.1)
        end
        
        util.Decal("RedGlowFade", trace.HitPos+trace.HitNormal, trace.HitPos-trace.HitNormal)
        --util.Decal("ManhackCut", trace.HitPos+trace.HitNormal, trace.HitPos-trace.HitNormal)
    end
    self.Owner:FireBullets(bullet)
end

function SWEP:PrimaryAttack()
	--if ( !self:CanPrimaryAttack() ) then return end
	if self.Owner:IsNPC() or self:Ammo1()>1 then
		if (!self.FiresUnderwater and self.Owner:WaterLevel()!=3) or self.FiresUnderwater then
			self:SetNextPrimaryFire( CurTime() + self.Primary.FireRate)
            self:FireBeam(0)
            if !self.Owner:IsNPC() then
                --self.Owner:ViewPunch(Angle(math.Rand(-self.Primary.Recoil,self.Primary.Recoil)*,math.Rand(-self.Primary.Recoil,self.Primary.Recoil),0))
                self:AddViewKick()
                self:ShootEffects(self)
                self:TakePrimaryAmmo(2)
                self.NextIdle = CurTime() + self:SequenceDuration()
            end
        else
            self.Weapon:EmitSound( self.Primary.EmptySound )
            self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
		end
        if self.Owner:IsNPC() and self.Primary.Automatic then
            if !timer.Exists(tostring(self.Owner:EntIndex())) then
                timer.Create( tostring(self.Owner:EntIndex()), self.Primary.FireRate, 3, function() 
                    if IsValid(self) and IsValid(self.Owner) and self:Clip1()>0 and self.Owner:GetEnemy() then
                        self:PrimaryAttack()
                    end
                end )
            end
        end
    else
        self.Weapon:EmitSound( self.Primary.EmptySound )
        self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
	end
end

function SWEP:SecondaryAttack()
    if self:Ammo1()>1 then
        if self.DamageMult==0 then
            --self:EmitSound("weapons/gauss/chargeloop.wav",100,255)
            local sound = CreateSound(self,"weapons/gauss/chargeloop.wav")
            sound:Play()
            sound:ChangePitch( 255, 2 )
            self.Sound = sound
            self.StartTime = CurTime()
            self:TakePrimaryAmmo(2)
            self:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
        end
        if self.DamageMult<5 then
            self.DamageMult = self.DamageMult + 1
            self:TakePrimaryAmmo(2)
            if self.DamageMult==3 then
                self:SendWeaponAnim( ACT_VM_PULLBACK )
            end
        end
    end
    self:SetNextSecondaryFire(CurTime() + 0.5)
    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:DrawWorldModel()
	if not self.Owner:IsValid() then
		self:DrawModel()
	else
		local hand, offset, rotate
		hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))
		offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 2 + hand.Ang:Up() * 0

		hand.Ang:RotateAroundAxis(hand.Ang:Right(), 20)
		hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
		hand.Ang:RotateAroundAxis(hand.Ang:Up(), 170)

		self:SetRenderOrigin(hand.Pos + offset)
		self:SetRenderAngles(hand.Ang)
        self:SetModelScale( 0.5, 0)

		self:DrawModel()
	end
end

function SWEP:Think()
	if self.Owner:KeyDown( IN_ATTACK ) then
        if self.FireStart==nil then
            self.FireStart	= CurTime()
        end
	elseif !self.Owner:KeyDown( IN_ATTACK ) then
		self.FireStart	= nil
	end
    if self.Owner:IsNPC() then return end
    if self.Owner:KeyReleased(IN_ATTACK2) and self.DamageMult>0 then
        self:FireBeam(self.DamageMult)
        self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
        self:SetNextSecondaryFire(CurTime() + 1.5)
        self:SetNextPrimaryFire(CurTime() + 1.5)
        self.Owner:SetVelocity(-self.Owner:GetAimVector()*75*self.DamageMult)
        self.DamageMult = 0
        self.StartTime = nil
        --self:StopSound("weapons/gauss/chargeloop.wav")
        self.Sound:Stop()
    end
end

function SWEP:PostDrawViewModel(view)
    bone = view:LookupBone("spinner")
    boner = view:LookupBone("fan")
    if self.Owner:KeyDown( IN_ATTACK2 ) and (view:GetSequenceActivity( view:GetSequence() )==ACT_VM_PULLBACK_LOW or view:GetSequenceActivity( view:GetSequence() )==ACT_VM_PULLBACK) then
        view:ManipulateBoneAngles( boner, Angle(0,0,1000)*CurTime() )
        if view:GetSequenceActivity( view:GetSequence() )==ACT_VM_PULLBACK_LOW then
            view:ManipulateBoneAngles( bone, Angle(0,0,500)*CurTime() )
        else
            view:ManipulateBoneAngles( bone, Angle(0,0,1000)*CurTime() )
        end
    end
end

function SWEP:Holster(wep)
	timer.Stop( "weapon_idle" .. self:EntIndex() )
    --self:StopSound("weapons/gauss/chargeloop.wav")
    if self.Sound!=nil then
        self.Sound:Stop()
    end
	return true
end

function SWEP:OnRemove()
	timer.Stop( "weapon_idle" .. self:EntIndex() )
    --self:StopSound("weapons/gauss/chargeloop.wav")
    if self.Sound!=nil then
        self.Sound:Stop()
    end
end

function SWEP:Initialize()
	if ( SERVER ) then
		self:SetNPCMinBurst( 2 )
		self:SetNPCMaxBurst( 5 )
		self:SetNPCFireRate( self.Primary.Delay )
	end
	self:SetWeaponHoldType("shotgun")
end

--list.Add( "NPCUsableWeapons", { class = "weapon_gauss",	title = "Gauss Gun" }  )

function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}
	if ( t == "shotgun" ) then
	self.ActivityTranslateAI [ ACT_IDLE ] 						= ACT_IDLE_SMG1
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_SHOTGUN
	self.ActivityTranslateAI [ ACT_IDLE_RELAXED ] 				= ACT_IDLE_SMG1_RELAXED
	self.ActivityTranslateAI [ ACT_IDLE_STIMULATED ] 			= ACT_IDLE_SMG1_STIMULATED
	self.ActivityTranslateAI [ ACT_IDLE_AGITATED ] 				= ACT_IDLE_ANGRY_SMG1

	self.ActivityTranslateAI [ ACT_RUN ] 					= ACT_RUN_AIM_SHOTGUN
	self.ActivityTranslateAI [ ACT_MP_CROUCHWALK ] 				= ACT_HL2MP_WALK_CROUCH_SHOTGUN

	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_SHOTGUN
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 			= ACT_RANGE_ATTACK_SHOTGUN_LOW
	
	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_SHOTGUN
	return end	
end