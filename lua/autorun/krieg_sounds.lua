--include("gaige_sounds.lua")
if !SOUND_ADDON then
	SOUND_ADDON = {}
end

if !SOUND_ADDON["models/mark2580/borderlands2/psycho_krieg_player.mdl"] then
	SOUND_ADDON["models/mark2580/borderlands2/psycho_krieg_player.mdl"] = "Krieg"
end

sound.Add( {
	name = "Krieg.Pain",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = 100,
	sound = {
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_01.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_02.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_03.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_04.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_05.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_06.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_07.wav"
	}
} )

sound.Add( {
	name = "Krieg.CritPain",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = 100,
	sound = {
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_01.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_02.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_03.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_04.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_05.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_06.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_07.wav"
	}
} )

sound.Add( {
	name = "Krieg.Die",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = 100,
	sound = {
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_01.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_02.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_03.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_04.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_05.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_06.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_GEN_React_Pain_07.wav"
	}
} )

sound.Add( {
	name = "Krieg.Kill",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = 100,
	sound = {
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_01.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_02.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_03.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_04.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_05.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_06.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_07.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_08.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_09.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_10.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_11.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_12.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_13.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_14.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_15.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_16.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_17.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_18.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_19.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Gib_Enemy_20.wav"
	}
} )

sound.Add( {
	name = "Krieg.Own",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = 100,
	sound = {
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_01.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_02.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_03.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_04.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_05.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_06.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_07.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_08.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_09.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_10.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_11.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_12.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Kill_Badass_13.wav"
	}
} )

sound.Add( {
	name = "Krieg.Empty",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = 100,
	sound = {
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Ammo_Out_01.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Ammo_Out_02.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Ammo_Out_03.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Ammo_Out_04.wav",
	"krieg/Processed_VOBD_Lilac_PlayPsycho_PL_React_Ammo_Out_05.wav"
	}
} )