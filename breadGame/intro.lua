-----------------------------------------------------------------------------------------
--
-- intro.lua
--
-----------------------------------------------------------------------------------------

-- JSON 파싱
local json = require('json')

local Data, pos, msg

local function parse()
	local filename = system.pathForFile("Content/JSON/intro.json")
	Data, pos, msg = json.decodeFile(filename)

	--디버그
	if Data then
		print(Data[1].type)
	else
		print(pos)
		print(msg)
	end
	--
end
parse()

local function deco_parse()
	local filename = system.pathForFile("Content/JSON/deco.json")
	deco, pos, msg = json.decodeFile(filename)

	if deco then
		print(deco[1].name)
	else
		print(pos)
		print(msg)
	end
end
deco_parse()

local function carpet_parse()
	local filename = system.pathForFile("Content/JSON/wallPaper.json")
	wallPaper, pos, msg = json.decodeFile(filename)

	if wallPaper then
		print(wallPaper[1].name)
	else
		print(pos)
		print(msg)
	end
end
carpet_parse()
--

-------업적 전역 변수----------
--돈 전역 변수
coinNum = 6000
--폭탄빵 제작 전역변수
bomb_count = 0
--연속 일반빵 제작 전역변수
breadNormal_count = 0
--폭탄빵 연속 제작 전역변수
breadBomb_count = 0
--빵 제작 전역변수
bread_count = 0
--빵 도감 채운 개수 전역변수
breadBook_count = 0
--업그레이드 빵 도감 채운 개수
breadBookUP_count = 0
--빵 방 빵 채운 개수 전역변수
breadRoom_count = 0

--돈 표시--
coinX = 0.584 - (string.len(coinNum)-1)*0.01
showCoin = display.newText(coinNum, display.contentWidth*coinX, display.contentHeight*0.04, "Content/font/ONE Mobile POP.ttf", 42)
showCoin:setFillColor(0)
showCoin.isVisible = false


local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	local windowGroup = display.newGroup()

	--배경화면
	local background = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
	--skip 버튼
	local skip_B = display.newText("SKIP", display.contentWidth*0.92, display.contentHeight*0.04, "Content/font/ONE Mobile POP.ttf")
	skip_B.size = 50
	skip_B:setFillColor(0)
	--말풍선
	local bubble = display.newImage("Content/images/인트로/bubble.png", display.contentWidth/2, display.contentHeight*0.86)

	--local name = display.newImage("Content/images/인트로/name.png", display.contentWidth*0.1, display.contentHeight*0.8, display.contentWidth, display.contentHeight)
	--클릭 버튼
	local click = display.newImage("Content/images/인트로/click.png", bubble.x + 550, bubble.y + 165)
	--대사
	local script = display.newText("더미 텍스트", bubble.x, bubble.y-20, "Content/font/ONE Mobile POP.ttf")
	--script.width = display.contentWidth*0.6
	script.size = 65
	script:setFillColor(0)

	---------------skip하기--------------
	local function skip(event)
		local options = {
			effect = "crossFade",
			time = 200
		}
		showCoin.isVisible = true
		composer.gotoScene("home", options)
	end
	skip_B:addEventListener("tap", skip)

	------------------대사----------------
	local index = 1
	local function nextScript( ... )
		local options = {
			effect = "fade",
			time = 200
		}
		if (index <= #Data) then
			if( Data[index].type == "background" ) then
				
				--배경 바꾸기
				background.fill = {
					type = "image",
					filename = Data[index].img
				}
				index = index + 1
				nextScript()
			
			elseif( Data[index].type == "bubble" ) then
			 
			 	--말풍선
				bubble.fill = {
					type = "image",
					filename = Data[index].img
				}
				index = index + 1
				nextScript()
			
			elseif( Data[index].type == "Narration" ) then
			 
			 	--해설
				 script.text = Data[index].content
				 index = index + 1
			end
		else	
			showCoin.isVisible = true
			composer.gotoScene("home", options)
		end
	end
	nextScript()


	local function tap( event )
		audio.play(SE1, {channel=5})
		audio.stopWithDelay(420, {channel=5})
		nextScript()
	end
	background:addEventListener("tap", tap)

--[[
	windowGroup:insert(background)
	windowGroup:insert(skip_B)
	windowGroup:insert(bubble)
	windowGroup:insert(click)
	windowGroup:insert(script)]]


	-- 레이어 정리
	sceneGroup:insert(background)
	sceneGroup:insert(skip_B)
	sceneGroup:insert(bubble)
	--sceneGroup:insert(name)
	sceneGroup:insert(click)
	sceneGroup:insert(script)


	--windowGroup:removeSelf()
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		exp = 0
		expList = { 0, 1000, 3000, 6000, 10000, 15000, 21000, 28000, 36000, 45000 }
		levelNum = 1

		levelFirstTime = {} -- 경험치가 처음으로 일정 수준을 넘었을 때만 레벨업을 주기 위함. --
			function levelTimeReset() 
				for i=2, 10 do
		 		levelFirstTime[i] = 1 
		 		end
		 		--[[levelFirstTime[0] = 0
		 		levelFirstTime[1] = 0
		 		levelFirstTime[2] = 0
		 		levelFirstTime[3] = 0
		 		levelFirstTime[4] = 0
		 		levelFirstTime[5] = 0
		 		levelFirstTime[6] = 0
		 		levelFirstTime[7] = 0
		 		levelFirstTime[8] = 0
		 		levelFirstTime[9] = 0]]
		 	end
		levelTimeReset() 

		ingreCnt = {} --재료카운트
		for i=1, 11 do
			ingreCnt[i] = 0
		end

		--* 상점과 꾸미기방 연결 --
		decoCnt = {}
		decoFlag = {}

		for i=1, #deco do
		decoCnt[i] = 0
		decoFlag[i] = 0
		end

		wallCnt = {}
		wallPaperFlag = {}

		for i=1, #wallPaper do
		wallCnt[i] = 0
		wallPaperFlag[i] = 0
		end
		--
		decoIndex = {0, 0}
		carpetIndex = 0
		beforeCarpetIndex = 0

		--decoGroup = display.newGroup()
		breadRoom_deco = {nil, nil} -- 물건 놓고 카펫 깔면 물건 가려지는 문제 해결 위함

		-- 꾸미기 신에도 장식 반영
		breadRoom_deco_ver2 = {nil, nil} 
		breadRoom_deco_ver2[1] = display.newImageRect(deco[1].image2, display.contentWidth*0.17, display.contentHeight*0.1)
		breadRoom_deco_ver2[1].x, breadRoom_deco_ver2[1].y = display.contentWidth*0.43, display.contentHeight*0.18
		breadRoom_deco_ver2[2] = display.newImageRect(deco[2].image2, display.contentWidth*0.17, display.contentHeight*0.1)
		breadRoom_deco_ver2[2].x, breadRoom_deco_ver2[2].y = display.contentWidth*0.55, display.contentHeight*0.18

		breadRoom_deco_ver2[1].isVisible = false
		breadRoom_deco_ver2[2].isVisible = false
		-- 

		delete_deco_from_list = {0, 0}

		check_done = {0, 0, 0, 0, 0, 0}
		--check_done2 = {0 ,0}
	elseif phase == "did" then

		
		-- Called when the scene is now off screen
		composer.removeScene("intro")
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene