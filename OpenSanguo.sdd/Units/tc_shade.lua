--------------------------------------------------------------------------------

local unitName = "tc_shade"

--------------------------------------------------------------------------------

local unitDef = {
  name               = "Shade (Hero)",
  Description        = "Hero",
  objectName         = "tc_shade.s3o",
--  script             = 'tc_shade.lua',
  script             = 'tc_shade_advanced.lua',
  buildPic           = "swordwarrior.jpg",
  --cost
  buildCostMetal     = 0,
  buildCostEnergy    = 100,
  buildTime          = 20,
  --Health
  mass               = 3000,
  maxDamage          = 1800,
  idleAutoHeal       = 2.5,
  idleTime           = 400,
  --Movement
  Acceleration       = 1.0,
  BrakeRate          = 1.0,
  FootprintX         = 3,
  FootprintZ         = 3,
  MaxSlope           = 25,
  MaxVelocity        = 3.7,
  MaxWaterDepth      = 12,
  MovementClass      = "Trooper3X3",
--  MovementClass      = "Default3x3",
  TurnRate           = 2500,

  sightDistance      = 512,

  Builder = false,
  CanAttack = true,
  CanGuard = true,
  CanMove = true,
  CanPatrol = true,
  CanStop = true,
  LeaveTracks = false,

  Category = [[LAND]],

  --Hitbox
  collisionVolumeTest 		= 1,
  collisionVolumeOffsets 	= "[[0 0 0]]",
  collisionVolumeType 		= "CylY",
  collisionVolumeScales 	= "[[22 35 22]]",

  armortype          = "LIGHT",
  badTargetCategory  = "AIR",
  nanoColor          = "0 0 0",
  showNanoFrame      = false,
  noChaseCategory    = "AIR",
  smoothAnim         = true,
  upright            = true,
  iconType           = "circle",

  weapons = {
      [1]  = {
          def                = "SWORD",
          mainDir            = "0 0 1",
          maxAngleDif        = 180,
          onlyTargetCategory = "LAND",
      },
  },

  sounds = {
    canceldestruct     = "",
   underattack        = "shade_underatk",
    arrived = {
      "",
    },
    cant = {
      "",
    },
    count = {
      "",
      "",
      "",
      "",
      "",
      "",
    },
    ok = {
      "shade_move",
    },
    select = {
      "shade_select",
    },
  },
}

local weaponDefs = {
    SWORD = {
        areaOfEffect       = 32,
        avoidFriendly      = 0,
        collideFriendly    = false,
        craterBoost        = 1,
        craterMult         = 2,
        cylinderTargeting = 1,
        energypershot           = 0,
        endsmoke           = "0",
--        explosionGenerator = "custom:NONE",
        explosionGenerator = "custom:muzzleflash",
        explosionScar	= false,
        impactonly         = true,
        interceptedByShieldType = 2,
        lineOfSight        = false,
        name               = "Shade Swords",
        noSelfDamage       = true,
        range              = 55,
        reloadtime         = 0.7,
        size               = 0,
        startsmoke         = 0,
        targetBorder       = 1,
        tolerance          = 5000,
        turret             = true,
        waterWeapon        = true,
        weaponTimer        = 0.1,
        weaponType         = "Cannon",
        weaponVelocity     = 250,
        damage = {
            default            = 150,
            flyer              = 150,
            heavy              = 150,
            light              = 150,
        },
    },
}
unitDef.weaponDefs = weaponDefs

--------------------------------------------------------------------------------

return lowerkeys({ [unitName] = unitDef })

--------------------------------------------------------------------------------
