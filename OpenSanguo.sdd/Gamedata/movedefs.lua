local moveDefs =
{
	{
	name = "Default2x2",
	footprintX = 2,
	maxWaterDepth = 10,
	maxSlope = 20,
	crushStrength = 100,
	},
	
	{
	name = "Default3x3",
	footprintX = 3,
	maxWaterDepth = 10,
	maxSlope = 20,
	crushStrength = 100,
	},
	
	{
	name = "Hover2x2",
	footprintX = 2,
	maxWaterDepth = 5000,
	maxSlope = 20,
	crushStrength = 25,
	hover = true,
	},
    {
    name = "WALKER2X2",
    footprintX = 2,
    footprintZ = 2,
    maxwaterdepth = 40,
    maxslope = 35,
    slopemod = 4,
    crushStrength = 0,
    },
    {
    name = "WALKER3X3",
    footprintX = 3,
    footprintZ = 3,
    maxwaterdepth = 40,
    maxslope = 35,
    slopemod = 4,
    crushStrength = 0,
    },
    {
        name = "HEAVYWALKER2X2",
        footprintX = 2,
        footprintZ = 2,
        maxwaterdepth = 40,
        maxslope = 30,
        slopemod = 4,
        crushStrength = 300,
    },
    {
        name = "CLIMBER3X3",
        footprintX = 3,
        footprintZ = 3,
        maxwaterdepth = 30,
        maxslope = 90,
        slopemod = 4,
        crushStrength = 0,
    },
    {
        name = "Trooper1X1",
        footprintX = 1,
        footprintZ = 1,
        maxwaterdepth = 30,
        maxslope = 36,
        slopemod = 4,
        crushStrength = 0,
    },
    {
        name = "Trooper2X2",
        footprintX = 2,
        footprintZ = 2,
        maxwaterdepth = 30,
        maxslope = 36,
        slopemod = 4,
        crushStrength = 0,
    },
    {
        name = "Trooper3X3",
        footprintX = 3,
        footprintZ = 3,
        maxwaterdepth = 35,
        maxslope = 60,
        slopemod = 4,
        crushStrength = 0,
    },
    {
        name = "SubTrooper2X2",
        footprintX = 2,
        footprintZ = 2,
        maxwaterdepth = 255,
        maxslope = 36,
        depthmod = 0.2,
        slopemod = 0.2,
        crushStrength = 0,
    },
}

return moveDefs
