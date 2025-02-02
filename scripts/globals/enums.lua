local mod = RepMMod

mod.RepmAchivements = {}
mod.RepmChallenges = {}

mod.RepmTypes = {}

-- Achievements
-- -- Sim
mod.RepmAchivements.SIM_LAMB = { ID = Isaac.GetAchievementIdByName("RubyChest"), Name = "Lamb"}
mod.RepmAchivements.SIM_DELIRIUM = { ID = Isaac.GetAchievementIdByName("SimDelirium"), Name = "Delirium" }

-- -- Frosty
mod.RepmAchivements.FROSTY = { ID = Isaac.GetAchievementIdByName("Frosty"), Name = "Frosty" }
mod.RepmAchivements.DEATH_CARD = { ID = Isaac.GetAchievementIdByName("FrostySatan"), Name = "Death Card" }
mod.RepmAchivements.FROZEN_HEARTS = { ID = Isaac.GetAchievementIdByName("FrozenHearts"), Name = "Frozen Hearts" }
mod.RepmAchivements.IMPROVED_CARDS = { ID = Isaac.GetAchievementIdByName("improved_cards"), Name = "Improved Cards" }
mod.RepmAchivements.NUMB_HEART = { ID = Isaac.GetAchievementIdByName("NumbHeart"), Name = "Numb Heart" }
mod.RepmAchivements.ROT = { ID = Isaac.GetAchievementIdByName("RotAch"), Name = "Rot" }

mod.RepmAchivements.FROSTY_B = { ID = Isaac.GetAchievementIdByName("Frosty_B"), Name = "Tainted Frosty" }
mod.RepmAchivements.FROSTY_B = { ID = Isaac.GetAchievementIdByName("Frosty_B"), Name = "Tainted Frosty" }

-- Challenges
mod.RepmChallenges.CHALLENGE_LOCUST_KING = Isaac.GetChallengeIdByName("Locust King")
mod.RepmChallenges.CHALLENGE_TRAFFIC_LIGHT = Isaac.GetChallengeIdByName("Traffic Light")

-- Characters
mod.RepmTypes.CHARACTER_SIM = Isaac.GetPlayerTypeByName("Sim", false)
mod.RepmTypes.CHARACTER_SIM_B = Isaac.GetPlayerTypeByName("Sim", true)

mod.RepmTypes.CHARACTER_FROSTY = Isaac.GetPlayerTypeByName("Frosty", false)
mod.RepmTypes.CHARACTER_FROSTY_B = Isaac.GetPlayerTypeByName("Tainted Frosty", true)
mod.RepmTypes.CHARACTER_FROSTY_C = Isaac.GetPlayerTypeByName("Tainted Ghost Frosty", true)

mod.RepmTypes.CHARACTER_MINUSAAC = Isaac.GetPlayerTypeByName("Minusaac", false)

-- Pickups
mod.RepmTypes.PICKUP_HEART_FROZEN = Isaac.GetEntitySubTypeByName("Frozen Heart (REP MIN)")
mod.RepmTypes.PICKUP_HEART_FROZEN_HALF = Isaac.GetEntitySubTypeByName("Frozen Heart (half) (REP MIN)")

