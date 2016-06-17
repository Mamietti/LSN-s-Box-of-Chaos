AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName = "Robo Grunt"
ENT.Author = "Strafe"
ENT.Contact = ""
ENT.Purpose = "Shoot things and die"
ENT.Instructions = "NO"
ENT.Information	= "NO"  
ENT.Category		= "Test"

ENT.AutomaticFrameAdvance = true

ENT.Spawnable = false
ENT.AdminSpawnable = false

AccessorFunc(ENT,"m_iClass","NPCClass",FORCE_NUMBER)
AccessorFunc(ENT,"m_fMaxYawSpeed","MaxYawSpeed",FORCE_NUMBER)
AccessorFunc(ENT,"m_flFieldOfView", "Fido", FORCE_NUMBER)
AccessorFunc(ENT, "m_flNextAttack", "NextAttack")
AccessorFunc(ENT,"m_hEnemy","Enemy")

if CLIENT then
    function ENT:Draw()
        self.Entity:DrawModel()
    end
end
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
  self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:Initialize()
    --self:SetModel("models/combine_super_soldier.mdl")
    self:SetModel("models/player/mp/tobo/robo.mdl")
    self:SetSolid( SOLID_BBOX )
    self:SetMoveType( MOVETYPE_STEP )
	--self.Entity:SetCollisionBounds( Vector(-32,-32,0), Vector(32,32,100) )
	--self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    if SERVER then
        self:CapabilitiesAdd( bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP, CAP_OPEN_DOORS, CAP_SQUAD, CAP_INNATE_RANGE_ATTACK1) )
        self:SetSchedule(SCHED_FALL_TO_GROUND)
        self:SetNPCState(NPC_STATE_IDLE)
        self:SetEnemy(nil)
    end
    self:SetHealth(60)
    self:SetNPCClass(CLASS_COMBINE)
    self:SetMaxYawSpeed(300)
    self:SetFido(90)
    self:SetKeyValue( "spawnflags", "256" )
    self:SetNextAttack(CurTime())
    --PrintTable(self:GetSaveTable())
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
--if SERVER then
function ENT:OnTakeDamage(dmg)
    if self:GetNPCState()==NPC_STATE_DEAD then return end
    if self:Health()<=dmg:GetDamage() then
        self:ClearSchedule()
        self:SetNPCState(NPC_STATE_DEAD)
        self:SetHealth(0)
        self:JustDie(dmg)
    else
        self:SetHealth(self:Health()-dmg:GetDamage())
        if self.NextPain==nil or CurTime()>=self.NextPain then
            self:EmitSound(Sound("vo/mvm/mght/pyro_mvm_m_painsharp0"..math.random(1,7)..".mp3"))
            self.NextPain = CurTime() + 1
        end
        self:UpdateEnemyMemory( dmg:GetAttacker(), dmg:GetAttacker():GetPos() )
    end
end

function ENT:JustDie(dmg)
    self:ClearEnemyMemory()
    self:ClearSchedule()
    self:SetSchedule(SCHED_DIE)
    self:EmitSound(Sound("vo/mvm/mght/pyro_mvm_m_painsevere0"..math.random(1,6)..".mp3"))
    if dmg then
        gamemode.Call("OnNPCKilled",self,dmg:GetAttacker(),dmg)
    else
        gamemode.Call("OnNPCKilled",self,self)
    end
    timer.Create( tostring(self:EntIndex()).."kill", self:SequenceDuration()*0.2, 1, function() 
        if IsValid(self) then
            self:SetSchedule(SCHED_FALL_TO_GROUND)
        end
    end)
end
--end
function ENT:RangeAttack()
    --self:RestartGesture( self:GetSequenceActivity( self:LookupSequence( "ref_shoot_onehanded" ) ), true, true )
    self:RemoveAllGestures()
    self:AddGestureSequence( self:LookupSequence( "ref_shoot_hive" ), false )
    local bullet = {}

    bullet.Num 	= 1
    bullet.Src 	= self:GetShootPos() -- Source
    bullet.Dir 	= self:GetAimVector() -- Dir of bullet
    bullet.Spread 	= Vector( 0.1, 0.1, 0 )	-- Aim Cone
    bullet.Tracer	= 1 -- Show a tracer on every x bullets
    bullet.Force	= 1 -- Amount of force to give to phys objects
    bullet.Damage	= 0
    bullet.AmmoType = "Pistol"

    self:FireBullets( bullet )
    sound.Play( "weapons/capper_shoot.wav", self:GetPos())
end
function ENT:Think()
    if SERVER then
        if GetConVarNumber("ai_disabled")==1 then return end
        if self:IsCurrentSchedule( SCHED_RANGE_ATTACK1 ) then
            if CurTime()>self:GetNextAttack() then
                self:RangeAttack()
                self:SetNextAttack(CurTime()+0.2)
            end
        else
            if CurTime()>self:GetNextAttack()+0.1 then
                self:RemoveAllGestures()
            end
        end
    end
end
if SERVER then   
    function ENT:SelectSchedule()
        if self:GetEnemy() and self:GetEnemy():Health()>0 then
            if self:GetNPCState()==NPC_STATE_IDLE then
                self:EmitSound("NPC_CombineCamera.Alert")
            end
            self:SetNPCState(NPC_STATE_ALERT)
            if self:HasLOS(self:GetEnemy()) then
                if self:GetEnemy():GetPos():Distance(self:GetPos())<100 then
                    if self:GetEnemy():GetPos():Distance(self:GetPos())>60 then
                        self:SetSchedule(SCHED_COMBAT_STAND)
                    else
                        self:SetSchedule(SCHED_BACK_AWAY_FROM_ENEMY)
                    end
                else
                    self:SetSchedule(SCHED_CHASE_ENEMY)
                end
            else
                self:SetSchedule(SCHED_CHASE_ENEMY)
            end
        else
            self:SetSchedule(SCHED_IDLE_WALK)
        end
    end
end

function ENT:SpawnBlood(dmg)
    local bloodeffect = ents.Create( "info_particle_system" )
    bloodeffect:SetKeyValue( "effect_name", "blood_impact_red_01" )
    bloodeffect:SetPos( dmg:GetDamagePosition() ) 
    bloodeffect:Spawn()
    bloodeffect:Activate() 
    bloodeffect:Fire( "Start", "", 0 )
    bloodeffect:Fire( "Kill", "", 0.1 )
end

function ENT:HasLOS(guy)
	if guy!=nil then
		local tracedata = {}
		tracedata.start =  self:GetPos()
		tracedata.endpos = guy:GetPos()
		tracedata.filter = self
		local trace = util.TraceLine(tracedata)
		local dir = ( guy:GetPos() - self:GetPos() ):GetNormal(); -- replace with eyepos if you want
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