local armorDefs = {
    heavyarmor = {
        "simplefactory",
        "buildervehicle",
    },

    flyer = {
    },

    light = {
        "tc_shade",
    },

    heavy = {
        "euf_paladin",
    },
}

for categoryName, categoryTable in pairs(armorDefs) do
  local t = {}
  for _, unitName in pairs(categoryTable) do
    t[unitName] = 1
  end
  armorDefs[categoryName] = t
end

local system = VFS.Include('gamedata/system.lua')

return armorDefs