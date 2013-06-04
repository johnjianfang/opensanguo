--------------------------------------------------------------------------------

local unitName = "tc_shade"

--------------------------------------------------------------------------------

local unitDef = {
  name               = "Shade (Hero)",
  Description        = "Hero",
  objectName         = "tc_shade.s3o",
  script             = 'tc_shade.lua',
  buildPic           = "tc_shade.jpg",
  --cost
  buildCostMetal     = 0,
  buildCostEnergy    = 100,
  buildTime          = 20,
  --Health
  maxDamage          = 1800,
  idleAutoHeal       = 2.5,
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


--------------------------------------------------------------------------------

return lowerkeys({ [unitName] = unitDef })

--------------------------------------------------------------------------------
