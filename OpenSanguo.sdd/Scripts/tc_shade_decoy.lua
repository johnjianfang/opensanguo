------------------------------------

local base = piece 'base'
local chest = piece 'chest'
local pelvis = piece 'pelvis'
local rthigh = piece 'rthigh'
local lthigh = piece 'lthigh'
local lleg = piece 'lleg'
local rleg = piece 'rleg'
local rfoot = piece 'rfoot'
local lfoot = piece 'lfoot'
local luparm = piece 'luparm'
local lloarm = piece 'lloarm'
local ruparm = piece 'ruparm'
local rloarm = piece 'rloarm'
local head = piece 'head'
local mask = piece 'mask'
local lhand = piece 'lhand'
local lthumb = piece 'lthumb'
local rhand = piece 'rhand'
local rthumb = piece 'rthumb'
local katana_r = piece 'katana_r'
local katana_l = piece 'katana_l'
local emit_r = piece 'emit_r'
local emit_l = piece 'emit_l'
local joint = piece 'joint'
local scabbard1 = piece 'scabbard1'
local scabbard2 = piece 'scabbard2'

local moving = false
local attacking = false
local inbunker = false
local parried = false
local isparrying = false

local MOVEANIMATIONSLEEPTIME = 330

local restore_delay, MOVEANIMATIONSPEED

local SIG_WALK = 1

local BLOODSPLASH	 = 1024+0
local BLOODSPRAY	 = 1025+0
local SPARKLES		 = 1026+0
local JUMPDUST	 	 = 1027+0
local LEVELING	 	 = 1028+0

local rturn = (math.random()*50)
local lturn = (math.random()*(-50))

local function Turn2(piecenum,axis, degrees, speed)
	local radians = degrees * 3.1415 / 180
	if speed then
		local speed1 = speed * 3.1415 / 180
		Turn(piecenum, axis, radians, speed1) 
	else
		Turn(piecenum, axis, radians ) 
	end
end

local function SetMoveAnimationSpeed()
	MOVEANIMATIONSPEED = (GetUnitValue(COB.MAX_SPEED)/2000)
	MOVEANIMATIONSLEEPTIME = (38000000/GetUnitValue(COB.MAX_SPEED))
	--if statements inside walkscript contain wait functions that can take forever if speed is too slow
	if MOVEANIMATIONSPEED < 50 then 
		MOVEANIMATIONSPEED = 50
	end
	if MOVEANIMATIONSLEEPTIME > 500 then 
		MOVEANIMATIONSLEEPTIME = 500
	end
end

local echo = Spring.Echo

--Jumps
local function JumpExhaust()
	while jumping do 
		EmitSfx(pelvis, JUMPDUST)
		EmitSfx(head, JUMPDUST)		
		Sleep(33)
	end
end

function script.preJump(turn, distance)
end

function script.beginJump()
	if inbunker then
		return false
	end

	Hide(chest)
	Hide(pelvis)
	Hide(rthigh)
	Hide(lthigh)
	Hide(lleg)
	Hide(rleg)
	Hide(rfoot)
	Hide(lfoot)
	Hide(luparm)
	Hide(lloarm)
	Hide(ruparm)
	Hide(rloarm)
	Hide(head)
	Hide(lhand)
	Hide(lthumb)
	Hide(rhand)
	Hide(rthumb)
	Hide(katana_r)
	Hide(katana_l)
	Hide(mask)	
	Hide(scabbard1)	
	Hide(scabbard2)		

	jumping = true
	StartThread(JumpExhaust)
end

function script.jumping()
end

function script.halfJump()
end

function script.endJump()

	Show(chest)
	Show(pelvis)
	Show(rthigh)
	Show(lthigh)
	Show(lleg)
	Show(rleg)
	Show(rfoot)
	Show(lfoot)
	Show(luparm)
	Show(lloarm)
	Show(ruparm)
	Show(rloarm)
	Show(head)
	Show(lhand)
	Show(lthumb)
	Show(rhand)
	Show(rthumb)
	Show(katana_r)
	Show(katana_l)
	Show(mask)	
	Show(scabbard2)	
	Show(scabbard2)	
	
	jumping = false	
end

