AddCSLuaFile()


ENT.Base             = "base_nextbot"
ENT.Spawnable        = true
ENT.PrintName		= "TEST"
ENT.Category		= "TESTING ONES"
AccessorFunc( ENT, "m_hActiveWeapon", 			"ActiveWeapon" )

ENT.Model		= "models/player/mp/tobo/robo.mdl"

ENT.Height			= 100
ENT.Width			= 40
ENT.Skin		= 1
ENT.GibType	= 0 --0 never, 1 normally, 2 always
ENT.GibEffect = "blood_zombie_split"
ENT.GibSound = "player/pl_fallpain.wav"
ENT.BloodType	= BLOOD_COLOR_MECH

ENT.FireAnim = ACT_GESTURE_RANGE_ATTACK1 
ENT.WalkAnim = ACT_WALK_RELAXED--ACT_HL2MP_WALK_AR2
ENT.RunAnim = ACT_RUN--ACT_HL2MP_RUN_AR2
ENT.ReloadAnim = ACT_RELOAD
ENT.TwitchAnim = ACT_IDLE
ENT.StandAnim	= ACT_IDLE--ACT_HL2MP_IDLE_AR2
ENT.CalmAnim	= ACT_IDLE--ACT_HL2MP_IDLE_AR2

ENT.MyHealth			= 100
ENT.WalkSpeed		= 50
ENT.RunSpeed		= 150
ENT.WoundedLimit = 50
ENT.WoundedLines = false

ENT.ViewDistance	= 100000
ENT.CombatDistance	= 500 --This guy's favourite shooting distance
ENT.CombatStyle = 1 --1 for gun, 0 for melee
ENT.GuardMode = false
ENT.WonderDistance = 200

ENT.Giblets 		= {
"models/player/gibs/scoutgib007.mdl",
"models/player/gibs/scoutgib003.mdl",
"models/player/gibs/pyrogib003.mdl",
"models/player/gibs/spygib003.mdl",
"models/player/gibs/soldiergib002.mdl",
"models/player/gibs/random_organ.mdl"
}

ENT.GibPoses 		= {
Vector(0,0,0),
Vector(0,0,0),
Vector(0,0,0),
Vector(0,0,0),
Vector(0,0,0),
Vector(0,0,0)
}

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "CurrentWeaponProficiency" ) 
    self:NetworkVar( "Entity", 0, "Enemy" ) 
end

function ENT:Initialize()
    self:SetupDataTables()
    self:SetModel( self.Model )
	self:SetHealth(self.MyHealth)
    if SERVER then
        self:SetMaxHealth(self.MyHealth)
        self:SetBloodColor(self.BloodType)
        self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
        self.loco:SetDeathDropHeight(500)
        self.loco:SetAcceleration(400)
        self.loco:SetDeceleration(400)
        self.loco:SetStepHeight(18)
        self.loco:SetJumpHeight(200)
        self:GiveWeapon("weapon_ar1")
    end
	self:SetSkin(self.Skin)
	self.Entity:SetCollisionBounds( Vector(-self.Width/2,-self.Width/2,0), Vector(self.Width/2,self.Width/2,self.Height) )
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	
	self.NextPain = CurTime()
	table.ForEach(self.Giblets, function(key,value)
		util.PrecacheModel( tostring(value) )
	end)	
	self:DoCosmetics(self)
    self:SetCurrentWeaponProficiency(0)
end

function ENT:PercentageFrozen()
    return 0
end

---SWEP FUNCTIONALITY

function ENT:GetAmmoCount(lal)
    return 9999
end

function ENT:GetShootPos()
    return self:GetPos() + Vector(0,0,64)
end

function ENT:EyePos()
    return self:GetShootPos()
end

function ENT:GetAimVector()
    return (self:GetEnemy():EyePos() - self:GetShootPos()):GetNormalized()
end

function ENT:ViewPunch()
end

function ENT:GiveWeapon(gun)
    local ent = ents.Create(gun)
    ent:SetOwner(self)
    ent:Spawn()
    ent:SetParent(self)
    ent:Fire("setparentattachment", "anim_attachment_RH")
    ent:AddEffects(EF_BONEMERGE)
    self:SetActiveWeapon(ent)
end

---CUSTOMIZATION-------------------------


function ENT:DoCosmetics(ent)

end

function ENT:BoneMerge(target,model,skin,couleur,texture)
	local bat = ents.Create("prop_dynamic")
	bat:SetModel(model)
	bat:SetParent(target)
	bat:SetSkin(skin)
	bat:SetMaterial(texture)
	if couleur!=nil then
        bat:SetColor(couleur)
	end
	bat:SetName(tostring(target:EntIndex()).."costume")
	bat:AddEffects(EF_BONEMERGE)
