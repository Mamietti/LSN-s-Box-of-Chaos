AddCSLuaFile()


ENT.Base             = "base_nextbot"
ENT.Spawnable        = true
ENT.PrintName		= "Skeleton"

ENT.BotHealth			= 100
ENT.WalkSpeed		= 100
ENT.RunSpeed		= 200
ENT.Model		= "models/alyx.mdl"
ENT.Skin		= 2

ENT.Height			= 64
ENT.Width			= 12

ENT.SwingSound		= "weapons/bat_draw_swoosh1.wav"
ENT.HitSound		= "Zombie.AttackHit"

ENT.MeleeType		= DMG_CLUB
ENT.MeleeDamage		= 30
ENT.MeleeDelay		= 0.9
ENT.Range		= 100
ENT.Team		= platyer
ENT.LookDistance = 500

ENT.DeathSounds		= {
Sound("misc/halloween/skeleton_break.wav"),
}
ENT.PainSounds		= {
Sound("Zombie.Pain")
}
ENT.Enemynotice		= {
Sound("Weapon_Knife.Hit")
}
ENT.Giblets = {
"models/bots/skeleton_sniper/skeleton_sniper_gib_arm_l.mdl",
"models/bots/skeleton_sniper/skeleton_sniper_gib_arm_r.mdl",
"models/bots/skeleton_sniper/skeleton_sniper_gib_head.mdl",
"models/bots/skeleton_sniper/skeleton_sniper_gib_leg_l.mdl",
"models/bots/skeleton_sniper/skeleton_sniper_gib_leg_r.mdl",
"models/bots/skeleton_sniper/skeleton_sniper_gib_torso.mdl"
}
function ENT:Think()
	if GetConVarNumber("ai_disabled")==1 then return end
	if IsValid(self:GetEnemy()) and self:GetEnemy():Health()>0 then
		local enemy = self:GetEnemy()
		self.loco:FaceTowards( self:GetEnemy():GetPos() )
	else
		self:SetEnemy(nil)
	end
	local monsters = ents.FindByClass("monster_*")
	local npcs = ents.FindByClass("npc_*")
	table:Add(npcs,monsters)
	self:DecideEnemy(npcs)
	if self.Team!=player then
		self:DecideEnemy(player.GetAll())
	end
	self:PhysicsInitShadow(true,true)
end

function ENT:HasLOS(enemy)
	local tracedata = {}
	tracedata.start =  self:GetPos()+Vector(0,0,128)
	tracedata.endpos = enemy:GetPos()+Vector(0,0,128)
	tracedata.filter = self
	local trace = util.TraceLine(tracedata)
	if trace.HitWorld == false then
		return true
	else
		return false
	end
end

function ENT:DecideEnemy(dudes)
	for k,v in pairs(dudes) do
		local newdistance = v:GetPos():Distance(self:GetPos())
		if newdistance>=self.LookDistance then return end
		if v!=self and v:GetClass()!=self:GetClass() and v.Team!=self.Team then
			if self:GetEnemy() then
				if self:HasLOS(self:GetEnemy()) then
					local current = self:GetEnemy():GetPos():Distance(self:GetPos())
					if newdistance<current and self:HasLOS(v) then
						self:SetEnemy(v)
					end
				else
					if self:HasLOS(v) then
						self:SetEnemy(v)
					end
				end
			else
				if self:HasLOS(v) then
					self:SetEnemy(v)
				end
			end
		end
	end
end

function ENT:Initialize()
    self:SetModel( self.Model )
	self:SetHealth(self.BotHealth)
	self:SetMaxHealth(self.BotHealth)
	self:SetSkin(self.Skin)
	--self:SetBloodColor( DONT_BLEED )
	self:SetBloodColor( BLOOD_COLOR_YELLOW )
	self.Entity:SetCollisionBounds( Vector(-self.Width,-self.Width,0), Vector(self.Width,self.Width,self.Height) )
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	self:SpecialInit()
	
	self.loco:SetDeathDropHeight(500)
	self.loco:SetAcceleration(400)
	self.loco:SetDeceleration(400)
	self.loco:SetStepHeight(18)
	self.loco:SetJumpHeight(50)

	self.Alerted = false
	function self:IsNPC()
		return true
	end
	self.Entity:PhysicsInitShadow(true, false)
	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
end

function ENT:SpecialInit()
end

function ENT:BoneMerge(model,skin,couleur)
	local bat = ents.Create("prop_dynamic")
	bat:SetModel(model)
	bat:SetParent(self)
	bat:AddEffects(EF_BONEMERGE)
	bat:SetSkin(skin)
	bat:SetColor(couleur)
	bat:SetName(tostring(self:EntIndex()).."costume")
end

function ENT:BehaveAct()
end

function ENT:PlayActivity(act)
	if self:GetActivity()!=act then
		self:StartActivity(act)
		self:SetPlaybackRate( 1 )
	end
end

function ENT:GetEnemy()
	if ( IsValid( self.Enemy ) ) then
		return self.Enemy;
	else
		return nil
	end
end

function ENT:SetEnemy(ent)
	self.Enemy = ent
end
-------------------------------------------------------------------------------------------------------------------------
function ENT:OnInjured(data)
	self:DoSpecialInjure(data)
	if data:GetDamage()<=0 then return end
	if data:GetDamage()<self:Health() and math.random(1,2)==2 then
		self:EmitSound(self.PainSounds[math.random(1,table.Count(self.PainSounds)-1)])
		if self.NoFlinch==nil or self.NoFlinch==false then
			self:RestartGesture( ACT_MP_GESTURE_FLINCH_CHEST, "player_melee_swing" )
		end
	end
	self.Alerted = true
	local evil = data:GetAttacker()
	if evil == self:GetEnemy() or evil == self then return end
	if IsValid(evil) then
		self.Alerted = true
		self:SetEnemy(evil)
	end
	self:BehaveUpdate()
