function FFYLpain(target,dmg)
	if target.InFFYL!=nil and target.InFFYL then
		dmg:ScaleDamage( 0 )
	end
end
hook.Add("EntityTakeDamage", "FFYLpain", FFYLpain)

function FFYLhurt( target, attacker, remain, damage )
	if remain!=0 and damage>=remain and tostring(attacker)!="Entity [0][worldspawn]" and !target:IsOnFire() then
		if target.LastDeath==nil then target.LastDeath = CurTime() - 11 end
		if target.DeathCount==nil then target.DeathCount = 0 end
		if CurTime()-target.LastDeath>=10 then
			target.FFYLEnd = CurTime() + 15
			target.DeathCount = 1
		else
			target.FFYLEnd = CurTime() + 15 - 5*target.DeathCount
			target.DeathCount = target.DeathCount + 1
		end
		target.LastDeath = CurTime()
		
		target:PrintMessage( HUD_PRINTCENTER,"FIGHT FOR YOUR LIFE!")
		PrintMessage( HUD_PRINTTALK, tostring(target:GetName()).." is fighting for his life!" )
		umsg.Start("ALERT")
		umsg.End()
		target.InFFYL = true
		target:ConCommand( "+duck" )
		target.NextHeal = CurTime()
		target.HealNum = 0
		target.StartedHealing = false
		target:SetHealth(1)
		target.BaseWalk = target:GetWalkSpeed()
		target.BaseRun = target:GetRunSpeed()
		target:SetWalkSpeed(50)
        if SOUND_ADDON[target:GetModel()] then
            local prefix = tostring(SOUND_ADDON[target:GetModel()])
            target:EmitSound( prefix..".down" )
        end
	end
end
local function ChatSoundFunc(um)
	surface.PlaySound("taunts/mvm.wav")
end
usermessage.Hook("ALERT", ChatSoundFunc)
hook.Add("PlayerHurt", "FFYLhurt", FFYLhurt)

function FFYLdeath( victim, weapon, killer )
	victim.InFFYL = false
	victim:ConCommand( "-duck" )
	victim:SetWalkSpeed(200)
	victim.DeathCount = nil
	victim.LastDeath = nil
end
hook.Add( "PlayerDeath", "FFYLdeath", FFYLdeath )

function  FFYLthink(v,cmd)
	for k,v in pairs(player.GetAll()) do
		if v.InFFYL then
			if CurTime()>=v.FFYLEnd then
				v:Kill()
			end
			if v.HealNum==30 then
				v.InFFYL = false
				v:ConCommand( "-duck" )
				v:SetHealth(v:GetMaxHealth()*0.5)
				v:SetWalkSpeed(v.BaseWalk)
				v:SetRunSpeed(v.BaseRun)
				v:PrintMessage( HUD_PRINTCENTER,"Revived!")
                if SOUND_ADDON[v:GetModel()] then
                    local prefix = tostring(SOUND_ADDON[v:GetModel()])
                    v:EmitSound( prefix..".healed" )
                end
			end
		end	
		local tr = v:GetEyeTrace()
		local ent = tr.Entity
		if ent==nil or !ent:IsPlayer() or !v:KeyDown(IN_USE) or v:GetPos():Distance(ent:GetPos())>=100 then return end
		if ent.InFFYL then
			if ent.HealNum==0 then
				v:PrintMessage( HUD_PRINTCENTER, "Healing "..tostring(ent:GetName()).."!")
                if SOUND_ADDON[v:GetModel()] then
                    local prefix = tostring(SOUND_ADDON[v:GetModel()])
                    v:EmitSound( prefix..".healing" )
                end
				ent:PrintMessage( HUD_PRINTCENTER, tostring(v:GetName()).." is healing you!")
				v.HealingStarted = true
			end
			ent.FFYLEnd = CurTime() + 15 - 5*ent.DeathCount
			if CurTime()>=ent.NextHeal then
				ent.NextHeal = CurTime() + 0.10
				ent.HealNum = ent.HealNum + 1
			end
		end			
	end
end
hook.Add("PlayerTick","FFYLthink", FFYLthink)


function FFYLkill( victim, killer, weapon )
	if killer:IsValid() and killer:IsPlayer() and killer.InFFYL!=nil then
		if killer.InFFYL and table.Count(player.GetAll())==1 then
			killer.InFFYL = false
			killer:ConCommand( "-duck" )
			killer:SetHealth(killer:GetMaxHealth()*0.5)
			killer:SetWalkSpeed(killer.BaseWalk)
			killer:SetRunSpeed(killer.BaseRun)
			killer:PrintMessage( HUD_PRINTCENTER,"Kill revive!")
            if SOUND_ADDON[killer:GetModel()] then
                local prefix = tostring(SOUND_ADDON[killer:GetModel()])
                killer:EmitSound( prefix..".recover" )
            end
			killer.KillHeal = true
		end
	end
end
hook.Add( "OnNPCKilled", "FFYLkill", FFYLkill )