end

function ENT:AttachModel(target,model, att, offset, ang, scale, color)
	local Trail = ents.Create("prop_dynamic")
	Trail:SetKeyValue("model",model)
	Trail:SetPos(self:GetPos()+target:GetAngles():Forward()*offset.x + target:GetAngles():Right()*offset.y + Vector(0,0,offset.z))
	Trail:SetAngles(self:GetAngles()+ang)
	Trail:SetParent( target )
	Trail:SetKeyValue( "cpoint1_parent", "self" )
	Trail:Fire("setparentattachmentmaintainoffset", att, 0.01)
	Trail:SetModelScale(scale,0)
	Trail:SetColor(color)
	Trail:Spawn()
	Trail:Activate()
	Trail:SetName(tostring(target:EntIndex()).."costume")
end

function ENT:BodyUpdate()
	self:BodyMoveXY()
	self:FrameAdvance()
end

function ENT:BehaveAct()
end

--PAIN-----------------------------------

function ENT:OnInjured(data)
    local damage = data:GetDamage()
    local atakus = data:GetAttacker()
	if damage!=0 and data:GetDamage()<self:Health() then
		if math.random(1,2)==1 and self:Health()>self.WoundedLimit and (self:Health()-damage)<=self.WoundedLimit and self.WoundedLines then
			self:EmitSound("Processed_VOBD_Loader_HUM_React_Injured_0"..math.random(1,6)..".wav")
			self:RestartGesture(self.TwitchAnim, "player_melee_swing" )
		elseif math.random(1,2)==1 and CurTime()>=self.NextPain then
			self:EmitSound("Processed_VOBD_Loader_GEN_React_Pain_0"..math.random(1,9)..".wav")
			self:RestartGesture(self.TwitchAnim, "player_melee_swing" )
			self.NextPain = CurTime()+0.5
		end
        if atakus:IsPlayer() then
            self:SetEnemy(atakus)
        end
	end
end

function ENT:OnKilled(damageinfo)
	self:DoSpecialDeath(damageinfo)
	gamemode.Call("OnNPCKilled",self,damageinfo:GetAttacker(),damageinfo)
	--[[if (self.GibType==1 and damageinfo:GetDamage()>50 and damageinfo:GetDamageType()==DMG_BLAST) or self.GibType==2 then
		self:EmitSound(self.GibSound)
		ParticleEffect(self.GibEffect,self:GetPos(),Angle(0,0,0),nil)
		table.ForEach(self.Giblets, function(key,value)
			local gib = ents.Create("prop_physics_multiplayer")
			gib:SetKeyValue("model",tostring(value))
			gib:SetSkin(self.Skin)
			gib:SetPos(self:GetPos()+self.GibPoses[key])
			gib:SetAngles(self:GetAngles())
			gib:Spawn()
			gib:Activate()
			local phys = gib:GetPhysicsObject()
			phys:ApplyForceCenter(damageinfo:GetDamageForce()*0.1)
			gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			gib:Fire("kill",0,15)
		end)
		self:Remove()
	else]]--
    self:EmitSound("Processed_VOBD_Loader_GEN_React_Death_0"..math.random(1,9)..".wav")
    local stuff = ents.FindByName(tostring(self:EntIndex()).."costume")
    self:GetActiveWeapon():Remove()
    self:BecomeRagdoll(damageinfo)
    --end
end

function ENT:DoSpecialDeath(damageinfo)
end

------------------------------------------------------------------------------------------------------------------------
--BEHAVIOUR
------------------------------------------------------------------------------------------------------------------------

function ENT:PlayActivity(act)
	if self:GetActivity()!=act then
		self:StartActivity(act)
	end
end

function ENT:WarnBuddies()
    
end

function ENT:Think()
	self.Entity:PhysicsInitShadow(true, true)
	if GetConVarNumber("ai_disabled")==1 then return end
    if GetConVarNumber("ai_ignoreplayers")==0 then
        for k,v in pairs(player.GetAll()) do
            if v:IsPlayer() and v:Health() > 0 then
                if self:HasLOS(v) then
                    if !self:GetEnemy():IsValid() then
                        self:WarnBuddies()
                        self:SetEnemy(v)
                    else
                        if !self:HasLOS(self:GetEnemy()) then
                            self:SetEnemy(v)
                        else
                            if self:GetPos():Distance(self:GetEnemy():GetPos())>self:GetPos():Distance(v:GetPos()) then
                                self:SetEnemy(v)
                            end
                        end
                    end
                end
            end
        end
    end
	if self:GetEnemy():IsValid() then
        if self:GetEnemy():Health()>0 then
            if self:HasLOS(self:GetEnemy()) then
                if SERVER then
                    self.loco:FaceTowards( self:GetEnemy():GetPos() )
                    local gun = self:GetActiveWeapon()
                    if CurTime()>=gun:GetNextPrimaryFire() then
                        if self:GetActiveWeapon():Clip1() == 0 then
                            self:RestartGesture(self.ReloadAnim)
                            self:GetActiveWeapon():Reload(self.ReloadAnim)
                        else
                            if gun:CanPrimaryAttack() then
                                --self:RestartGesture(self.FireAnim, "player_melee_swing" )
                                self:RestartGesture(self:GetSequenceActivity( self:LookupSequence("ref_shoot_mp5") ), "player_melee_swing" )
                                self:GetActiveWeapon():PrimaryAttack()
                            end
                        end
                    end
                end
            end
        else
            self:SetEnemy(nil)
        end
    end