-- Walk Motion
local function Walkscript()
	SetSignalMask(SIG_WALK)
	while true do
		if moving then
			SetMoveAnimationSpeed()
			if not attacking then
				Turn2( ruparm, x_axis, 15, MOVEANIMATIONSPEED*2 )
				Turn2( chest, x_axis, 15, MOVEANIMATIONSPEED)
			end
			Turn2( rleg, y_axis, 0, MOVEANIMATIONSPEED*2 )
			Turn2( lleg, y_axis, 0, MOVEANIMATIONSPEED*2 )			
			Turn2( lthigh, x_axis, -25, MOVEANIMATIONSPEED*1.8 )
			Turn2( rthigh, x_axis, 40, MOVEANIMATIONSPEED*1.8 )
			Turn2( lleg, x_axis, 0, MOVEANIMATIONSPEED*1.4 )
			Turn2( rleg, x_axis, 10, MOVEANIMATIONSPEED*1.4 )
			Sleep(MOVEANIMATIONSLEEPTIME)			
		end
		if moving then
--			SetMoveAnimationSpeed()
			if not attacking then
				Turn2( luparm, x_axis, -15, MOVEANIMATIONSPEED*2 )
				Turn2( chest, z_axis, -2, MOVEANIMATIONSPEED )
				Turn2( head, z_axis, 2, MOVEANIMATIONSPEED*0.3 )
				end
			Turn2( lthigh, x_axis, -23, MOVEANIMATIONSPEED*1.8 )
			Turn2( rthigh, x_axis, 15, MOVEANIMATIONSPEED*1.8 )
			Turn2( lleg, x_axis, -15, MOVEANIMATIONSPEED*1.4)
			Turn2( rleg, x_axis, 40, MOVEANIMATIONSPEED*1.4 )
			Move( pelvis, y_axis, 0, 8 )
			Sleep(MOVEANIMATIONSLEEPTIME)	
		end
		if moving then
--			SetMoveAnimationSpeed()
			if not attacking then
				Turn2( luparm, x_axis, 15, MOVEANIMATIONSPEED*2 )
				Turn2( chest, z_axis, 2, MOVEANIMATIONSPEED )
				Turn2( head, z_axis, -2, MOVEANIMATIONSPEED*0.3 )
			end
			Turn2( lthigh, x_axis, 40, MOVEANIMATIONSPEED*1.8 )
			Turn2( rthigh, x_axis, -25, MOVEANIMATIONSPEED*1.8 )
			Turn2( lleg, x_axis, 10, MOVEANIMATIONSPEED*1.4 )
			Turn2( rleg, x_axis, 0, MOVEANIMATIONSPEED*1.4 )
			Sleep(MOVEANIMATIONSLEEPTIME)
		end
		if moving then
--			SetMoveAnimationSpeed()
			if not attacking then
				Turn2( ruparm, x_axis, -15, MOVEANIMATIONSPEED*2 )
			end
			Turn2( lthigh, x_axis, 15, MOVEANIMATIONSPEED*1.8 )
			Turn2( rthigh, x_axis, -23, MOVEANIMATIONSPEED*1.8 )
			Turn2( lleg, x_axis, 40, MOVEANIMATIONSPEED*1.4)
			Turn2( rleg, x_axis, -15, MOVEANIMATIONSPEED*1.4 )
			Move( pelvis, y_axis, 0.3, 8 )
			Sleep(MOVEANIMATIONSLEEPTIME)	
		end		
		if not moving and not jumping then 
--			SetMoveAnimationSpeed()
			if not attacking then 
				Turn2( rleg, x_axis, 0, MOVEANIMATIONSPEED*1.6 )
				Turn2( lleg, x_axis, 0, MOVEANIMATIONSPEED*1.6 )
			end
			Turn2( chest, x_axis, 0, MOVEANIMATIONSPEED)			
			Turn2( rleg, y_axis, rturn, MOVEANIMATIONSPEED*2 )
			Turn2( lleg, y_axis, lturn, MOVEANIMATIONSPEED*2 )			
			Turn2( head, z_axis, 0, MOVEANIMATIONSPEED*0.3 )
			Turn2( chest, z_axis, 0, MOVEANIMATIONSPEED )				
			Turn2( rthigh, x_axis, 0, MOVEANIMATIONSPEED )
			Turn2( lthigh, x_axis, 0, MOVEANIMATIONSPEED )
			Turn2( pelvis, z_axis, 0, MOVEANIMATIONSPEED*0.8 )
			Turn2( lthigh, z_axis, 0, MOVEANIMATIONSPEED*0.8 )
			Turn2( rthigh, z_axis, 0, MOVEANIMATIONSPEED*0.8 )
			Move( pelvis, y_axis, 0, 8 )
			Turn2( ruparm, x_axis, 0, MOVEANIMATIONSPEED*3 )			
			Turn2( luparm, x_axis, 0, MOVEANIMATIONSPEED*3 )			
			end
		Sleep(10)
	end
