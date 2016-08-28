--Written by TFA's Exporter
--Place in lua\tfa_vox\packs\
TFAVOX_Models = TFAVOX_Models or {}
TFAVOX_Models["models/player/engieplayer/engie.mdl"] = {
	['taunt'] = {
		[1610] = {
			['sound'] = 'PlayerTauntAgree.Engineer'
		},
		[1618] = {
			['sound'] = 'PlayerTauntLaugh.Engineer'
		},
		[53] = {
			['sound'] = 'PlayerTauntForward.Engineer'
		},
		[1617] = {
			['sound'] = 'PlayerTauntMuscle.Engineer'
		},
		[1620] = {
			['sound'] = 'PlayerTauntCheer.Engineer'
		},
		[1613] = {
			['sound'] = 'PlayerTauntDisAgree.Engineer'
		},
		[1611] = {
			['sound'] = 'PlayerTauntBecon.Engineer'
		}
	},
	['murder'] = {
		['turret'] = {
			['sound'] = 'PlayerMurderRobot.Engineer',
			['delay'] = 3
		},
		['zombie'] = {
			['sound'] = 'PlayerMurderZombie.Engineer',
			['delay'] = 3
		},
		['generic'] = {
			['sound'] = 'PlayerMurder.Engineer',
			['delay'] = 3
		},
		['headcrab'] = {
			['sound'] = 'PlayerMurder.Engineer',
			['delay'] = 3
		},
		['ally'] = {
			['sound'] = 'PlayerNoAmmo.Engineer',
			['delay'] = 3
		},
		['manhack'] = {
			['sound'] = 'PlayerMurderRobot.Engineer',
			['delay'] = 3
		},
		['cp'] = {
			['sound'] = 'PlayerMurder.Engineer',
			['delay'] = 3
		},
		['combine'] = {
			['sound'] = 'PlayerMurderCombine.Engineer',
			['delay'] = 3
		},
		['scanner'] = {
			['sound'] = 'PlayerMurderRobot.Engineer',
			['delay'] = 3
		},
		['sniper'] = {
			['sound'] = 'PlayerMurderSniper.Engineer',
			['delay'] = 3
		}
	},
	['main'] = {
		['spawn'] = {
			['sound'] = 'PlayerSpawn.Engineer'
		},
		['pickup'] = {
			['sound'] = 'PlayerPickUp.Engineer'
		},
		['healmax'] = {
			['sound'] = 'PlayerHealedMax.Engineer'
		},
		['death'] = {
			['sound'] = 'PlayerDeath.Engineer'
		},
		['crithit'] = {
			['sound'] = 'PlayerCritHP.Engineer',
			['delay'] = {
				[1] = 3.5,
				[2] = 5
			}
		},
		['noammo'] = {
			['sound'] = 'PlayerNoAmmo.Engineer'
		}
	},
	['damage'] = {
		[0] = {
			['sound'] = 'PlayerDamage.Engineer',
			['delay'] = {
				[1] = 1,
				[2] = 2
			}
		},
		[2] = {
			['sound'] = 'PlayerDamage.Engineer',
			['delay'] = 1
		},
		[5] = {
			['sound'] = 'PlayerDamage.Engineer',
			['delay'] = {
				[1] = 1,
				[2] = 2
			}
		},
		[4] = {
			['sound'] = 'PlayerDamage.Engineer',
			['delay'] = 1
		},
		[10] = {
			['sound'] = 'PlayerDamage.Engineer',
			['delay'] = {
				[1] = 1,
				[2] = 2
			}
		},
		[3] = {
			['sound'] = 'PlayerDamage.Engineer',
			['delay'] = 1
		},
		[7] = {
			['sound'] = 'PlayerDamage.Engineer',
			['delay'] = 1
		},
		[1] = {
			['sound'] = 'PlayerDamage.Engineer',
			['delay'] = 1
		},
		[6] = {
			['sound'] = 'PlayerDamage.Engineer',
			['delay'] = 1
		}
	},
	['spot'] = {
		['turret'] = {
			['sound'] = 'PlayerEnemyTurret.Engineer'
		},
		['zombie'] = {
			['sound'] = 'PlayerEnemyZombie.Engineer'
		},
		['generic'] = {
			['sound'] = 'PlayerIncoming.Engineer'
		},
		['headcrab'] = {
			['sound'] = 'PlayerIncoming.Engineer'
		},
		['ally'] = {
			['sound'] = 'PlayerAlly.Engineer',
			['delay'] = 2
		},
		['manhack'] = {
			['sound'] = 'PlayerIncoming.Engineer'
		},
		['cp'] = {
			['sound'] = 'PlayerIncoming.Engineer'
		},
		['combine'] = {
			['sound'] = 'PlayerIncoming.Engineer'
		},
		['scanner'] = {
			['sound'] = 'PlayerIncoming.Engineer'
		},
		['sniper'] = {
			['sound'] = 'PlayerEnemySniper.Engineer'
		}
	},
	['callouts'] = {
		['agree'] = {
			['name'] = "Agree",
			['sound'] = 'PlayerTauntAgree.Engineer'
		},
		['disagree'] = {
			['name'] = "Disagree",
			['sound'] = 'PlayerTauntDisagree.Engineer'
		},
		['thanks'] = {
			['name'] = "Thanks",
			['sound'] = 'PlayerThanks.Engineer'
		},	
		['gratfriend'] = {
			['name'] = "Goodjob",
			['sound'] = 'PlayerCongratulate.Engineer'
		},
		['help'] = {
			['name'] = "Help!",
			['sound'] = 'PlayerHelp.Engineer'
		},
		['reqheal'] = {
			['name'] = "Medic!",
			['sound'] = 'PlayerReqHealing.Engineer'
		},
		['laugh'] = {
			['name'] = "Laugh",
			['sound'] = 'PlayerLaugh.Engineer'
		},
		['incoming'] = {
			['name'] = "Incoming",
			['sound'] = 'PlayerIncoming.Engineer'
		},
		['jeers'] = {
			['name'] = "Jeers",
			['sound'] = 'PlayerJeers.Engineer'
		}
	}
}

--EnemyDetect-- 

sound.Add( {
	name = "PlayerEnemyZombie.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_autodejectedtie01.mp3", "vo/engineer_autodejectedtie02.mp3", "vo/taunts/engineer_taunts08.mp3" }
} )

sound.Add( {
	name = "PlayerEnemySniper.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_mvm_sniper01.mp3" }
} )

sound.Add( {
	name = "PlayerEnemyTurret.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_sentryahead01.mp3", "vo/engineer_sentryahead02.mp3" }
} )

sound.Add( {
	name = "PlayerAlly.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = {}
} )
--end--
--CustomTaunts--
sound.Add( {
	name = "PlayerTauntAgree.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_yes01.mp3","vo/engineer_yes02.mp3", "vo/engineer_yes03.mp3"}
} )

sound.Add( {
	name = "PlayerTauntDisAgree.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_no01.mp3", "vo/engineer_no02.mp3", "vo/engineer_no03.mp3" }
} )

sound.Add( {
	name = "PlayerTauntForward.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_go01.mp3", "vo/engineer_go02.mp3", "vo/engineer_go03.mp3" }
} )

sound.Add( {
	name = "PlayerTauntCheer.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = {"vo/engineer_cheers01.mp3", "vo/engineer_cheers02.mp3", "vo/engineer_cheers03.mp3", "vo/engineer_cheers04.mp3", "vo/engineer_cheers05.mp3", "vo/engineer_cheers06.mp3", "vo/engineer_cheers07.mp3"}
} )

sound.Add( {
	name = "PlayerTauntLaugh.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_laughlong01.mp3", "vo/engineer_laughlong02.mp3"}
} )

sound.Add( {
	name = "PlayerTauntDance.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { }
} )

sound.Add( {
	name = "PlayerTauntMuscle.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = {}
} )

--end--

--Basics--

sound.Add( {
	name = "PlayerHelp.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_helpme01.mp3", "vo/engineer_helpme02.mp3", "vo/engineer_helpme03.mp3" }
} )

sound.Add( {
	name = "PlayerReqHealing.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_medic01.mp3", "vo/engineer_medic02.mp3", "vo/engineer_medic03.mp3" }
} )

sound.Add( {
	name = "PlayerIncoming.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_incoming01.mp3", "vo/engineer_incoming02.mp3", "vo/engineer_incoming03.mp3", "vo/engineer_mvm_wave_start01.mp3" }
} )
sound.Add( {
	name = "PlayerJeers.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = {"vo/engineer_jeers01.mp3", "vo/engineer_jeers02.mp3", "vo/engineer_jeers03.mp3", "vo/engineer_jeers04.mp3", "vo/engineer_jeers05.mp3", "vo/engineer_jeers06.mp3", "vo/engineer_jeers07.mp3"}
} )
sound.Add( {
	name = "PlayerCongratulate.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_goodjob01.mp3", "vo/engineer_goodjob02.mp3", "vo/engineer_goodjob03.mp3" }
} )
sound.Add( {
	name = "PlayerThanks.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_thanks01.mp3" }
} )
sound.Add( {
	name = "PlayerLaugh.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_laughshort01.mp3", "vo/engineer_laughshort02.mp3", "vo/engineer_laughshort03.mp3", "vo/engineer_laughshort04.mp3", "vo/engineer_laughevil01.mp3", "vo/engineer_laughevil02.mp3", "vo/engineer_laughevil03.mp3",
                "vo/engineer_laughevil04.mp3", "vo/engineer_laughevil05.mp3", "vo/engineer_laughevil06.mp3"
    }
} )
sound.Add( {
	name = "PlayerNoAmmo.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_negativevocalization01.mp3", "vo/engineer_negativevocalization02.mp3", "vo/engineer_negativevocalization03.mp3", "vo/engineer_negativevocalization04.mp3", "vo/engineer_negativevocalization05.mp3",
            "vo/engineer_negativevocalization06.mp3", "vo/engineer_negativevocalization07.mp3", "vo/engineer_negativevocalization08.mp3", "vo/engineer_negativevocalization09.mp3", "vo/engineer_negativevocalization10.mp3",
            "vo/engineer_negativevocalization11.mp3", "vo/engineer_negativevocalization12.mp3"
    }
} )

