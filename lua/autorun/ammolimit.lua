-- The ammo limit for each ammo type, you will have to find out the additional ones
-- The ones working are listed on [url]http://wiki.garrysmod.com/?title=Player.GiveAmmo[/url]

local AMMO_TYPES = {}

AMMO_TYPES["Pistol"] = 150

AMMO_TYPES["357"] = 12

AMMO_TYPES["SMG1"] = 225

AMMO_TYPES["SMG1_Grenade"] = 3

AMMO_TYPES["AR2"] = 60

AMMO_TYPES["AR2AltFire"] = 3

AMMO_TYPES["Buckshot"] = 30

AMMO_TYPES["XBowBolt"] = 10

AMMO_TYPES["RPG_Round"] = 3

AMMO_TYPES["Grenade"] = 3

AMMO_TYPES["SLAM"] = 5

AMMO_TYPES["HelicopterGun"] = 200

AMMO_TYPES["9mmRound"] = 250

AMMO_TYPES["GaussEnergy"] = 200

AMMO_TYPES["MP5_Grenade"] = 10

AMMO_TYPES["Manhack"] = 5

hook.Add("Think", "LimitPlayerAmmo", function()
	for _,pl in pairs(player.GetAll()) do
		for k,v in pairs(AMMO_TYPES) do
			local ammo = pl:GetAmmoCount(k)
			if ammo > v then
				pl:RemoveAmmo((ammo)-v, k)
			end
		end
	end
end)