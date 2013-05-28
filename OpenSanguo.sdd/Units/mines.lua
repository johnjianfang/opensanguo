-- UNITDEF -- EUF_METALEXTRACTOR_LVL1 --
--------------------------------------------------------------------------------

local unitName = "mines"

--------------------------------------------------------------------------------

local unitDef = {
  activateWhenBuilt  = true,
  armortype          = "HEAVY",
  buildCostEnergy    = 30,
  buildCostMetal     = 30,
  buildTime          = 30,
  
  buildingGroundDecalDecaySpeed = 1,
  buildingGroundDecalSizeX = 5,
  buildingGroundDecalSizeY = 5,
  buildingGroundDecalType = "mines.dds",
  useBuildingGroundDecal = true,    
  
  buildPic           = "mines.tga",
  category           = "Sanguo LANDAIR LAND",
--  corpse             = "dead",
  customParams          = {
	factionname	= "imperials",
    helptext 	= "Basic mines."
  },
  description        = "Extracts Metal",
  energyUse          = 10,
  explodeAs          = "SMALL_EXPLOSION_YELLOW",
  extractsMetal      = 0.0018,
  footprintX         = 3,
  footprintZ         = 3,
  iconType           = "square",
  idleAutoHeal       = 0.01,
  idleTime           = 400,
  levelGround        = true,  
  maxDamage          = 750,
  maxSlope           = 20,
  maxWaterDepth      = 0,
  metalStorage       = 1000,
  name               = "Metal Extractor",
  nanoColor          = "0 0 0",
  noAutoFire         = false,
  objectName         = "cube.s3o",
  onoffable          = true,
  radarDistance      = 0,
  selfDestructAs     = "blacksmoke",
  selfDestructCountdown = 0,
  showNanoFrame      = false,
  side               = "imperials",
  sightDistance      = 256,
  smoothAnim         = false,
  TEDClass           = "METAL",
  unitname           = "mines",
  yardMap            = "ooooooooo",
  sfxtypes = {
    explosiongenerators = {
      "custom:blacksmoke",
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
      "mining_select",
    },
  },
}

--------------------------------------------------------------------------------

--[[local featureDefs = {
  dead = {
    blocking           = true,
	customParams          = {
		featuredecaytime		= "300"
	},  		
    damage             = 1000,
    description        = "Wrecked Extractor",
    footprintX         = 3,
    footprintZ         = 3,
    height             = "30",
    hitdensity         = "100",
    metal              = 0,
    object             = "mines_dead.s3o",
    reclaimable        = true,
    reclaimTime        = 13,
  },
}
unitDef.featureDefs = featureDefs]]


--------------------------------------------------------------------------------

return lowerkeys({ [unitName] = unitDef })

--------------------------------------------------------------------------------
