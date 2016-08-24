local prefix = "maya"

if !SOUND_ADDON then
	SOUND_ADDON = {}
end

if !SOUND_ADDON["models/mark2580/borderlands2/maya_siren_player.mdl"] then
	SOUND_ADDON["models/mark2580/borderlands2/maya_siren_player.mdl"] = prefix
end

local function createtable(number, sound)
    local tablu = {}
    for i=1, number do
        tablu[i] = string.format( sound, tostring(i) )
    end
    return tablu
end

local function sounds_create(soundtable)
    for k,v  in pairs(soundtable) do
        sound.Add( {
            name = tostring(k),
            channel = CHAN_VOICE,
            volume = 1.0,
            level = SNDLVL_TALKING,
            pitch = 100,
            sound = v
        } )
    end
end

local sounds = {}
sounds[prefix..".pain"] = createtable(5, "maya/maya_pain (%s).wav")
sounds[prefix..".critpain"] = createtable(7, "maya/maya_crit (%s).wav")
sounds[prefix..".die"] = createtable(5, "maya/maya_die (%s).wav")
sounds[prefix..".kill"] = createtable(20, "maya/maya_kill (%s).wav")
sounds[prefix..".own"] = createtable(5, "maya/maya_own (%s).wav")
sounds[prefix..".empty"] = createtable(10, "maya/maya_empty (%s).wav")
sounds[prefix..".down"] = createtable(15, "maya/maya_down (%s).wav")
sounds[prefix..".healed"] = createtable(8, "maya/maya_healed (%s).wav")
sounds[prefix..".healing"] = createtable(8, "maya/maya_healing (%s).wav")
sounds[prefix..".recover"] = createtable(10, "maya/maya_recover (%s).wav")
sounds_create(sounds)