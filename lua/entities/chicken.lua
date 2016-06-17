AddCSLuaFile()

ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName = "Chicken"
ENT.Author = "Strafe"
ENT.Contact = ""
ENT.Purpose = "Die"
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
game.AddParticles( "particles/critters/chicken.pcf" )
if CLIENT then
    function ENT:Draw()
        self.Entity:DrawModel()
    end
end
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
  self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:Initialize()
    self:SetModel("models/chicken/chicken.mdl")
    --self:SetModel("models/headcrabclassic.mdl")
    self:SetSolid( SOLID_BBOX )
    self:SetMoveType( MOVETYPE_STEP )
	self.Entity:SetCollisionBounds( Vector(-32,-32,0), Vector(32,32,100) )
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    --self:SetHealth(60)
    self:SetNPCClass(CLASS_ROBOT)
    self:SetMaxYawSpeed(300)
    self:SetFido(360)
    self:SetSkin(math.random(0,1))
    if math.random(1,15)==1 then
        self:SetBodygroup(1,math.random(1,3))
    end
    self.NextSound = CurTime()
    self.NextIdle = CurTime()
    self.jumping = false
    if SERVER then
        self:CapabilitiesAdd( bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP) )
        --self:SetSchedule(SCHED_FALL_TO_GROUND)
        self:SetNPCState(NPC_STATE_IDLE)
        --self:SetEnemy(nil)
        self:AddRelationship( "player D_FR 99" )
        self:AddRelationship( "npc_zombie D_FR 99" )
    end
end
--if SERVER then
function ENT:OnTakeDamage(dmg)
    self:EmitSound("ambient/creatures/chicken_death_0"..math.random(1,3)..".wav")
    ParticleEffect("env_sawblood",self:GetPos(),Angle(0,0,0),nil) --chicken_gone_zombie
    self:Remove()
end

if SERVER then   
    function ENT:SelectSchedule()
        if self:GetEnemy() then
            if self:GetEnemy():GetPos():Distance(self:GetPos())<100 then
                if self:GetNPCState()==NPC_STATE_IDLE then
                    self:SetNPCState(NPC_STATE_ALERT)
                end
                self:SetSchedule(SCHED_RUN_FROM_ENEMY)
            else
                if self:GetNPCState()==NPC_STATE_ALERT then
                    self:SetNPCState(NPC_STATE_IDLE)
                end
                self:SetSchedule(SCHED_IDLE_WANDER)
            end
        else
            self:SetSchedule(SCHED_IDLE_WANDER)
        end
    end
end
function ENT:Think()
    if CLIENT then return end
    if self:GetEnemy() and self:GetEnemy():GetPos():Distance(self:GetPos())<100 and self:GetActivity()==ACT_RUN then
        if CurTime()>=self.NextSound then
            self:EmitSound("ambient/creatures/chicken_panic_0"..math.random(1,4)..".wav")
            self.NextSound = CurTime() + 2
            self.NextIdle = CurTime() + 10
        end
    else
        if CurTime()>=self.NextIdle then
            self:EmitSound("ambient/creatures/chicken_idle_0"..math.random(1,3)..".wav")
            self.NextIdle = CurTime() + math.random(3,6)
        end
    end
    if self:GetActivity()==ACT_JUMP then
        if self.jumping == false then
            self:EmitSound("ambient/creatures/chicken_fly_long.wav")
            self.jumping = true
        end
    else
        self.jumping = false
    end
end

local NPC = {
	Name = "CHICKEN",
	Class = "chicken",
	Category = "CHICKEN",
	KeyValues = { SquadName = "CHICKEN" }
}
list.Set( "NPC", NPC.Class, NPC )