end

function ENT:DoSpecialInjure(data)

end

function ENT:OnKilled(damageinfo)
	self:DoSpecialDeath(damageinfo)
	self:EmitSound(self.DeathSounds[math.random(1,table.Count(self.DeathSounds)-1)])
	self:BecomeRagdoll(damageinfo)
	--[[
	self.Giblets = {
	"models/bots/skeleton_sniper/skeleton_sniper_gib_arm_l.mdl",
	"models/bots/skeleton_sniper/skeleton_sniper_gib_arm_r.mdl",
	"models/bots/skeleton_sniper/skeleton_sniper_gib_head.mdl",
	"models/bots/skeleton_sniper/skeleton_sniper_gib_leg_l.mdl",
	"models/bots/skeleton_sniper/skeleton_sniper_gib_leg_r.mdl",
	"models/bots/skeleton_sniper/skeleton_sniper_gib_torso.mdl"
	}
	table.ForEach(self.Giblets, function(key,value)
		local gib = ents.Create("prop_physics_multiplayer")
		gib:SetKeyValue("model",tostring(value))
		gib:SetSkin(self.Skin)
		gib:SetPos(self:GetPos())
		gib:SetAngles(self:GetAngles())
		gib:Spawn()
		gib:Activate()
		local phys = gib:GetPhysicsObject()
		phys:ApplyForceCenter(damageinfo:GetDamageForce())
		gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		gib:Fire("kill",0,10)
	end)
	local stuff = ents.FindByName(tostring(self:EntIndex()).."costume")
	if IsValid(stuff) then
		stuff:Fire("kill",0,0)
	end
	]]--
	gamemode.Call("OnNPCKilled",self,damageinfo:GetAttacker(),damageinfo)
	self:Remove()
end

function ENT:DoSpecialDeath(damageinfo)
	local effect = ents.Create("info_particle_system")
	effect:SetPos(self:GetPos()+Vector(0,0,40))
	effect:SetAngles(self:GetAngles())
	effect:SetKeyValue("effect_name", "spell_skeleton_goop_green")
	effect:SetKeyValue("start_active", "1")
	effect:SetParent(self)
	effect:Spawn()
	effect:Activate()
	effect:Fire("kill",0,0.3)
end
------------------------------------------------------------------------------------------------------------------------

function ENT:RunBehaviour()
    while ( true ) do
		if GetConVarNumber("ai_disabled")==0 then
			if IsValid(self.Enemy) and self.Enemy:Health()>0 then
				local dizzy = self.Enemy:GetPos():Distance(self:GetPos())
				if dizzy<=(self.Range*0.75) then
					self:PlayActivity(ACT_IDLE )
					self:EmitSound(self.SwingSound)
					self:RestartGesture( ACT_MP_ATTACK_STAND_MELEE, "player_melee_swing" )
					coroutine.wait(0.6)
					local retest = self.Enemy:GetPos():Distance(self:GetPos())
					if retest<=self.Range then
						local dmg = DamageInfo()
						dmg:SetDamage(self.MeleeDamage)
						dmg:SetAttacker(self)
						dmg:SetDamageType(self.MeleeType)
						self.Enemy:TakeDamageInfo(dmg)
						self:EmitSound(self.HitSound)
						self:SpecialAttack(self.Enemy)
					end
					coroutine.wait(self.MeleeDelay)
				else
					self:PlayActivity( ACT_RUN )                            -- walk anims
					self.loco:SetDesiredSpeed( self.RunSpeed )                        -- walk speeds
					local scale = math.Clamp(self.Enemy:GetPos():Distance(self:GetPos())/1000,0.1,3)
					local opts = {	lookahead = 300,
										tolerance = 20,
										draw = false,
										maxage = 0.01,
										repath = scale	}
					self:MoveToPos(self.Enemy:GetPos(),opts)
				end
			else
				self:PlayActivity( ACT_RUN )                            -- walk anims
				self.loco:SetDesiredSpeed( self.WalkSpeed )                        -- walk speeds
				self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200 )
				--self:PlaySequenceAndWait( "idle_to_sit_ground" )
				self:PlayActivity( ACT_IDLE_ANGRY  )
			end
		else
			self:PlayActivity( ACT_IDLE_ANGRY  )
			coroutine.wait(1)			
		end
		coroutine.yield()
    end
end

function ENT:ChaseTarget(ent, options)		// Follow a target

	local options = options or {}
	local path = Path("Chase")
	path:SetMinLookAheadDistance(300)
	path:SetGoalTolerance(20)

	path:Compute(self, ent:GetPos())

	while true do

		path:Compute(self, ent:GetPos())
		--path:Draw()
		path:Chase(self, ent)
		
		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then

			self:HandleStuck();
			return "stuck"
		end

		coroutine.yield()
	end

	return "ok"
end

function ENT:SpecialAttack(ent)
end
function ENT:OnStuck( )
	self.loco:Jump()
end

function ENT:BodyUpdate()
	self:BodyMoveXY( )
end
-- List the NPC as spawnable
--[[list.Set( "NPC", "npc_bot_base_strafe",     {    Name = "Generic", 
                                        Class = "npc_bot_base_strafe",
                                        Category = "Drop The Base"    
                                    })]--