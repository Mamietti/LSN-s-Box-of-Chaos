local prefix = "gaige"

if !SOUND_ADDON then
	SOUND_ADDON = {}
end

if !SOUND_ADDON["models/mark2580/borderlands2/gaige_player.mdl"] then
	SOUND_ADDON["models/mark2580/borderlands2/gaige_player.mdl"] = prefix
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
sounds[prefix..".pain"] = createtable(5, "Gaige/gaige_pain (%s).wav")
sounds[prefix..".critpain"] = createtable(7, "Gaige/gaige_crit (%s).wav")
sounds[prefix..".die"] = createtable(5, "Gaige/gaige_die (%s).wav")
sounds[prefix..".kill"] = createtable(20, "Gaige/gaige_kill (%s).wav")
sounds[prefix..".own"] = createtable(5, "Gaige/gaige_own (%s).wav")
sounds[prefix..".empty"] = createtable(10, "Gaige/gaige_empty (%s).wav")
sounds[prefix..".down"] = createtable(15, "Gaige/gaige_down (%s).wav")
sounds[prefix..".healed"] = createtable(8, "Gaige/gaige_healed (%s).wav")
sounds[prefix..".healing"] = createtable(8, "Gaige/gaige_healing (%s).wav")
sounds[prefix..".recover"] = createtable(10, "Gaige/gaige_recover (%s).wav")
sounds_create(sounds)