-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	---forCoin()
	---forLevel()
	
	-- 배경 --
	--local s_background = display.newImage("Content/image/main_image.png", display.contentWidth/2, display.contentHeight/2)
	local background = display.newImage("Content/images/인트로/face_love.png")
	background.x, background.y = display.contentCenterX, display.contentCenterY

	--local oven = display.newImageRect("Content/images/oven.png", 1550, 820)
	--oven.x, oven.y = display.contentCenterX, display.contentHeight*0.9

	local level = display.newImage("Content/images/level.png")
	level.x, level.y = display.contentWidth*0.07, display.contentHeight*0.04

	local showLevel = display.newText(levelNum, display.contentWidth*0.075, display.contentHeight*0.045, "Content/font/ONE Mobile POP.ttf", 90)
	showLevel:setFillColor(1)

	local book = display.newImage("Content/images/book.png");
	book.x, book.y =  display.contentWidth*0.73, display.contentHeight*0.05
	local s_book = display.newImage("Content/images/shadow.png")
	s_book.x, s_book.y = display.contentWidth*0.73, display.contentHeight*0.06
	local text_book = display.newImage("Content/images/text_Book2.png")
	text_book.x, text_book.y = display.contentWidth*0.73, display.contentHeight*0.081

	local store = display.newImageRect("Content/images/store.png", 170, 170)
	store.x, store.y = display.contentWidth*0.904, display.contentHeight*0.047
	local s_store = display.newImage("Content/images/shadow.png")
	s_store.x, s_store.y = display.contentWidth*0.9, display.contentHeight*0.06
	local text_store = display.newImage("Content/images/text_store.png")
	text_store.x, text_store.y = display.contentWidth*0.9, display.contentHeight*0.08

	local coins = display.newImage("Content/images/coins.png")
	coins.x, coins.y = display.contentWidth*0.5, display.contentHeight*0.04

	local levelUp_s = display.newImage("Content/images/levelUp_s2.png")
	levelUp_s.x, levelUp_s.y = display.contentWidth*0.24, display.contentHeight*0.04


	gauge = display.newImageRect("Content/images/gauge.png", 300, 50)
	gauge.x, gauge.y = 345, 100
	gauge.isVisible = false
	
	--경험치 추가--
	local expHint = ""

	if levelNum < 10 then
		expHint = exp .. " / ".. expList[levelNum+1]
		
		gauge = display.newImageRect("Content/images/gauge.png", 300 * exp / expList[levelNum+1], 50)
		gauge.x, gauge.y = 345 - (300 * (expList[levelNum+1] - exp) / expList[levelNum+1]) / 2, 100
	else
		expHint = "최고레벨입니다."
	end

	expDisplay = display.newText(expHint, display.contentWidth*0.24, display.contentHeight*0.04, "Content/font/ONE Mobile POP.ttf")
	expDisplay:setFillColor(1)
	expDisplay.size = 25

	local success = display.newImage("Content/images/success.png")
	success.x, success.y =  display.contentWidth*0.73, display.contentHeight*0.14
	local s_success = display.newImage("Content/images/shadow.png")
	s_success.x, s_success.y = display.contentWidth*0.73, display.contentHeight*0.145
	local text_success = display.newImage("Content/images/text_acheivements.png")
	text_success.x, text_success.y = display.contentWidth*0.73, display.contentHeight*0.17

	local breadRoom = display.newImageRect("Content/images/breadRoom2.png", 130, 90)
	breadRoom.x, breadRoom.y =  display.contentWidth*0.9, display.contentHeight*0.138
	local s_breadRoom = display.newImage("Content/images/shadow.png")
	s_breadRoom.x, s_breadRoom.y = display.contentWidth*0.9, display.contentHeight*0.145
	local text_breadRoom = display.newImage("Content/images/text_breadRoom.png")
	text_breadRoom.x, text_breadRoom.y = display.contentWidth*0.9, display.contentHeight*0.17


	--재료 추가 버튼--
	local material_button = display.newImage("Content/image/material_button.png", display.contentWidth, display.contentHeight)
	material_button.x, material_button.y = display.contentWidth * 0.138, display.contentHeight * 0.444

	-- 로딩 아이콘 --
	local loading = display.newImageRect("Content/image/loading.png", 300, 300)
	loading.x, loading.y = display.contentWidth * 0.45, display.contentHeight * 0.86

	-- 회전 넣기 --
	local function rock1()
		transition.to(loading, {rotation=-360, time=15000})
	end
	
	timer.performWithDelay(900, rock1, 1)

	--시간 카운트--
	local limit = 3
	local showLimit = display.newText(limit, display.contentWidth*0.457, display.contentHeight*0.86, "Content/font/ONE Mobile POP.ttf")
	showLimit:setFillColor(1)
	showLimit.size = 100


    --print("시럽은 " .. syrub .. "재료는" .. ingredient)

	local function timeAttack(event)
		limit = limit - 1
		showLimit.text = limit
		
		if limit == 0 then
			composer.gotoScene("result")
		end
	end

	timer.performWithDelay(1000, timeAttack, 0) 

	sceneGroup:insert( background )

	--sceneGroup:insert( oven )
	sceneGroup:insert( levelUp_s )
	sceneGroup:insert( level )
	sceneGroup:insert( showLevel )
	sceneGroup:insert( gauge )
	sceneGroup:insert( expDisplay )
	sceneGroup:insert( coins )
	sceneGroup:insert( s_book ) sceneGroup:insert( book ) sceneGroup:insert( text_book )
	sceneGroup:insert( s_store ) sceneGroup:insert( store ) sceneGroup:insert( text_store )
	sceneGroup:insert( s_success ) sceneGroup:insert( success ) sceneGroup:insert( text_success )
	sceneGroup:insert( s_breadRoom ) sceneGroup:insert( breadRoom ) sceneGroup:insert( text_breadRoom )
	sceneGroup:insert( material_button )
	sceneGroup:insert(loading)
	sceneGroup:insert(showLimit)
--[[
	--재료 추가 버튼--
	local material_button = display.newImage("Content/image/material_button.png", display.contentWidth, display.contentHeight)
	material_button.x, material_button.y = display.contentWidth * 0.138, display.contentHeight * 0.444

	local function plus( event )
 
	    if ( event.phase == "began" ) then
	        composer.gotoScene("syrup")
		end
	end
	material_button:addEventListener("touch", plus)]]

	--sceneGroup:insert(s_background)
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
	elseif phase == "did" then
		-- Called when the scene is now off screen
		composer.removeScene("plus")
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