sound.Add( {
	name = "PlayerSpawn.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_battlecry01.mp3", "vo/engineer_battlecry03.mp3", "vo/engineer_battlecry04.mp3", "vo/engineer_battlecry05.mp3", "vo/engineer_battlecry06.mp3", "vo/engineer_battlecry07.mp3"} --, "vo/Engineer/Engineer_reingaging.wav" 
} )

sound.Add( {
	name = "PlayerDeath.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_paincrticialdeath01.mp3", "vo/engineer_paincrticialdeath02.mp3", "vo/engineer_paincrticialdeath03.mp3","vo/engineer_paincrticialdeath04.mp3", "vo/engineer_paincrticialdeath05.mp3", "vo/engineer_paincrticialdeath06.mp3" }
} )

sound.Add( {
	name = "PlayerDamage.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_painsharp01.mp3", "vo/engineer_painsharp02.mp3", "vo/engineer_painsharp03.mp3", "vo/engineer_painsharp04.mp3", "vo/engineer_painsharp05.mp3", "vo/engineer_painsharp06.mp3", "vo/engineer_painsharp07.mp3", "vo/engineer_painsharp08.mp3" }
} )

sound.Add( {
	name = "PlayerMurder.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_specialcompleted01.mp3", "vo/engineer_specialcompleted05.mp3", "vo/engineer_specialcompleted07.mp3", "vo/engineer_specialcompleted10.mp3", "vo/engineer_specialcompleted11.mp3",
            "vo/engineer_wranglekills02.mp3", "vo/engineer_wranglekills03.mp3", "vo/engineer_wranglekills04.mp3",
            "vo/engineer_revenge01.mp3", "vo/engineer_revenge02.mp3"
    }	  
} )

sound.Add( {
	name = "PlayerMurderSniper.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_dominationsniper01.mp3", "vo/engineer_dominationsniper02.mp3", "vo/engineer_dominationsniper03.mp3", "vo/engineer_dominationsniper04.mp3", "vo/engineer_dominationsniper05.mp3", "vo/engineer_dominationsniper07.mp3" }
} )

sound.Add( {
	name = "PlayerMurderZombie.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_dominationpyro04.mp3", "vo/engineer_dominationpyro06.mp3", "vo/engineer_dominationpyro01.mp3", "vo/engineer_dominationheavy09.mp3", "vo/engineer_dominationheavy14.mp3", "vo/engineer_dominationspy06.mp3", "vo/engineer_dominationspy07.mp3" }	  
} )

sound.Add( {
	name = "PlayerMurderRobot.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_mvm_robot_sapped01.mp3", "vo/engineer_mvm_robot_sapped02.mp3", "vo/engineer_mvm_taunt01.mp3", "vo/engineer_mvm_taunt02.mp3", "vo/engineer_mvm_wave_end03.mp3","vo/engineer_mvm_wave_end04.mp3" }	  
} )

sound.Add( {
	name = "PlayerMurderCombine.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_dominationsoldier02.mp3", "vo/engineer_dominationsoldier03.mp3", "vo/engineer_dominationsoldier05.mp3", "vo/engineer_dominationsoldier06.mp3", "vo/engineer_dominationsoldier07.mp3", "vo/engineer_dominationsoldier08.mp3" }	  
} )

sound.Add( {
	name = "PlayerCritHP.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_painsevere01.mp3", "vo/engineer_painsevere02.mp3", "vo/engineer_painsevere03.mp3", "vo/engineer_painsevere04.mp3", "vo/engineer_painsevere05.mp3", "vo/engineer_painsevere06.mp3", "vo/engineer_painsevere07.mp3" }
} )

sound.Add( {
	name = "PlayerPickup.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_mvm_loot_common01.mp3", "vo/engineer_mvm_loot_common02.mp3", "vo/engineer_mvm_loot_rare01.mp3", "vo/engineer_mvm_loot_rare02.mp3", "vo/engineer_mvm_loot_rare03.mp3", "vo/engineer_mvm_loot_rare04.mp3" }
} )

sound.Add( {
	name = "PlayerHealedMax.Engineer",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = SNDLVL_TALKING,
	pitch = PITCH_NORM,
	sound = { "vo/engineer_mvm_get_upgrade01.mp3", "vo/engineer_mvm_get_upgrade01.mp3"}
} )