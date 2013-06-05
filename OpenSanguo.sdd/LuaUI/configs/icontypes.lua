-- $Id: icontypes.lua 4585 2009-05-09 11:15:01Z google frog $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    icontypes.lua
--  brief:   icontypes definitions
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--This file is used by engine, it's just placed here so LuaUI can access it too
--------------------------------------------------------------------------------
local icontypes = {
  default = {
    size=1,
    radiusadjust=1,
  },
  square = {
    bitmap='icons/square.tga',
    size=1,
  },
  bigsquare = {
    bitmap='icons/square.tga',
    size=1.5,
  },
  rhombe = {
    bitmap='icons/rhombe.tga',
    size=1,
  },
  bigrhombe = {
    bitmap='icons/rhombe.tga',
    size=2,
  },   
  triangle = {
    bitmap='icons/triangle.tga',
    size=1,
  },
  circle = {
    bitmap='icons/circle.tga',
    size=1,
  },  
  bigcircle = {
    bitmap='icons/circle.tga',
    size=1.5,
  },   
  skull = {
    bitmap='icons/skull.tga',
    size=2,
  },   
  bigskull = {
    bitmap='icons/skull.tga',
    size=4,
  },
  spanner = {
    bitmap='icons/spanner.tga',
    size=1.5,
  }, 
  neverseeme = {
    bitmap='icons/neverseeme.tga',
    size=0,
  },  
  blank = {
    bitmap='icons/blank.tga',
    size=0,
  },    
  tree = {
    bitmap='icons/tree.tga',
    size=0,
  },     
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return icontypes

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

