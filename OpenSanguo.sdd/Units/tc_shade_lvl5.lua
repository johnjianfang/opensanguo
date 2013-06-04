--------------------------------------------------------------------------------

local unitName = "tc_shade_lvl5"

--------------------------------------------------------------------------------

local unitDef = {
  acceleration       = 1.0,
  armortype          = "LIGHT",
  badTargetCategory  = "AIR",
  brakeRate          = 1.0,
  buildCostEnergy    = 500,
  buildCostMetal     = 500,
  buildPic           = "tc_shade.jpg",
  buildTime          = 500,
  canAttack          = true,
  canGuard           = true,
  canMove            = true,
  canPatrol          = true,
  canstop            = "1",
  category           = "CURSED LAND LANDAIR HEAVYARMOR",
  collisionVolumeOffsets 	= "0 0 0",
  collisionVolumeScales 	= "22 35 22",
  collisionVolumeType 		= "CylY",
  -- collisionVolumeTest 		= 1,
  customParams          = {
  	factionname		   = "cursed",
    canjump        = "1",
	jumpclass = "hero",	
	ProvideTech = "-Hero, 1 Decoy",		
	normaltex = "unittextures/normalmaps/tc_shade_normal.png",
	normalmaps = "yes",		
    helptext 	= "The Shade is a cursed damage dealer class hero."
 },  
  defaultmissiontype = "Standby",
  description        = "Hero",
  energyMake         = "",
  explodeAs          = "BLOOD_EXPLOSION",
  firestandorders    = "1",
  footprintX         = 3,
  footprintZ         = 3,
  iconType           = "circle",
  idleAutoHeal       = 2.5,
  idleTime           = 400,
  mass               = 3000,
  maxDamage          = 4400,
  maxSlope           = 25,
  maxVelocity        = 4.1,
  maxWaterDepth      = 12,
  mobilestandorders  = "1",
  movementClass      = "Trooper3X3",
  name               = "Shade (Level 5)",
  nanoColor          = "0 0 0",
  noAutoFire         = false,
  noChaseCategory    = "AIR",
  objectName         = "tc_shade.s3o",
  radarDistance      = 512,
  script             = 'tc_shade_advanced.lua',
  selfDestructAs     = "BLOOD_EXPLOSION",
  showNanoFrame      = false,
  side               = "cursed",
  sightDistance      = 512,
  smoothAnim         = true,
  standingfireorder  = "2",
  standingmoveorder  = "2",
  turnRate           = 2500,
  turnInPlace        = true,
  unitname           = "tc_shade_lvl5",
  upright            = true,
  ---- builder ----
  builder            = true,
  buildDistance      = 300,
  showNanoSpray      = false,
  workerTime         = 30,  
  buildoptions = {    "tc_decoyshade",  },    
  -----------------
  sfxtypes = {
    explosiongenerators = {
      "custom:REDGREENBLOOD_EXPLOSION",
      "custom:blood_spray",
      "custom:SPARKLES",
      "custom:smokescreen",
	  "custom:LEVELING",	  
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
	cylinderTargeting = 1,
      energypershot           = 0,
    endsmoke           = "0",
    explosionGenerator = "custom:NONE",
	explosionScar	= false,	
    impactonly         = true,
    interceptedByShieldType = 2,
    lineOfSight        = false,
    name               = "Shade Swords",
    noSelfDamage       = true,
    range              = 55,
    reloadtime         = 0.75,
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
      default            = 575,
      flyer              = 575,
      heavy              = 575,
      light              = 575,
    },
  },
}
unitDef.weaponDefs = weaponDefs

--------------------------------------------------------------------------------

return lowerkeys({ [unitName] = unitDef })

--------------------------------------------------------------------------------