-- Collectibles
mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY = Isaac.GetItemIdByName("Frozen Flies")
mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS = Isaac.GetItemIdByName("Friendly Rocks")
mod.RepmTypes.COLLECTIBLE_LIKE = Isaac.GetItemIdByName("Like")
mod.RepmTypes.COLLECTIBLE_FROZEN_FOOD = Isaac.GetItemIdByName("Frozen Food")
mod.RepmTypes.COLLECTIBLE_NUMB_HEART = Isaac.GetItemIdByName("Numb Heart")
mod.RepmTypes.COLLECTIBLE_BOOK_OF_TALES = Isaac.GetItemIdByName("Book of Tales")
--mod.RepmTypes.COLLECTIBLE_PRO_BACKSTABBER = Isaac.GetItemIdByName("Pro Backstabber")
mod.RepmTypes.COLLECTIBLE_ADVANCED_KAMIKAZE = Isaac.GetItemIdByName("Advanced Kamikaze")
mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE = Isaac.GetItemIdByName("Sim's Axe")
mod.RepmTypes.COLLECTIBLE_CURIOUS_HEART = Isaac.GetItemIdByName("Curious Heart")
mod.RepmTypes.COLLECTIBLE_STRAWBERRY_MILK = Isaac.GetItemIdByName("Strawberry Milk")
mod.RepmTypes.COLLECTIBLE_HOLY_SHELL = Isaac.GetItemIdByName("Holy shell")
mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET = Isaac.GetItemIdByName("Leaky Bucket")
mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH = Isaac.GetItemIdByName("Delirious Tech")
--mod.RepmTypes.COLLECTIBLE_VACUUM = Isaac.GetItemIdByName("Vacuum")
mod.RepmTypes.COLLECTIBLE_BEEG_MINUS = Isaac.GetItemIdByName("Minus")
mod.RepmTypes.COLLECTIBLE_PIXELATED_CUBE = Isaac.GetItemIdByName("Pixelated Cube")
mod.RepmTypes.COLLECTIBLE_110V = Isaac.GetItemIdByName("110V")
mod.RepmTypes.COLLECTIBLE_DILIRIUM_EYE = Isaac.GetItemIdByName("Deliriums Eye")
mod.RepmTypes.COLLECTIBLE_HOLY_OTMICHKA = Isaac.GetItemIdByName("Holy Master Key")
mod.RepmTypes.COLLECTIBLE_FLOWER_TEA = Isaac.GetItemIdByName("Flower Tea")
mod.RepmTypes.COLLECTIBLE_DEAL_OF_THE_DEATH = Isaac.GetItemIdByName("Faustian Bargain")
mod.RepmTypes.COLLECTIBLE_SANDWICH = Isaac.GetItemIdByName("Sandwich")
mod.RepmTypes.COLLECTIBLE_BOOK_OF_NECROMANCER = Isaac.GetItemIdByName("Necronomicon Vol. 3")
mod.RepmTypes.COLLECTIBLE_VHS = Isaac.GetItemIdByName("VHS Cassette")
mod.RepmTypes.COLLECTIBLE_ROT = Isaac.GetItemIdByName("Rot")
mod.RepmTypes.COLLECTIBLE_BLOODY_NEGATIVE = Isaac.GetItemIdByName("Bloody Negative")
mod.RepmTypes.COLLECTIBLE_SIREN_HORNS = Isaac.GetItemIdByName("Siren Horns")
mod.RepmTypes.COLLECTIBLE_HOW_TO_DIG = Isaac.GetItemIdByName("How To Dig")
mod.RepmTypes.COLLECTIBLE_BATTERED_LIGHTER = Isaac.GetItemIdByName("Battered Lighter")
mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER = Isaac.GetItemIdByName("Holy Lighter")
mod.RepmTypes.COLLECTIBLE_SAW_SHIELD = Isaac.GetItemIdByName("Saw Shield")
mod.RepmTypes.COLLECTIBLE_STRONG_SPIRIT = Isaac.GetItemIdByName("Strong Spirit")
mod.RepmTypes.COLLECTIBLE_PORTAL_D6 = Isaac.GetItemIdByName("Portal D6")

-- Trinkets
mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY = Isaac.GetTrinketIdByName("Pocket Technology")
mod.RepmTypes.TRINKET_MICRO_AMPLIFIER = Isaac.GetTrinketIdByName("Micro Amplifier")
mod.RepmTypes.TRINKET_FROZEN_POLAROID = Isaac.GetTrinketIdByName("Frozen Polaroid")
mod.RepmTypes.TRINKET_BURNT_CLOVER = Isaac.GetTrinketIdByName("Burnt Clover")
mod.RepmTypes.TRINKET_MORE_OPTIONS = Isaac.GetTrinketIdByName("MORE OPTIONS")
mod.RepmTypes.TRINKET_HAMMER = Isaac.GetTrinketIdByName("Hammer")
mod.RepmTypes.TRINKET_ICE_PENNY = Isaac.GetTrinketIdByName("Ice Penny")

