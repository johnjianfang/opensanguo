-- UNITDEF -- EUF_SOLAR --
--------------------------------------------------------------------------------

local unitName = "farms"

--------------------------------------------------------------------------------

local unitDef = {
  activateWhenBuilt  = true,
  armortype          = "HEAVY",
  buildCostEnergy    = 0,
  buildCostMetal     = 160,
  buildingGroundDecalDecaySpeed = 0.2,
  buildingGroundDecalSizeX = 7,
  buildingGroundDecalSizeY = 7,
  buildingGroundDecalType = "farms_aoplane.png",
  buildTime          = 160,
  buildPic           = "farms.tga",
  category           = "LANDAIR LAND",
--  corpse             = "dead",
  customParams          = {	
	factionname		   = "imperials",
    helptext = "This is the basic energy supply."
	},
  description        = "Generates Energy",
  energyMake         = 200,
  energyStorage      = 1000,
  explodeAs          = "SMALL_EXPLOSION_YELLOW",
  footprintX         = 5,
  footprintZ         = 5,
  iconType           = "square",
  idleAutoHeal       = 0.01,
  idleTime           = 400,
  levelGround        = true,
  maxDamage          = 800,
  maxSlope           = 25,
  maxWaterDepth      = 0,
  name               = "Farms",
  nanoColor          = "0 0 0",
  noAutoFire         = false,
  objectName         = "farms.s3o",
  onoffable          = true,
  radarDistance      = 0,
  selfDestructAs     = "SMALL_EXPLOSION_YELLOW",
  showNanoFrame      = false,
  side               = "imperials",
  sightDistance      = 256,
  smoothAnim         = false,
  unitname           = "farms",
  useBuildingGroundDecal = true,  
  yardMap            = "ooooo ooooo ooooo ooooo ooooo",
  sfxtypes = {
    explosiongenerators = {
      "custom:whitesmoke",
    },
  },  
  sounds = {
    build              = "",
    canceldestruct     = "",
    repair             = "",
    underattack        = "voices_baseattacked",
    working            = "",
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
      "",
    },
    select = {
      "farms_select",
    },
  },
}


--------------------------------------------------------------------------------

--[[
local featureDefs = {
  dead = {
    blocking           = true,
	customParams          = {
		featuredecaytime		= "300"
	},  		
    damage             = 1000,
    description        = "Wrecked Solar",
    footprintX         = 5,
    footprintZ         = 5,
    height             = "30",
    hitdensity         = "100",
    metal              = 80,
    object             = "euf_solar_dead.s3o",
    reclaimable        = true,
    reclaimTime        = 40,
  },
}
unitDef.featureDefs = featureDefs
]]


--------------------------------------------------------------------------------

return lowerkeys({ [unitName] = unitDef })

--------------------------------------------------------------------------------
