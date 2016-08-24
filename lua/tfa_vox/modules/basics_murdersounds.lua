if !MODULE then TFAVOX_Modules_Initialize() return end

MODULE.name = "Basics - Murder Sounds"
MODULE.description = "Plays a sound when a player murders"
MODULE.author = "TFA"
MODULE.realm = "shared"
MODULE.options = {
	["chance"] = { 
		["name"] = "Sound Chance",
		["description"] = "X% chance to play a murder sound",
		["type"] = "integer",
		["min"] = 0,
		["max"] = 100,
		["default"] = 50
	},
	["doplayers"] = { 
		["name"] = "Player on Player Kills",
		["description"] = "Do sounds play when a player murders another player?",
		["type"] = "bool",
		["default"] = true
	},
	["donpcs"] = { 
		["name"] = "Player on NPC Kills",
		["description"] = "Do sounds play when a player murders a NPC?",
		["type"] = "bool",
		["default"] = true
	}
}

local TFAVOX_NPCTypes = {
	--combine
	["npc_turret_ceiling"] = "turret",
	["npc_cscanner"] = "scanner",
	["npc_combinedropship"] = "combine",
	["npc_combine_s"] = "combine",
	["npc_combinegunship"] = "combine",
	["npc_cremato2"] = "combine",
	["npc_cremator"] = "combine",
	["npc_hunter"] = "combine",
	["npc_helicopter"] = "combine",
	["npc_manhack"] = "manhack",
	["npc_metropolice"] = "cp",
	["npc_rollermine"] = "combine",
	["npc_clawscanner"] = "scanner",
	["npc_stalker"] = "scanner",
	["npc_strider"] = "scanner",
	["npc_turret_floor"] = "turret",
    --allies
	["npc_alyx"] = "ally",
	["npc_barney"] = "ally",
	["npc_eli"] = "ally",
	["npc_kleiner"] = "ally",
	["npc_citizen"] = "ally",
    --hl1
	["monster_babycrab"] = "headcrab",
	["monster_headcrab"] = "ally",
	["monster_zombie"] = "zombie",
	["monster_scientist"] = "ally",
	["monster_barney"] = "ally",
	["monster_turret"] = "turret",
	["monster_miniturret"] = "turret",
	["monster_sentry"] = "turret",
	--zombies
	["npc_headcrab_fast"] = "headcrab",
	["npc_headcrab_poison"] = "headcrab",
	["npc_headcrab"] = "headcrab",
	["npc_fastzombie"] = "zombie",
	["npc_poisonzombie"] = "zombie",
	["npc_zombie"] = "zombie",
	["npc_fastzombie_torso"] = "zombie",
	["npc_zombie_torso"] = "zombie",
	["npc_zombine"] = "zombie",
}

hook.Add("TFAVOX_InitializePlayer","TFAVOX_MurderIP",function(ply)
	
	if IsValid(ply) then
		local mdtbl = TFAVOX_Models[ply:GetModel()]
		if mdtbl and mdtbl.murder then
			
			ply.TFAVOX_Sounds = ply.TFAVOX_Sounds or {}
			
			ply.TFAVOX_Sounds['murder'] = TFAVOX_FullCopy( mdtbl.murder )
			
		end
	end
	
end)
	
function TFAVOX_MurderCheck( target, attacker)	
	if IsValid(attacker) and attacker.IsPlayer and attacker:IsPlayer() and attacker.TFAVOX_Sounds and attacker.TFAVOX_Sounds['murder'] then
		local ply = attacker
		if TFAVOX_IsValid(ply) and ply:Alive() then
			if ply.TFAVOX_Sounds and ply.TFAVOX_Sounds.murder then
				
				local sndtbl = ply.TFAVOX_Sounds.murder[ target:IsNPC() and ( TFAVOX_NPCTypes[ target:GetClass() ] or "generic" ) or "generic" ] or ply.TFAVOX_Sounds.murder[ "generic" ]
				
				local sndinner = TFAVOX_GetSoundTableSound(sndtbl)
				
				if !sndinner then
					sndtbl = ply.TFAVOX_Sounds.murder[ "generic" ]
				end
				
				if sndtbl then
					
					TFAVOX_PlayVoicePriority( ply, sndtbl, 0 )
					
				end
				
			end
		end			
	end
end

--local killsoundchancecvar

hook.Add("OnNPCKilled","TFAVOX_NPC_Murder",function(npc,attacker,inflictor)
	
	--if !killsoundchancecvar then killsoundchancecvar = GetConVar("sv_tfa_vox_killsound_chance") end
	
	--if math.random(1,100)<=killsoundchancecvar:GetInt() then
	
	if not ( ( self.options["donpcs"].value ) or (  self.options["donpcs"].value == nil and  self.options["donpcs"].default ) ) then
		return
	end
	
	if !IsValid(attacker) then return end
	
	if math.random(1,100)<= ( self.options["chance"].value or self.options["chance"].default ) then
	
		if attacker:IsWeapon() and IsValid(attacker.Owner) then attacker = attacker.Owner end
	
		TFAVOX_MurderCheck(npc,attacker)
	
	end
	
	--end
end)

hook.Add("DoPlayerDeath","TFAVOX_PLY_Murder",function(victim,attacker,dmginfo)
	
	--if !killsoundchancecvar then killsoundchancecvar = GetConVar("sv_tfa_vox_killsound_chance") end
	
	if not ( ( self.options["doplayers"].value ) or (  self.options["doplayers"].value == nil and  self.options["doplayers"].default ) ) then
		return
	end
	
	if !IsValid(attacker) then return end
	
	if math.random(1,100)<= ( self.options["chance"].value or self.options["chance"].default ) then
		if attacker==victim then return end
		if attacker:IsWeapon() and IsValid(attacker.Owner) then attacker = attacker.Owner end
		
		TFAVOX_MurderCheck(victim,attacker)
	
	end
end)