end


------------------------ ACTIVATION

function script.Create()
	SetMoveAnimationSpeed()
	
	restore_delay = 1000
	
	--START BUILD CYCLE
	Sleep(200)
	while GetUnitValue(COB.BUILD_PERCENT_LEFT) > 0 do
			Sleep(300)
	end
	--END BUILD CYCLE
--	Turn2( chest, y_axis, -50, MOVEANIMATIONSPEED )
	EmitSfx(base, LEVELING)	
	StartThread( Walkscript )
end

function script.StartMoving()
	moving = true
end

function script.StopMoving()
	moving = false	
end
  
--[[local function RestoreAfterDelay()
	Sleep(restore_delay)
	Turn( chest, x_axis, 0, 8)	
 	Turn(chest, y_axis, 0, 10)
	Turn2( rloarm, x_axis, 0, 300)
	Turn2( rloarm, y_axis, 0, 320)		
	Turn2( rhand, x_axis, 0, 150)		
	Turn2( rhand, y_axis, 0, 300)		
	Turn2( rhand, z_axis, 0, 250)
	Turn2( joint, y_axis, 0, 230)	
	return (0)
end]]--

--bunker -----------------------------------------------------------------
function script.setSFXoccupy ( curTerrainType )
   if (curTerrainType > 0) then
      inbunker = false
   elseif (curTerrainType == 0) then
      inbunker = true
   end
end

function script.parry()
	if math.random()>0.33 then
		parried = true
	end
end

function script.HitByWeapon ( x, z, weaponDefID, damage )
	parried = false
	if inbunker then
		return(0)
	elseif not inbunker then
		GG.CheckParriableWeapon(unitID, weaponDefID)
		if (parried and (z>0)) then
			if ((not attacking) and (not isparrying)) then
				isparrying = true		
				StartThread(MeleeAnimations)	
				return(0)
			end
		else
			return(damage)
		end	
	end
end


--weapon 1 -----------------------------------------------------------------

function script.QueryWeapon1 ()
	return emit_r
end

function script.AimFromWeapon1 ()
	return chest
end

function script.AimWeapon1(heading, pitch)
	randomsleeptime = math.random(100)
	Sleep(randomsleeptime)
	if inbunker or isparrying then
		return false
	end
	
	local SIG_Aim = 2^1
	Signal(SIG_Aim)
	SetSignalMask(SIG_Aim)
	
--	StartThread( RestoreAfterDelay) 
	return true
end

function script.Shot1()
	attacking=true
	StartThread(MeleeAnimations)
end

