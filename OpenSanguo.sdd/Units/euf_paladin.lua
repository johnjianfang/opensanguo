-- UNITDEF -- euf_paladin --
--------------------------------------------------------------------------------

local unitName = "euf_paladin"

--------------------------------------------------------------------------------

local unitDef = {
  acceleration       = 1.5,
  armortype          = "LIGHT",
  badTargetCategory  = "AIR",
  brakeRate          = 1.5,
  buildCostEnergy    = 50,
  buildCostMetal     = 50,
  buildPic           = "euf_paladin.png",
  buildTime          = 50,
  canAttack          = true,
  canGuard           = true,
  canMove            = true,
  canPatrol          = true,
  canstop            = "1",
  category           = "EUF LAND LANDAIR HEAVYARMOR",
  corpse             = "dead",
  collisionVolumeOffsets 	= "0 0 0",
  collisionVolumeScales 	= "25 33 25",
  collisionVolumeType 		= "CylY",
  -- collisionVolumeTest 		= 1,
--[[  customParams          = {
  	factionname		   = "imperials",
	RequireTech         = "Factory",
    helptext 	= "Fast melee unit. It has the aura of thorns (hurts nearby enemies) as long as a sanctum exists."
 }, ]]
  defaultmissiontype = "Standby",
  description        = "Fast Melee Unit. Prerequisite: War Factory",
  energyMake         = "-2",
--  explodeAs          = "BLOOD_EXPLOSION",
  firestandorders    = "1",
  footprintX         = 2,
  footprintZ         = 2,
  iconType           = "circle",
  idleAutoHeal       = 2.5,
  idleTime           = 400,
  
  crushResistance    = 500,
  mass               = 275,
    
  maxDamage          = 1800,
  maxSlope           = 14,
  maxVelocity        = 3,
  maxWaterDepth      = 12,
  mobilestandorders  = "1",
  movementClass      = "Trooper2X2",
  name               = "Paladin",
  nanoColor          = "0 0 0",
  noAutoFire         = false,
  noChaseCategory    = "AIR",
  objectName         = "euf_paladin.s3o",
  radarDistance      = 512,
  script             = 'euf_paladin.lua',  
  selfDestructAs     = "BLOOD_EXPLOSION",
  showNanoFrame      = false,
--  side               = "imperials",
  sightDistance      = 512,
  smoothAnim         = true,
  standingfireorder  = "2",
  standingmoveorder  = "2",
  turnRate           = 2500,
  unitname           = "euf_paladin",
  upright            = true,
--[[  sfxtypes = {
    explosiongenerators = {
      "custom:BLOOD_EXPLOSION",
      "custom:blood_spray",
      "custom:SPARKLES",	  
    },
  },]]
  sounds = {
    canceldestruct     = "",
    underattack        = "pala3",
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
      "pala2",
    },
    select = {
      "pala1",
    },
  },
  weapons = {
    [1]  = {
      def                = "SWORD",
      mainDir            = "0 0 1",
      maxAngleDif        = 180,
      onlyTargetCategory = "LAND",
    },
  },
}


--------------------------------------------------------------------------------

local weaponDefs = {
  SWORD = {
    areaOfEffect       = 32,
    avoidFriendly      = 0,
    collideFriendly    = false,
    craterBoost        = 1,
    craterMult         = 2,
	cylinderTargeting  = 1,
    energypershot      = 0,
    endsmoke           = "0",
    explosionGenerator = "custom:muzzleflash",
	explosionScar	= false,	
    impactonly         = true,
    interceptedByShieldType = 2,
    lineOfSight        = false,
    name               = "Melee",
    noSelfDamage       = true,
    range              = 55,
    reloadtime         = 2,
    size               = 0,
    startsmoke         = 0,
    targetBorder       = 1,
    tolerance          = 5000,
    turret             = true,
    waterWeapon        = true,
    weaponTimer        = 0.1,
    weaponType         = "Cannon",
    weaponVelocity     = 100,
    damage = {
      default            = 220,
      flyer              = 220,
      heavy              = (220*0.75),
      light              = 220,
    },
  },
}
unitDef.weaponDefs = weaponDefs


--------------------------------------------------------------------------------

local featureDefs = {
  dead = {
    blocking           = false,
--[[	customParams          = {
		resurrectintounit	= "tc_skeleton",
		featuredecaytime	= "60"		
	},  ]]
    damage             = 300,
    description        = "Dead Paladin",
    energy             = 0,
    footprintX         = 2,
    footprintZ         = 2,
    height             = "5",
    hitdensity         = "100",
    metal              = 0,
    object             = "euf_paladin_dead.s3o",
    reclaimable        = false,
	smoketime 		   = 0,	
  },
}
unitDef.featureDefs = featureDefs

--------------------------------------------------------------------------------

return lowerkeys({ [unitName] = unitDef })

--------------------------------------------------------------------------------