end

--[[if IsValid(self:GetEnemy()) and self:GetEnemy():Health()>0 and !self.Dead then
    local enemy = self:GetEnemy()
    local dir = ( self:GetEnemy():GetPos() - self:GetPos() ):Angle()
    local other = self:GetAngles()
    self:ManipulateBoneAngles( 2, Angle(0,dir.x,dir.y-other.y) )
end for loader]]--

function ENT:HasLOS(guy)
	if guy!=nil then
		local tracedata = {}
		tracedata.start =  self:EyePos()
		tracedata.endpos = guy:EyePos()
		tracedata.filter = self
		local trace = util.TraceLine(tracedata)
		local dir = ( guy:EyePos() - self:EyePos() ):GetNormal(); -- replace with eyepos if you want
		local canSee = dir:Dot( self:GetForward() ) > 0.3
		if canSee then
			if trace.HitWorld then
                return false
            else
                if trace.Entity != nil and trace.Entity != guy then
                    return false
                else
                    return true
                end
			end
		end
	end
end

--THANK YOU BASED FACEPUNCH-------------------------------------

function ENT:Wait( time )
	self.waitTime = CurTime() + time;
	while ( ( self.waitTime + FrameTime() ) > CurTime() ) do
		if (self:GetEnemy():IsValid()) and self:HasLOS(self:GetEnemy())  then
			return
		else
			coroutine.wait( FrameTime() )
		end
	end
end

function ENT:IdleMoveToPos( pos, options )
	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )
	if ( !path:IsValid() ) then return "failed" end
	while path:IsValid() and (!self:GetEnemy():IsValid() or !self:HasLOS(self:GetEnemy())) do
		path:Update( self )
		if ( options.draw ) then
			path:Draw()
		end
		if ( self.loco:IsStuck() ) then
			self:HandleStuck();			
			return "stuck"
		end
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		coroutine.yield()
	end
	return "ok"
end

-----------------------------------------------------------------------------

function ENT:RunBehaviour()
    while ( true ) do
        if GetConVarNumber("ai_disabled")==0 then
            if IsValid(self:GetEnemy()) and self:GetEnemy()!=nil then
                if self:GetPos():Distance(self:GetEnemy():GetPos())>self.CombatDistance then
                    self:ChaseTheDude()
                else
                    if self:HasLOS(self:GetEnemy()) then
                        self:PlayActivity( self.StandAnim )
                    else
                        if self:GetPos():Distance(self:GetEnemy():GetPos())<50 then
                            self:PlayActivity(self.WalkAnim)
                            self.loco:SetDesiredSpeed( self.WalkSpeed ) 
                            local maxageScaled = math.Clamp(1,0.1,3)

                            self:IdleMoveToPos(self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.WonderDistance,{draw=false,maxage=maxageScaled})
                            self:PlayActivity( self.CalmAnim )
                            self:Wait(2)         
                        else
                            self:ChaseTheDude()
                        end
                    end
                end
            else
                self:PlayActivity(self.WalkAnim)
                self.loco:SetDesiredSpeed( self.WalkSpeed ) 
                local maxageScaled = math.Clamp(1,0.1,3)

                self:IdleMoveToPos(self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * self.WonderDistance,{draw=false,maxage=maxageScaled})
                self:PlayActivity( self.CalmAnim )
                self:Wait(2)
            end	
        end
		coroutine.yield()
    end
end

function ENT:ChaseTheDude()
	self:PlayActivity(self.RunAnim)
	self.loco:SetDesiredSpeed( self.RunSpeed )
	local maxageScaled = math.Clamp(self:GetEnemy():GetPos():Distance(self:GetPos())/1000,0.1,3)

	--self:MoveToPos(self:GetEnemy():GetPos(),{draw=false,maxage=maxageScaled})
    self:MoveToPos(self:GetEnemy():GetPos(),{draw=false,maxage=maxageScaled})
end

function ENT:OnStuck( )
	self.loco:Jump()
end