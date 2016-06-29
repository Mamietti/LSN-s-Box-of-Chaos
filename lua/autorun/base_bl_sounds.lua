if !SOUND_ADDON then
	SOUND_ADDON = {}
end
--if !SERVER then return end

hook.Add("PlayerHurt", "GetGaigePain", function( target,attacker,remain, dmg )
	if !target:IsPlayer() or dmg<=0 then return end
	if remain!=0 and dmg<remain then
		if SOUND_ADDON[target:GetModel()] then
            local prefix = tostring(SOUND_ADDON[target:GetModel()])
			if target.NextScream==nil or CurTime()>=target.NextScream then
				if dmg<50 then
					target:EmitSound(prefix..".pain")
				else
					target:EmitSound(prefix..".critpain")						
				end
				target.NextScream = CurTime()+0.5
			end
		end
	end
    return dmginfo
end)

hook.Add( "PlayerDeath", "playerGaigeDeathTest", function( victim, weapon, killer )
    if SOUND_ADDON[victim:GetModel()] then
        local prefix = tostring(SOUND_ADDON[victim:GetModel()])
		sound.Play( prefix..".die", victim:GetPos(), 100, 100 )
	end
end )

hook.Add( "OnNPCKilled", "playerGaigeHappyTest", function( victim, owner, weapon )
	if owner!=nil then
        if owner:GetModel()!=nil and SOUND_ADDON[owner:GetModel()] then
            local prefix = tostring(SOUND_ADDON[owner:GetModel()])
            if owner.NextKill==nil then
                owner.NextKill = CurTime()
            end
            if owner.NextKill!=nil and CurTime()>owner.NextKill then
                if victim:GetMaxHealth()==nil or victim:GetMaxHealth()<150 then
                    if math.random(1,2)==1 then
                        owner:EmitSound(prefix..".kill")
                        owner.NextKill = CurTime() + SoundDuration(prefix..".kill") + 0.1
                    else
                        owner.NextKill = CurTime()+ 0.1
                    end
                else
                    owner:EmitSound(prefix..".own")
                    owner.NextKill = CurTime()+ SoundDuration(prefix..".own") + 0.1
                end
            else
                owner.NextKill = CurTime()+ 0.1
            end
        end
	end
end )

hook.Add("PlayerTick","GetGaigeReload", function(v,cmd)
	if v:Health()<=0 then return end
    if v.NextTell==nil then v.NextTell = CurTime() end
    if CurTime()>=v.NextTell then
        if SOUND_ADDON[v:GetModel()] then
            local prefix = tostring(SOUND_ADDON[v:GetModel()])
            local gun = v:GetActiveWeapon()
            if v:KeyPressed(IN_RELOAD) and !v:KeyDown(IN_USE) and !gun:HasAmmo() and gun:Clip1() and gun:Clip1()!=(-1) then
                v:EmitSound(prefix..".empty")
                v.NextTell = CurTime() + SoundDuration(prefix..".empty")
            end
        end
    end
end)