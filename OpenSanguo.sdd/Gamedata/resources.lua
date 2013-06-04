local   resources = {
      graphics = {
         -- Spring Defaults
         groundfx = {
            groundflash   = 'effects/groundflash.tga',
            groundring   = 'effects/groundring.tga',
            seismic      = 'effects/circles.tga',
         },
         projectiletextures = {
            circularthingy      = 'circularthingy.tga',
            laserend         = 'laserend.tga',
            laserfalloff      = 'laserfalloff.tga',
            randdots         = 'randdots.tga',
            smoketrail         = 'smoketrail.tga',
            wake            = 'wake.tga',
            flare            = 'flare.tga',
            explo            = 'explo.tga',
            explofade         = 'explofade.tga',
            explodeheat  =  'effects/explodeheat.tga',
            heatcloud         = 'explo.tga',
            flame            = 'effects/flame.tga',
            --muzzleside         = 'muzzleside.tga',
            --muzzlefront         = 'muzzlefront.tga',
            largebeam         = 'largelaserfalloff.tga',
			cartooncloud = 'effects/cartooncloud.png',
			springlogo = 'effects/springlogo.png',
			star = 'effects/star.png',
            muzzleflash_side         = 'effects/muzzleflash_side.tga',
            muzzleflash_front        = 'effects/muzzleflash_front.tga',


         },
      }
   }

local VFSUtils = VFS.Include('gamedata/VFSUtils.lua')

local function AutoAdd(subDir, map, filter)
  local dirList = RecursiveFileSearch("bitmaps/" .. subDir)
  for _, fullPath in ipairs(dirList) do
    local path, key, ext = fullPath:match("bitmaps/(.*/(.*)%.(.*))")
    if not fullPath:match("/%.svn") then
    local subTable = resources["graphics"][subDir] or {}
    resources["graphics"][subDir] = subTable
      if not filter or filter == ext then
        if not map then
          table.insert(subTable, path)
        else -- a mapped subtable
          subTable[key] = path
        end
      end
    end
  end
end

-- Add mod projectiletextures
AutoAdd("projectiletextures", true)

return resources