function MeleeAnimations()
	local randomnumber = math.random()
	if attacking then
		if (randomnumber > 0.66) then
			Turn2( chest, x_axis, 0, 400 )
			Turn2( chest, y_axis, 0, 400 )
			Turn2( chest, z_axis, 0, 400 )
			Turn2( ruparm, y_axis, 0, 400 )
			Turn2( ruparm, z_axis, 0, 400 )
			Turn2( rloarm, z_axis, 0, 400 )
			Turn2( rloarm, x_axis, -25, 450*2 )
			Turn2( rloarm, y_axis, -45, 450*2 )		
			Turn2( rhand, x_axis, 25, 400*2 )		
			Turn2( rhand, y_axis, 0, 400*2 )		
			Turn2( rhand, z_axis, 90, 400*2 )
			Turn2( ruparm, x_axis, 0, MOVEANIMATIONSPEED*4 )

			Turn2( luparm, y_axis, 0, 400 )
			Turn2( luparm, z_axis, 0, 400 )
			Turn2( lloarm, z_axis, 0, 400 )
			Turn2( lloarm, x_axis, -25, 450*2 )
			Turn2( lloarm, y_axis, -45, 450*2 )		
			Turn2( lhand, x_axis, 25, 400*2 )		
			Turn2( lhand, y_axis, 0, 400*2 )		
			Turn2( lhand, z_axis, 90, 400*2 )
			Turn2( luparm, x_axis, 0, MOVEANIMATIONSPEED*4 )			
			
			Turn2( chest, x_axis, -5, 300*2 )		
			Turn2( joint, y_axis, 0, 450*2 )
			WaitForTurn(rloarm, y_axis)			
			Turn2( chest, x_axis, 5, 300 )		
			Turn2( joint, y_axis, 120, 1000 )
			local x, y, z = Spring.GetUnitPosition(unitID)
			Spring.PlaySoundFile("sounds/swoosh.wav", 80, x, y, z)
			WaitForTurn(chest, x_axis)
			WaitForTurn(joint, y_axis)
			Turn2( joint, y_axis, 0, 450)
			Turn2( chest, x_axis, 0, 400 )
			Turn2( chest, y_axis, 0, 400 )
			Turn2( chest, z_axis, 0, 400 )
			Turn2( ruparm, x_axis, 0, 400 )
			Turn2( ruparm, y_axis, 0, 400 )
			Turn2( ruparm, z_axis, 0, 400 )
			Turn2( rloarm, x_axis, 0, 400 )
			Turn2( rloarm, y_axis, 0, 400 )
			Turn2( rloarm, z_axis, 0, 400 )
			Turn2( rhand, x_axis, 0, 400 )
			Turn2( rhand, y_axis, 0, 400 )
			Turn2( rhand, z_axis, 0, 400 )
			Turn2( joint, y_axis, 0, 400 )			

			Turn2( luparm, x_axis, 0, 400 )
			Turn2( luparm, y_axis, 0, 400 )
			Turn2( luparm, z_axis, 0, 400 )
			Turn2( lloarm, x_axis, 0, 400 )
			Turn2( lloarm, y_axis, 0, 400 )
			Turn2( lloarm, z_axis, 0, 400 )
			Turn2( lhand, x_axis, 0, 400 )
			Turn2( lhand, y_axis, 0, 400 )
			Turn2( lhand, z_axis, 0, 400 )


			WaitForTurn(chest, x_axis)
			WaitForTurn(chest, y_axis)
			WaitForTurn(chest, z_axis)
			WaitForTurn(ruparm, x_axis)
			WaitForTurn(ruparm, y_axis)
			WaitForTurn(ruparm, z_axis)
			WaitForTurn(rloarm, x_axis)
			WaitForTurn(rloarm, y_axis)
			WaitForTurn(rloarm, z_axis)
			WaitForTurn(rhand, x_axis)
			WaitForTurn(rhand, y_axis)
			WaitForTurn(rhand, z_axis)
			
		elseif (randomnumber < 0.33) then	
		
			Turn2( chest, x_axis, -25, 300 )
			Turn2( chest, y_axis, 20, 300 )		
			Turn2( ruparm, x_axis, -10, 300 )
			Turn2( rloarm, x_axis, -80, 300 )
			Turn2( rhand, x_axis, -20, 300 )
		
			Turn2( luparm, x_axis, -10, 300 )
			Turn2( lloarm, x_axis, -80, 300 )
			Turn2( lhand, x_axis, -20, 300 )	

			WaitForTurn(rhand, x_axis)
			WaitForTurn(rloarm, x_axis)
			Turn2( chest, x_axis, 22.5, 500 )
			Turn2( chest, y_axis, -30, 500 )			
			Turn2( ruparm, x_axis, 10, 500 )
			Turn2( rloarm, x_axis, 30, 500 )
			Turn2( rhand, x_axis, 20, 800 )
			
			Turn2( luparm, x_axis, 10, 500 )
			Turn2( lloarm, x_axis, 30, 500 )
			Turn2( lhand, x_axis, 20, 800 )			
			
			local x, y, z = Spring.GetUnitPosition(unitID)
			Spring.PlaySoundFile("sounds/swoosh.wav", 80, x, y, z)
			WaitForTurn(ruparm, x_axis)
			WaitForTurn(rloarm, x_axis)
			WaitForTurn(rhand, x_axis)
			Sleep(300)
			Turn2( chest, x_axis, 0, 400 )
			Turn2( chest, y_axis, 0, 400 )
			Turn2( chest, z_axis, 0, 400 )
			Turn2( ruparm, x_axis, 0, 400 )
			Turn2( ruparm, y_axis, 0, 400 )
			Turn2( ruparm, z_axis, 0, 400 )
			Turn2( rloarm, x_axis, 0, 400 )
			Turn2( rloarm, y_axis, 0, 400 )
			Turn2( rloarm, z_axis, 0, 400 )
			Turn2( rhand, x_axis, 0, 400 )
			Turn2( rhand, y_axis, 0, 400 )
			Turn2( rhand, z_axis, 0, 400 )	
			
			Turn2( luparm, x_axis, 0, 400 )
			Turn2( luparm, y_axis, 0, 400 )
			Turn2( luparm, z_axis, 0, 400 )
			Turn2( lloarm, x_axis, 0, 400 )
			Turn2( lloarm, y_axis, 0, 400 )
			Turn2( lloarm, z_axis, 0, 400 )
			Turn2( lhand, x_axis, 0, 400 )
			Turn2( lhand, y_axis, 0, 400 )
			Turn2( lhand, z_axis, 0, 400 )				
			
			WaitForTurn(chest, x_axis)
			WaitForTurn(chest, y_axis)
			WaitForTurn(chest, z_axis)
			WaitForTurn(ruparm, x_axis)
			WaitForTurn(ruparm, y_axis)
			WaitForTurn(ruparm, z_axis)
			WaitForTurn(rloarm, x_axis)
			WaitForTurn(rloarm, y_axis)
			WaitForTurn(rloarm, z_axis)
			WaitForTurn(rhand, x_axis)
			WaitForTurn(rhand, y_axis)
			WaitForTurn(rhand, z_axis)
		else
			if not moving then 		
				Turn2( rleg, x_axis, 50, 600 )
			end
			
			Turn2( head, y_axis, 30, 200 )					
			
			Turn2( ruparm, x_axis, 0, 300 )
			Turn2( ruparm, y_axis, 0, 300 )
			Turn2( ruparm, z_axis, 50, 300 )			
			Turn2( rloarm, x_axis, 0, 300 )
			Turn2( rloarm, y_axis, 60, 300 )
			Turn2( rloarm, z_axis, 0, 300 )			
			Turn2( rhand, x_axis, 35, 300 )
			Turn2( rhand, y_axis, 0, 300 )
			Turn2( rhand, z_axis, 0, 300 )	
			
			Turn2( luparm, x_axis, 0, 300 )
			Turn2( luparm, y_axis, 0, 300 )
			Turn2( luparm, z_axis, -45, 300 )			
			Turn2( lloarm, x_axis, -25, 300 )
			Turn2( lloarm, y_axis, 0, 300 )
			Turn2( lloarm, z_axis, 0, 300 )			
			Turn2( lhand, x_axis, 25, 300 )
			Turn2( lhand, y_axis, -30, 300 )
			Turn2( lhand, z_axis, 15, 300 )

			Turn2( pelvis, y_axis, 90, 1500 )		
			Sleep(100)
			Turn2( pelvis, y_axis, 180, 2000 )
			local x, y, z = Spring.GetUnitPosition(unitID)
			Spring.PlaySoundFile("sounds/swoosh.wav", 80, x, y, z)			
			Sleep(100)
			Turn2( pelvis, y_axis, 270, 2000 )
			Sleep(100)
			Turn2( pelvis, y_axis, 0, 1500 )	
			Sleep(100)

			Turn2( head, y_axis, 0, 200 )			
			Turn2( rleg, x_axis, 0, 400 )
			Turn2( chest, x_axis, 0, 400 )
			Turn2( chest, y_axis, 0, 400 )
			Turn2( chest, z_axis, 0, 400 )
			Turn2( ruparm, x_axis, 0, 400 )
			Turn2( ruparm, y_axis, 0, 400 )
			Turn2( ruparm, z_axis, 0, 400 )
			Turn2( rloarm, x_axis, 0, 400 )
			Turn2( rloarm, y_axis, 0, 400 )
			Turn2( rloarm, z_axis, 0, 400 )
			Turn2( rhand, x_axis, 0, 400 )
			Turn2( rhand, y_axis, 0, 400 )
			Turn2( rhand, z_axis, 0, 400 )	
			
			Turn2( luparm, x_axis, 0, 400 )
			Turn2( luparm, y_axis, 0, 400 )
			Turn2( luparm, z_axis, 0, 400 )
			Turn2( lloarm, x_axis, 0, 400 )
			Turn2( lloarm, y_axis, 0, 400 )
			Turn2( lloarm, z_axis, 0, 400 )
			Turn2( lhand, x_axis, 0, 400 )
			Turn2( lhand, y_axis, 0, 400 )
			Turn2( lhand, z_axis, 0, 400 )				
			
			WaitForTurn(chest, x_axis)
			WaitForTurn(chest, y_axis)
			WaitForTurn(chest, z_axis)
			WaitForTurn(ruparm, x_axis)
			WaitForTurn(ruparm, y_axis)
			WaitForTurn(ruparm, z_axis)
			WaitForTurn(rloarm, x_axis)
			WaitForTurn(rloarm, y_axis)
			WaitForTurn(rloarm, z_axis)
			WaitForTurn(rhand, x_axis)
			WaitForTurn(rhand, y_axis)
			WaitForTurn(rhand, z_axis)

			
		end
	end
	if isparrying then
		Turn2( rloarm, x_axis, 0, 400 )
		Turn2( rloarm, y_axis, 0, 400 )
		Turn2( rloarm, z_axis, 0, 400 )
		Turn2( rhand, x_axis, 0, 400 )
		Turn2( rhand, y_axis, 0, 400 )
		Turn2( rhand, z_axis, 0, 400 )
		Turn2( joint, y_axis, 0, 400 )			
		Turn2( ruparm, x_axis, -30, 500 )
		Turn2( ruparm, y_axis, -55, 450 )
		Turn2( ruparm, z_axis, 55, 500 )

		Turn2( lloarm, x_axis, 0, 400 )
		Turn2( lloarm, y_axis, 0, 400 )
		Turn2( lloarm, z_axis, 0, 400 )
		Turn2( lhand, x_axis, 0, 400 )
		Turn2( lhand, y_axis, 0, 400 )
		Turn2( lhand, z_axis, 0, 400 )
		Turn2( luparm, x_axis, -30, 500 )
		Turn2( luparm, y_axis, 80, 450 )
		Turn2( luparm, z_axis, -55, 500 )		


		Sleep(300)
		EmitSfx(emit_r,SPARKLES)		
		EmitSfx(emit_l,SPARKLES)				
		Sleep(200)
			Turn2( chest, x_axis, 0, 400 )
			Turn2( chest, y_axis, 0, 400 )
			Turn2( chest, z_axis, 0, 400 )
			Turn2( ruparm, x_axis, 0, 400 )
			Turn2( ruparm, y_axis, 0, 400 )
			Turn2( ruparm, z_axis, 0, 400 )
			Turn2( rloarm, x_axis, 0, 400 )
			Turn2( rloarm, y_axis, 0, 400 )
			Turn2( rloarm, z_axis, 0, 400 )
			Turn2( rhand, x_axis, 0, 400 )
			Turn2( rhand, y_axis, 0, 400 )
			Turn2( rhand, z_axis, 0, 400 )	
			
			Turn2( luparm, x_axis, 0, 400 )
			Turn2( luparm, y_axis, 0, 400 )
			Turn2( luparm, z_axis, 0, 400 )
			Turn2( lloarm, x_axis, 0, 400 )
			Turn2( lloarm, y_axis, 0, 400 )
			Turn2( lloarm, z_axis, 0, 400 )
			Turn2( lhand, x_axis, 0, 400 )
			Turn2( lhand, y_axis, 0, 400 )
			Turn2( lhand, z_axis, 0, 400 )				
			
			WaitForTurn(chest, x_axis)
			WaitForTurn(chest, y_axis)
			WaitForTurn(chest, z_axis)
			WaitForTurn(ruparm, x_axis)
			WaitForTurn(ruparm, y_axis)
			WaitForTurn(ruparm, z_axis)
			WaitForTurn(rloarm, x_axis)
			WaitForTurn(rloarm, y_axis)
			WaitForTurn(rloarm, z_axis)
			WaitForTurn(rhand, x_axis)
			WaitForTurn(rhand, y_axis)
			WaitForTurn(rhand, z_axis)
			Sleep(200)			
	end
	Sleep(100)	
	attacking=false
	isparrying = false
	return(1)	
end

function script.StopBuilding()
	SetUnitValue(COB.INBUILDSTANCE, 0)
end

function script.StartBuilding(heading, pitch) 
	SetUnitValue(COB.INBUILDSTANCE, 1)
end

function script.QueryNanoPiece()
--	GG.LUPS.QueryNanoPiece(unitID,unitDefID,Spring.GetUnitTeam(unitID),nanospray)
	return base
end

function script.Killed( damage, health )
		Turn2( pelvis, x_axis, 90, 250 )
		Turn2( luparm, x_axis, -137, 15 )
		Turn2( ruparm, x_axis, 170, 15 )
		Turn2( rthigh, x_axis, 21, 15 )
		Turn2( rthigh, z_axis, -64, 15 )
		Turn2( rleg, z_axis, 252, 15 )
		Move( base, y_axis, -50, 400)
		Sleep (200)
		EmitSfx(pelvis,BLOODSPRAY)
		EmitSfx(head,BLOODSPRAY)
		return (1)
end