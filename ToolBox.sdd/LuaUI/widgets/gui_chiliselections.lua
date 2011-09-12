--TODO: Make item placement less stupidly dependent on precisely hardcoded values

function widget:GetInfo()
  return {
    name      = "Chili Selections",
    desc      = "v0.171 Chili Selections.",
    author    = "jK & CarRepairer",
    date      = "@2009,2010",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    experimental = false,
    enabled   = false,
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local spSendLuaRulesMsg			= Spring.SendLuaRulesMsg
local spGetCurrentTooltip		= Spring.GetCurrentTooltip

local spGetSelectedUnits                = Spring.GetSelectedUnits
local spGetSelectedUnitsCounts          = Spring.GetSelectedUnitsCounts
local spGetSelectedUnitsCount           = Spring.GetSelectedUnitsCount
local spGetSelectedUnitsByDef           = Spring.GetSelectedUnitsSorted

local spGetUnitDefID			= Spring.GetUnitDefID
local spGetFeatureDefID			= Spring.GetFeatureDefID
local spGetUnitAllyTeam			= Spring.GetUnitAllyTeam
local spGetUnitTeam			= Spring.GetUnitTeam
local spGetUnitHealth			= Spring.GetUnitHealth
local spTraceScreenRay			= Spring.TraceScreenRay
local spGetTeamInfo			= Spring.GetTeamInfo
local spGetPlayerInfo			= Spring.GetPlayerInfo
local spGetTeamColor			= Spring.GetTeamColor
local spGetUnitTooltip			= Spring.GetUnitTooltip
local spGetUnitIsStunned		= Spring.GetUnitIsStunned
local spGetUnitResources		= Spring.GetUnitResources

local spGetModKeyState			= Spring.GetModKeyState
local spGetMouseState			= Spring.GetMouseState

local spSendCommands			= Spring.SendCommands

local abs				= math.abs
local strFormat 				= string.format

local windMin = 0
local windMax = 2.5

local iconTypesPath = LUAUI_DIRNAME.."Configs/icontypes.lua"
local icontypes = VFS.FileExists(iconTypesPath) and VFS.Include(iconTypesPath)
local iconFormat = '.dds'

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Chili
local Button
local Label
local Colorbars
local Checkbox
local Window
local ScrollPanel
local StackPanel
local LayoutPanel
local Grid
local Trackbar
local TextBox
local Image
local Progressbar
local screen0


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- pylon tooltips

local pylonTooltips = {
	["amgeo"] = true,
	["armestor"] = true,
	["armfus"] = true,
	["armsolar"] = true,
	["cafus"] = true,
	["chickend"] = true,
	["chickenspire"] = true,
	["geo"] = true,
	["armwin"] = true,
}

local windTooltips = {
	["armwin"] = true,
}

local mexTooltips = {
	["cormex"] = true,
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local window_height = 130

local window_corner
local subwindow

local cur_tooltip
local old_mx, old_my

local numSelectedUnits = 0
local selectedUnitsByDefCounts = {}
local selectedUnitsByDef = {}
local selectedUnits = {}
local selectionSortOrder = {}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- group info

local selectedUnits = {}
local numSelectedUnits = 0

local gi_count = 0
local gi_cost = 0
local gi_finishedcost = 0
local gi_hp = 0
local gi_maxhp = 0
local gi_metalincome = 0
local gi_metaldrain = 0
local gi_energyincome = 0
local gi_energydrain = 0
local gi_usedbp = 0
local gi_totalbp = 0

local gi_str	--group info string
local gi_label	--group info Chili label

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- options

options_path = 'Settings/Interface/Selection Window'

local function option_Deselect()
  -- unselect to prevent errors
  Spring.SelectUnitMap({}, false)
  window_height = options.squarepics.value and 140 or 115
end
options = {
  groupalways = {name='Always Group Units', type='bool', value=false, OnChange = option_Deselect},
  showgroupinfo = {name='Show Group Info', type='bool', value=true, OnChange = option_Deselect},
  squarepics = {name='Square Buildpics', type='bool', value=true, OnChange = option_Deselect},
  hpshort = {
		name = "HP Short Notation",
		type = 'bool',
		value = false,
		desc = 'Shows short number for HP.',
	},
}

local updateFrequency = 0.2

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function round(num, idp)
  if (not idp) then
    return math.floor(num+.5)
  else
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
  end
end

local function numformat(x, displayPlusMinus)
	
	if (x < 20 and (x * 10)%10 ~=0) then 
		if (displayPlusMinus) then return strFormat("%+.1f", x)
		else return strFormat("%.1f", x) end 
	else 
		if (displayPlusMinus) then return strFormat("%+d", x)
		else return strFormat("%d", x) end
	end 
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AdjustWindow(window)
	local nx
	if (0 > window.x) then
		nx = 0
	elseif (window.x + window.width > screen0.width) then
		nx = screen0.width - window.width
	end

	local ny
	if (0 > window.y) then
		ny = 0
	elseif (window.y + window.height > screen0.height) then
		ny = screen0.height - window.height
	end

	if (nx or ny) then
		window:SetPos(nx,ny)
	end
end

local function Show(obj)
	if (not obj:IsDescendantOf(screen0)) then
		screen0:AddChild(obj)
	end
end

local function Hide(obj)
	obj:ClearChildren()
	screen0:RemoveChild(obj)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- group selection

--updates cost, HP, and resourcing info for group info
local function UpdateDynamicGroupInfo()
	gi_cost = 0
	gi_hp = 0
	gi_metalincome = 0
	gi_metaldrain = 0
	gi_energyincome = 0
	gi_energydrain = 0
	gi_usedbp = 0
	
	for i = 1, numSelectedUnits do
		local id = selectedUnits[i]
	
		local ud = UnitDefs[spGetUnitDefID(id) or 0]
		if ud then
			local name = ud.name 
			local hp, _, paradam, cap, build = spGetUnitHealth(id)
			local mm,mu,em,eu = spGetUnitResources(id)
		
			if name ~= "terraunit" then
				gi_cost = gi_cost + ud.metalCost*build
				gi_hp = gi_hp + hp
				
				local stunned_or_inbuld = spGetUnitIsStunned(id)
				if not stunned_or_inbuld then 
					if name == 'armmex' or name =='cormex' then -- mex case
						local tooltip = spGetUnitTooltip(id)
						
						local baseMetal = 0
						local s = tooltip:match("Makes: ([^ ]+)")
						if s ~= nil then 
							baseMetal = tonumber(s) 
						end 
										
						s = tooltip:match("Overdrive: %+([0-9]+)")
						local od = 0
						if s ~= nil then 
							od = tonumber(s) 
						end
						
						gi_metalincome = gi_metalincome + baseMetal + baseMetal * od / 100
							
						s = tooltip:match("Energy: ([^ ]+)")
						if s ~= nil then 
							gi_energydrain = gi_energydrain - tonumber(s) 
						end 
					else
						gi_metalincome = gi_metalincome + mm
						gi_metaldrain = gi_metaldrain + mu
						gi_energyincome = gi_energyincome + em
						gi_energydrain = gi_energydrain + eu
					end
					
					if ud.buildSpeed ~= 0 then
						gi_usedbp = gi_usedbp + mu
					end
				end
			end
		end
		
	end
	
	gi_cost = numformat(gi_cost)
	gi_hp = numformat(gi_hp)
	gi_metalincome = numformat(gi_metalincome)
	gi_metaldrain = numformat(gi_metaldrain)
	gi_energyincome = numformat(gi_energyincome)
	gi_energydrain = numformat(gi_energydrain)
	gi_usedbp = numformat(gi_usedbp)
end

--updates values that don't change over time for group info
local function UpdateStaticGroupInfo()
	gi_count = numSelectedUnits
	gi_finishedcost = 0
	gi_totalbp = 0
	gi_maxhp = 0
	
	for i = 1, numSelectedUnits do
		local ud = UnitDefs[spGetUnitDefID(selectedUnits[i]) or 0]
		if ud then
			local name = ud.name 
			if name ~= "terraunit" then
				gi_totalbp = gi_totalbp + ud.buildSpeed
				gi_maxhp = gi_maxhp + ud.health
				gi_finishedcost = gi_finishedcost + ud.metalCost
			end
		end
	end
	gi_finishedcost = numformat(gi_finishedcost)
	gi_totalbp = numformat(gi_totalbp)
	gi_maxhp = numformat(gi_maxhp)
end

----------------------------------------------------------------
----------------------------------------------------------------

local function GetUnitDesc(unitID, ud)
	local lang = WG.lang or 'en'
	if lang == 'en' then 
		return unitID and spGetUnitTooltip(unitID) or ud.tooltip
	end
	local suffix = ('_' .. lang)
	local desc = ud.customParams and ud.customParams['description' .. suffix] or ud.tooltip or 'Description error'
	if unitID then
		local endesc = ud.tooltip
		--(ud.chili_selections_useStaticTooltip)and(ud.tooltip) or spGetUnitTooltip(unitid);
		return spGetUnitTooltip(unitID):gsub(endesc, desc)
	end
	return desc
end

local function MakeUnitToolTip(unitid)
	local ud             = UnitDefs[spGetUnitDefID(unitid) or 0]
	local team           = spGetUnitTeam(unitid)
	local _, player      = spGetTeamInfo(team)
	local playerName     = spGetPlayerInfo(player) or 'noname'
	local teamColor      = Chili.color2incolor(spGetTeamColor(team))

	window_corner:ClearChildren();
	--window_corner:Resize(300,window_height, true)
	
	Image:New{
		parent  = window_corner;
		file2   = (WG.GetBuildIconFrame)and(WG.GetBuildIconFrame(ud));
		file    = "#" .. ud.id;
		keepAspect = false;
		x       = 210;
		height  = 55 * (4/5);
		--height  = 55;
		width   = 55;
		tooltip = 'Middle-click to go to unit.',
		OnClick = {function(_,_,_,button)
			if (button==2) then
				--button2 (middle)
				local x,y,z = Spring.GetUnitPosition( unitid )
				Spring.SetCameraTarget(x,y,z, 1)
			end
		end}
	}
	
	local iconPath = icontypes 
			and	icontypes[(ud.iconType or "default")].bitmap
			or 	'icons/'.. ud.iconType ..iconFormat

			Image:New{
		parent  = window_corner;
		file    = iconPath,
		x       = 0;--57;
		y       = 0;
		height  = 20;
		width   = 20;
	}
	Label:New{
		parent  = window_corner;
		x       = 22;--79;
		height  = 20;
		caption = ud.humanName;-- .. teamColor .. ' (' .. playerName .. ')';
		valign  = 'center';
		fontSize = 14;
		fontShadow = true;
	}

	Label:New{
		parent  = window_corner;
		name 	= 'tooltip';
		x       = 10;--67;
		y       = 20;
		height  = 40;
		width = 235;
		--height = 30;
		autoSize = false;
		--caption = (ud.chili_selections_useStaticTooltip)and(ud.tooltip) or spGetUnitTooltip(unitid);
		caption = GetUnitDesc(unitid, ud);
		valign  = 'top';
	}

	Grid:New{
		name     = 'info';
		parent   = window_corner;
		x        = 200;
		y        = 56;
		height   = 55;
		width    = 71;
		columns  = 2;
		autosize = true;
		resizeItems = false;
		centerItems = true;
		padding     = {0,0,0,0};
		itemPadding = {0,1,0,2};
		itemMargin  = {0,0,0,0};
		--debug=true;
		children = {
			Label:New{
				name    = 'metal';
				autosize= false;
				height  = 15;
				width   = 42;
				caption = '\255\000\254\000+0';
				align   = 'right';
				margin  = {0,0,5,0};
			},
			Image:New{
				file    = 'LuaUI/images/ibeam.png';
				height  = 15;
				width   = 15;
			},

			Label:New{
				name    = 'energy';
				autosize= false;
				height  = 15;
				width   = 42;
				caption = '\255\254\000\000+0';
				align   = 'right';
				margin  = {0,0,5,0};
			},
			Image:New{
				file    = 'LuaUI/images/energy.png';
				height  = 15;
				width   = 15;
			}
		}
	}

	local barGrid = Grid:New{
		name     = 'Bars';
		autosize = true;
		resizeItems = false;
		centerItems = true;
		parent  = window_corner;
		columns = 2;
		x       = 0;--60;
		y       = 55;
		height  = 50;
		width   = 225;
		padding     = {5,5,5,5};
		itemPadding = {0,0,0,0};
		itemMargin  = {0,0,0,0};
--[[
		DrawBackground = function(self)
			gl.BeginEnd(GL.QUADS,function()
				gl.Color(0,0,0,0.1)
				gl.Vertex(self.x,self.y)
				gl.Vertex(self.x+self.width,self.y)
				gl.Color(0,0,0,0.5)
				gl.Vertex(self.x+self.width,self.y+self.height)
				gl.Vertex(self.x,self.y+self.height)
			end)
		end,
--]]
	}

	Image:New{
		parent  = barGrid;
		file    = 'LuaUI/images/commands/Bold/health.png';
		height  = 15;
		width   = 15;
	}
	Progressbar:New{
		name    = 'health';
		parent  = barGrid;
		width   = 200;
		max     = 1;
		caption = "100%";
		color   = {0,0.8,0,1};
	}

	if (windTooltips[ud.name] and not Spring.GetUnitRulesParam(unitid,"NotWindmill")) then
		Image:New{
			parent  = barGrid;
			file    = 'LuaUI/Images/commands/Bold/wind.png';
			height  = 15;
			width   = 15;
		}
		Progressbar:New{
			name    = 'wind';
			parent  = barGrid;
			width   = 200;
			max     = 1;
			caption = "100%";
			color   = {0.3,0.6,0.8,1};
		}
	end


	if (ud.builder) then
		Image:New{
			parent  = barGrid;
			file    = 'LuaUI/Images/commands/Bold/buildsmall.png';
			height  = 15;
			width   = 15;
		}
		Progressbar:New{
			name    = 'nano';
			parent  = barGrid;
			width   = 200;
			max     = 1;
			caption = "100%";
			color   = {0.8,0.8,0.2,1};
		}
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AddSelectionIcon(barGrid,unitid,defid,unitids,counts)
	local ud = UnitDefs[defid]
	local item = LayoutPanel:New{
		name    = unitid or defid;
		parent  = barGrid;
		width   = 50;
		height  = 62;
		columns = 1;
		padding     = {0,0,0,0};
		itemPadding = {0,0,0,0};
		itemMargin  = {0,0,0,1};
		resizeItems = false;
		centerItems = false;
		autosize    = true;		
	}
	local img = Image:New{
		parent  = item;
		tooltip = ud.humanName .. " - " .. ud.tooltip.. "\n\255\0\255\0Click: Select \nRightclick: Deselect \nAlt+Click: Select One \nCtrl+click: Select Type \nMiddle-click: Goto";
		file2   = (WG.GetBuildIconFrame)and(WG.GetBuildIconFrame(UnitDefs[defid]));
		file    = "#" .. defid;
		keepAspect = false;
		height  = 50 * (options.squarepics.value and 1 or (4/5));
		--height  = 50;
		width   = 50;
		padding = {0,0,0,0}; --FIXME something overrides the default in image.lua!!!!
		OnClick = {function(_,_,_,button)
			
			local alt, ctrl, meta, shift = spGetModKeyState()
			
			if (button==3) then
				if (unitid and not ctrl) then
					--// deselect a single unit
					for i=1,numSelectedUnits do
						if (selectedUnits[i]==unitid) then
							table.remove(selectedUnits,i)
							break
						end
					end
				else
					--// deselect a whole unitdef block
					for i=numSelectedUnits,1,-1 do
						if (Spring.GetUnitDefID(selectedUnits[i])==defid) then
							table.remove(selectedUnits,i)
							if (alt) then
								break
							end
						end
					end
				end
				Spring.SelectUnitArray(selectedUnits)
				--update selected units right now
				local sel = Spring.GetSelectedUnits()
				widget:SelectionChanged(sel)
			elseif button == 1 then
				if not ctrl then 
					if (alt) then
						Spring.SelectUnitArray({ selectedUnitsByDef[defid][1] })  -- only 1	
					else
						Spring.SelectUnitArray(unitids) -- no modifier - select all
					end
				else
					-- select all units of the icon type
					Spring.SelectUnitArray(selectedUnitsByDef[defid])
					
					--local sorted = Spring.GetTeamUnitsSorted(Spring.GetMyTeamID())						
					--local units = sorted[defid]
					--if units then Spring.SelectUnitArray(units) end
				end
			else --button2 (middle)
				local x,y,z = Spring.GetUnitPosition( unitids[1] )
				Spring.SetCameraTarget(x,y,z, 1)
			end
		end}
	};
	if ((counts or 1)>1) then
		Label:New{
			parent = img;
			align  = "right";
			valign = "top";
			x =  8;
			--y = 30;
			y = 20;
			width = 40;
			fontsize   = 20;
			fontshadow = true;
			fontOutline = true;
			caption    = counts;
		};
	end
	Progressbar:New{
		parent  = item;
		name    = 'health';
		width   = 50;
		height  = 5;
		max     = 1;
		color   = {0.0,0.99,0.0,1};
	};
end

--this is a separate function to allow group info to be regenerated without reloading the whole tooltip
local function WriteGroupInfo()
	if not options.showgroupinfo.value then return end
	if gi_label then
		window_corner:RemoveChild(gi_label)
	end
	gi_str = 
		"Selected Units " .. gi_count .. "\n" ..
		"Health " .. gi_hp .. " / " ..  gi_maxhp  .. "\n" ..
		"Cost " .. gi_cost .. " / " ..  gi_finishedcost .. "\n" ..
		"Metal \255\0\255\0+" .. gi_metalincome .. "\255\255\255\255 / \255\255\0\0-" ..  gi_metaldrain  .. "\255\255\255\255\n" ..
		"Energy \255\0\255\0+" .. gi_energyincome .. "\255\255\255\255 / \255\255\0\0-" .. gi_energydrain .. "\255\255\255\255\n" ..
		"Build Power " .. gi_usedbp .. " / " ..  gi_totalbp 
		
	gi_label = Label:New{
		parent  = window_corner;
		y=5,
		right=5,
		--x=-110,
		height  = '100%';
		width = 120,
		caption = gi_str;
		valign  = 'top';
		fontSize = 12;
		fontShadow = true;
	}
end

local function MakeUnitGroupSelectionToolTip()
	window_corner:ClearChildren();
	if options.showgroupinfo.value then
		--window_corner:Resize(395,window_height,true)
		--subwindow:Resize("70%",window_height,true)
	else
		--window_corner:Resize(300,window_height,true)
		--subwindow:Resize("95%",window_height,true)
	end
	
	local barGrid = LayoutPanel:New{
		name     = 'Bars';
		resizeItems = false;
		centerItems = false;
		parent  = window_corner;
		height  = "100%";
		x=0,
		--width   = "100%";
		right=options.showgroupinfo.value and 120 or 0,
		--columns = 5;
		itemPadding = {0,0,0,0};
		itemMargin  = {0,0,2,2};
		tooltip = "Left Click: Just select clicked unit(s)\nRight Click: Deselect unit(s)";
	}
	--if check is done in target function
	--if options.showgroupinfo.value then
		WriteGroupInfo()
	--end

	if ((numSelectedUnits<8) and (not options.groupalways.value)) then
		for i=1,numSelectedUnits do
			local unitid = selectedUnits[i]
			local defid  = spGetUnitDefID(unitid)
			local unitids = {unitid}

			AddSelectionIcon(barGrid,unitid,defid,unitids)
		end
	else
		for i=1,#selectionSortOrder do
			local defid   = selectionSortOrder[i]
			local unitids = selectedUnitsByDef[defid]
			local counts  = selectedUnitsByDefCounts[defid]

			AddSelectionIcon(barGrid,nil,defid,unitids,counts)
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function UpdateSelectedUnitsTooltip()
	local selectedUnits = selectedUnits
	if (numSelectedUnits>0) then
		if (numSelectedUnits == 1) then
			local infoContainer = window_corner.childrenByName['info']

			local barsContainer = window_corner.childrenByName['Bars']
			local healthbar = barsContainer.childrenByName['health']
			local health, maxhealth,para,_,buildProgress = spGetUnitHealth(selectedUnits[1])
			if health then
				healthbar:SetValue(health/maxhealth)
				healthbar:SetCaption(numformat(health) .. ' / ' .. numformat(maxhealth))
			else
				--healthbar:SetValue(1)
				--healthbar:SetCaption('??? / ' .. numformat(ud.health))
			end

			local ud = UnitDefs[spGetUnitDefID(selectedUnits[1]) or 0]
			
			local stunned_or_inbuld = spGetUnitIsStunned(selectedUnits[1])
			
			if not stunned_or_inbuld then
				local metalMake, metalUse, energyMake,energyUse = Spring.GetUnitResources(selectedUnits[1])
				local absMetal = metalMake - metalUse
				local absEnergy = energyMake - energyUse
				
				--// Nano/Builders
				local nanobar = barsContainer.childrenByName['nano']
				if (nanobar) then
					if metalUse then
						nanobar:SetValue(metalUse/ud.buildSpeed,true)
						nanobar:SetCaption(round(100*metalUse/ud.buildSpeed)..'%')
					else
						healthbar:SetValue(1)
						healthbar:SetCaption('??? / ' .. numformat(ud.buildSpeed))
					end
				end

				--// Windgens
				local windbar = barsContainer.childrenByName['wind']
				if (windbar) then
					local power = (absEnergy - windMin) / (windMax - windMin)
					windbar:SetValue(power, true)
					windbar:SetCaption( numformat(100*power) .."%" )
				end

				--// Mexes
	--[[ FIXME
				local odbar = barsContainer.childrenByName['overdrive']
				if (odbar) then
					windbar:SetValue(absEnergy / windMax, true)
					windbar:SetCaption(round(100*absEnergy/ windMax)..'%')
				end
	--]]

	-- special cases for mexes
				if mexTooltips[ud.name] then 
					local tooltip = spGetUnitTooltip(selectedUnits[1])
					--local tooltip = GetUnitDesc(selectedUnits[1])
					window_corner.childrenByName['tooltip']:SetCaption(tooltip)
					
					local baseMetal = 0
					local s = tooltip:match("Makes: ([^ ]+)")
					if s ~= nil then baseMetal = tonumber(s) end 
									
					s = tooltip:match("Overdrive: %+([0-9]+)")
					local od = 0
					if s ~= nil then od = tonumber(s) end
					
					absMetal = absMetal + baseMetal + baseMetal * od / 100
					
					s = tooltip:match("Energy: ([^ ]+)")
					if s ~= nil then absEnergy = absEnergy +tonumber(s) end 
				end 
				
				if pylonTooltips[ud.name] then 
					local tooltip = spGetUnitTooltip(selectedUnits[1])
					if windTooltips[ud.name] and not Spring.GetUnitRulesParam(selectedUnits[1],"NotWindmill") then
						tooltip = tooltip .. "\nWind Range " .. string.format("%.1f", Spring.GetUnitRulesParam(selectedUnits[1],"minWind")) .. " - " .. string.format("%.1f", Spring.GetGameRulesParam("WindMax"))
					end
					window_corner.childrenByName['tooltip']:SetCaption(tooltip)
				end
			
				
				local lbl_metal = infoContainer.childrenByName['metal']
				if abs(absMetal) <= 0.1 then
					lbl_metal.font:SetColor(0.5,0.5,0.5,1)
					lbl_metal:SetCaption("0")
				else
					if (absMetal<0) then
						lbl_metal.font:SetColor(1,0,0,1)
					else
						lbl_metal.font:SetColor(0,1,0,1)
					end
					lbl_metal:SetCaption(numformat(absMetal,true) )
				end

				local lbl_energy = infoContainer.childrenByName['energy']
				if abs(absEnergy) <= 0.1 then
					lbl_energy.font:SetColor(0.5,0.5,0.5,1)
					lbl_energy:SetCaption("0.0")
				else
					if (absEnergy<0) then
						lbl_energy.font:SetColor(1,0,0,1)
					else
						lbl_energy.font:SetColor(0,1,0,1)
					end
					lbl_energy:SetCaption( numformat(absEnergy, true) )
				end
			else -- unit is stunned
			
				--// Nano/Builders
				local nanobar = barsContainer.childrenByName['nano']
				if (nanobar) then
					nanobar:SetValue(0,true)
					nanobar:SetCaption('0%')
				end
				
				--// Windgens
				local windbar = barsContainer.childrenByName['wind']
				if (windbar) then
					windbar:SetValue(0, true)
					windbar:SetCaption('0%')
				end
				
				local lbl_metal = infoContainer.childrenByName['metal']
				lbl_metal:SetCaption("0.0")

				local lbl_energy = infoContainer.childrenByName['energy']
				lbl_energy:SetCaption("0.0")
				
			end
		
		else
			local barsContainer = window_corner.childrenByName['Bars']

			if ((numSelectedUnits<8) and (not options.groupalways.value)) then
				for i=1,numSelectedUnits do
					local unitid = selectedUnits[i]

					local unitIcon = barsContainer.childrenByName[unitid]
					--Spring.Echo(unitid)
					local healthbar = unitIcon.childrenByName['health']
					local health, maxhealth = spGetUnitHealth(unitid)
					if (health) then
						healthbar:SetValue(health/maxhealth)
						healthbar.tooltip = numformat(health) .. ' / ' .. numformat(maxhealth)
					end
				end
			else
				for defid,unitids in pairs(selectedUnitsByDef) do
					local health = 0
					local maxhealth = 0
					for i=1,#unitids do
						local uhealth, umaxhealth = spGetUnitHealth(unitids[i])
						health = health + (uhealth or 0)
						maxhealth = maxhealth + (umaxhealth or 0)
					end

					local unitGroup = barsContainer.childrenByName[defid]
					local healthbar = unitGroup.childrenByName['health']
					healthbar:SetValue(health/maxhealth)
					healthbar.tooltip = numformat(health) .. ' / ' .. numformat(maxhealth)
				end
			end

			--[[
			local nanobar = barsContainer.childrenByName['nano']
			if (nanobar) then
				local ud = UnitDefs[spGetUnitDefID(selectedUnits[1]) or 0]
				local metalMake, metalUse, energyMake,energyUse = Spring.GetUnitResources(selectedUnits[1])
				if metalUse then
					nanobar:SetValue(metalUse/ud.buildSpeed,true)
					nanobar:SetCaption(round(100*metalUse/ud.buildSpeed)..'%')
				else
					healthbar:SetValue(1)
					healthbar:SetCaption('??? / ' .. numformat(ud.buildSpeed))
				end

				local absMetal = metalMake - metalUse
				infoContainer.childrenByName['metal']:SetCaption((((absMetal<0)and'\255\254\000\000')or('\255\000\254\000+')) .. numformat(absMetal,1))

				local absEnergy = energyMake - energyUse
				infoContainer.childrenByName['energy']:SetCaption((((absEnergy<0)and'\255\254\000\000')or('\255\000\254\000+')) .. numformat(absEnergy,1))
			end
			--]]
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--lags like a brick due to being spammed constantly for unknown reason, moved all its behavior to SelectionChanged
--function widget:CommandsChanged()
--end
--

local cycle, timer = 1, 0
local tweakShow = false
function widget:Update(dt)
	--UpdateDynamicGroupInfo()
	timer = timer + dt
	--cycle = cycle%100 + 1
	if timer >= updateFrequency  then
		UpdateSelectedUnitsTooltip()
		UpdateDynamicGroupInfo()
		WriteGroupInfo()
		timer = 0
	end
	--if cycle == 1 then
	--end
	
	if widgetHandler:InTweakMode() then
	  tweakShow = true
	  Show(window_corner)
	elseif tweakShow then
	  tweakShow = false
	  widget:SelectionChanged(Spring.GetSelectedUnits())
	end
end

function widget:SelectionChanged(newSelection)
	numSelectedUnits = spGetSelectedUnitsCount()
	selectedUnits = newSelection

	if (numSelectedUnits>0) then
		UpdateStaticGroupInfo()
		UpdateDynamicGroupInfo()
		selectedUnitsByDef       = spGetSelectedUnitsByDef()
		selectedUnitsByDef.n     = nil -- REMOVE IN 0.83
		selectedUnitsByDefCounts = {}
		for i,v in pairs(selectedUnitsByDef) do
			selectedUnitsByDefCounts[i] = #v
		end

		--// spGetSelectedUnitsByDef() doesn't save the order for the different defids, so we reconstruct it from spGetSelectedUnits()
		--// else the sort order would change each time we select a new unit or deselect one!
		selectionSortOrder = {}
		local alreadyInList = {}
		for i=1,#selectedUnits do
			local defid = spGetUnitDefID(selectedUnits[i])
			if (not alreadyInList[defid]) then
				alreadyInList[defid] = true
				selectionSortOrder[#selectionSortOrder+1] = defid
			end
		end

		if (numSelectedUnits == 1) then
			MakeUnitToolTip(selectedUnits[1])
		else
			MakeUnitGroupSelectionToolTip()
		end
		Show(window_corner)
	else
		Hide(window_corner)
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Initialize()
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end
	
	Spring.SetDrawSelectionInfo(false) 
	
	local screenWidth,screenHeight = Spring.GetWindowGeometry()
	
	-- setup Chili
	 Chili = WG.Chili
	 Button = Chili.Button
	 Label = Chili.Label
	 Colorbars = Chili.Colorbars
	 Checkbox = Chili.Checkbox
	 Window = Chili.Window
	 ScrollPanel = Chili.ScrollPanel
	 StackPanel = Chili.StackPanel
	 LayoutPanel = Chili.LayoutPanel
	 Grid = Chili.Grid
	 Trackbar = Chili.Trackbar
	 TextBox = Chili.TextBox
	 Image = Chili.Image
	 Progressbar = Chili.Progressbar
	 screen0 = Chili.Screen0
	 
	local screenWidth,screenHeight = Spring.GetWindowGeometry()
	local y = tostring(math.floor(screenWidth/screenHeight*0.35*0.35*100 - window_height)) .. "%"

	window_corner = Window:New{
		name   = 'unitinfo';
		x      = 0;
		bottom = 200;
		clientHeight = 120;
		clientWidth  = 400;
		dockable = true,
		--autosize    = true;
		resizable   = false;
		draggable = false,
		tweakDraggable = true,
		tweakResizable = true,
		--padding = {3, 3, 15, 3}
		--color       = {Spring.GetTeamColor(Spring.GetLocalTeamID())};
		minimumSize = {120, 40},
	}
	--[[
	subwindow = ScrollPanel:New{
	  parent = window_corner,
	  name   = 'unitinfo_subwindow';  
      width = "95%",
      height = "95%",
      anchors = {top=true,left=true,bottom=true,right=true},
      horizontalScrollbar = false,
	  backgroundColor = {0, 0, 0, 0}
	}
	--]]

	windMin = Spring.GetGameRulesParam("WindMin")
	windMax = Spring.GetGameRulesParam("WindMax")

	for i=1,#UnitDefs do
		local ud = UnitDefs[i]
		if (ud.isCommander)           --// engine overrides commanders tooltips with playernames
		  or (ud.extractsMetal > 0)   --// the Overdrive gadgets adds additional information to the tooltip, but the visualize it a different way
		then
			ud.chili_selections_useStaticTooltip = true
		end
	end
	
	option_Deselect()
end

function widget:Shutdown()

	Spring.SetDrawSelectionInfo(true) 

end