-- Null items
mod.RepmTypes.NULL_SIRENS_SINGING = Isaac.GetNullItemIdByName("Siren's Singing")
mod.RepmTypes.NULL_MINUS_SHARD = Isaac.GetNullItemIdByName("Minus Shard")
mod.RepmTypes.NULL_MINUS_SHARD_POSITIVE_BONUS = Isaac.GetNullItemIdByName("Minus Shard Bonus Positive")
mod.RepmTypes.NULL_MINUS_SHARD_NEGATIVE_BONUS = Isaac.GetNullItemIdByName("Minus Shard Bonus Negative")
mod.RepmTypes.NULL_IMPR_REV_STRENTH = Isaac.GetNullItemIdByName("Impoved Rev. Strenght")
mod.RepmTypes.NULL_HOW_TO_DIG = Isaac.GetNullItemIdByName("How to Dig")

-- Pickups
mod.RepmTypes.EEE_CHEST = Isaac.GetEntityVariantByName("EEE Chest")
mod.RepmTypes.PICKUP_AXE = Isaac.GetEntityVariantByName("Sim Axe Pickup")

-- Cards
mod.RepmTypes.CARD_MINUS_SHARD = Isaac.GetCardIdByName("MinusShard")
mod.RepmTypes.CARD_HAMMER_CARD = Isaac.GetCardIdByName("HammerCard")

-- Pills
mod.RepmTypes.PILL_EFFECT_GROOVY = Isaac.GetPillEffectByName("Groovy")

-- Familiars
mod.RepmTypes.FAMILIAR_SAW_SHIELD = Isaac.GetEntityVariantByName("Saw Shield")

-- Slots
mod.RepmTypes.SLOT_FOUNTAIN = Isaac.GetEntityVariantByName("Fountain of Confession")

-- Effects
mod.RepmTypes.EFFECT_FROSTY_RIFT = Isaac.GetEntityVariantByName("Frosty Rift")
mod.RepmTypes.EFFECT_SAW_SHIELD_FIRE = Isaac.GetEntityVariantByName("Saw Shield Fire Effect")
mod.RepmTypes.EFFECT_SIMS_AXE = Isaac.GetEntityVariantByName("Sim Axe Active")

-- SFX
mod.RepmTypes.SFX_WIND = Isaac.GetSoundIdByName("blizz_sound")
mod.RepmTypes.SFX_LIGHTNING = Isaac.GetSoundIdByName("Thunder")
mod.RepmTypes.SFX_LIGHTER = Isaac.GetSoundIdByName("lighter_sound")
mod.RepmTypes.SFX_PICKUP_SAW_SHIELD = Isaac.GetSoundIdByName("sh_pickup")
mod.RepmTypes.SFX_SAW_SHIELD_BOUNCE = Isaac.GetSoundIdByName("sh_bounce")
mod.RepmTypes.SFX_SAW_SHIELD_CRASH = Isaac.GetSoundIdByName("sh_wall_crash")
mod.RepmTypes.SFX_SAW_SHIELD_DAMAGE = Isaac.GetSoundIdByName("sh_shredding")
mod.RepmTypes.SFX_FOUNTAIN = Isaac.GetSoundIdByName("fountain")

-- Other
mod.sawShieldReturnCooldown = 300
mod.sawShieldBounces = 5

mod.directionToVector = {
	[Direction.LEFT] = Vector(-1, 0),
	[Direction.UP] = Vector(0, -1),
	[Direction.RIGHT] = Vector(1, 0),
	[Direction.DOWN] = Vector(0, 1),
	[Direction.NO_DIRECTION] = Vector(0, 1),
}