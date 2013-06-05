local unitName = "horseman"

local unitDef = {
    name = "horseman",
    Description = "Horse Warrior.",
    objectName  = "horseman.s3o",
    script = "empty.lua",
    buildPic = "HorseWarrior.jpg",
    --cost
    buildCostMetal = 10,
    buildCostEnergy = 10,
    buildTime = 5,
    --Health
    maxDamage = 2000,
    idleAutoHeal = 0,

    --Movement
    Acceleration = 0.2,
    MaxVelocity = 3.0,
    BrakeRate = 0.3,
    FootprintX = 2,
    FootprintZ = 2,
    MovementClass = "Default2x2",
    TurnRate = 900,

    sightDistance = 300,

    Category = [[LAND]],

    Builder = false,
    CanAttack = true,
    CanGuard = true,
    CanMove = true,
    CanPatrol = true,
    CanStop = true,
    LeaveTracks = false,
--[[    weapons = {
        [1]={name  = "deathraylaser",
            onlyTargetCategory = [[LAND]]--[[,
        },
    },]]
}

return lowerkeys({ [unitName] = unitDef })

