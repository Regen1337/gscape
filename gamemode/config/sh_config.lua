gScape = gScape or {}
gScape.config = gScape.config or {}

do
    gScape.config.character = {}
    gScape.config.inventory = {}
end

do
    gScape.config.character.startingCoins = 1000
    gScape.config.character.maxCharacters = 5

    gScape.config.character.defaultModel = "models/error.mdl"
    gScape.config.character.defaultModels = {
        "models/player/alyx.mdl",
        "models/player/barney.mdl",
        "models/player/breen.mdl",
        "models/player/eli.mdl",
        "models/player/gman_high.mdl",
        "models/player/kleiner.mdl",
        "models/player/monk.mdl",
        "models/player/mossman.mdl",
        "models/player/odessa.mdl",
        "models/player/p2_chell.mdl",
    }

    gScape.config.character.startingHealth = 100
    gScape.config.character.startingMana = 100
    gScape.config.character.startingStamina = 100
    gScape.config.character.startingHunger = 100
    gScape.config.character.startingThirst = 100

    gScape.config.character.maxHealth = 250
    gScape.config.character.maxMana = 250
    gScape.config.character.maxStamina = 100
    gScape.config.character.maxHunger = 100
    gScape.config.character.maxThirst = 100

    gScape.config.character.healthRegen = 1
    gScape.config.character.manaRegen = 1
    gScape.config.character.staminaRegen = 1
    gScape.config.character.hungerRegen = 1
    gScape.config.character.thirstRegen = 1

    gScape.config.character.healthRegenDelay = 1
    gScape.config.character.manaRegenDelay = 1
    gScape.config.character.staminaRegenDelay = 1
    gScape.config.character.hungerRegenDelay = 1
    gScape.config.character.thirstRegenDelay = 1
end

-- inventory
do
    gScape.config.inventory.maxSlots = 28
end

