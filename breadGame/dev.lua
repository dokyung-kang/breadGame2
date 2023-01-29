-----------------------------------------------------------------------------------------
--
-- dev.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	--배경화면
	local background = display.newImage("Content/images/개발/BG.png", display.contentCenterX, display.contentCenterY,
		display.contentWidth, display.contentHeight)
	--소개
	local creator = display.newText("CREATOR", display.contentWidth/2, display.contentHeight*0.12, "Content/font/ONE Mobile POP.ttf", 70)
	creator:setFillColor(0)
	local develop = display.newText("개발", display.contentWidth/2, display.contentHeight*0.22, "Content/font/ONE Mobile POP.ttf", 65)
	develop:setFillColor(0)
	local name1 = display.newText("서한나    이미지    정유영", display.contentWidth/2, display.contentHeight*0.27, "Content/font/ONE Mobile POP.ttf", 60)
	name1:setFillColor(0.4)
	local name2 = display.newText("강도경    이다솔", display.contentWidth/2, display.contentHeight*0.32, "Content/font/ONE Mobile POP.ttf", 60)
	name2:setFillColor(0.4)
	local disign = display.newText("디자인", display.contentWidth/2, display.contentHeight*0.39, "Content/font/ONE Mobile POP.ttf", 65)
	disign:setFillColor(0)
	local name3 = display.newText("조예진", display.contentWidth/2, display.contentHeight*0.44, "Content/font/ONE Mobile POP.ttf", 60)
	name3:setFillColor(0.4)
	local scenario = display.newText("시나리오", display.contentWidth/2, display.contentHeight*0.51, "Content/font/ONE Mobile POP.ttf", 65)
	scenario:setFillColor(0)
	local name4 = display.newText("이한얼", display.contentWidth/2, display.contentHeight*0.56, "Content/font/ONE Mobile POP.ttf", 60)
	name4:setFillColor(0.4)
	local font = display.newText("폰트", display.contentWidth/2, display.contentHeight*0.64, "Content/font/ONE Mobile POP.ttf", 50)
	font:setFillColor(0.2)
	local fontinfo = display.newText("(주)원스토어, ONE 모바일 POP체", display.contentWidth/2, display.contentHeight*0.67, "Content/font/ONE Mobile POP.ttf", 30)
	fontinfo:setFillColor(0.4)
	local BGM = display.newText("배경음악", display.contentWidth/2, display.contentHeight*0.73, "Content/font/ONE Mobile POP.ttf", 50)
	BGM:setFillColor(0.2)
	local BGMinfo = display.newText("Cute cooking time_bgmworld.com  by _bgmworld.com", display.contentWidth/2, display.contentHeight*0.76, "Content/font/ONE Mobile POP.ttf", 30)
	BGMinfo:setFillColor(0.4)
	local soundEffect = display.newText("효과음", display.contentWidth/2, display.contentHeight*0.82, "Content/font/ONE Mobile POP.ttf", 50)
	soundEffect:setFillColor(0.2)
	local soundEffectinfo1 = display.newText("K드라마 효과음 (76) by 김용배, CC BY 라이선스", display.contentWidth/2, display.contentHeight*0.85, "Content/font/ONE Mobile POP.ttf", 30)
	soundEffectinfo1:setFillColor(0.4)
	local soundEffectinfo2 = display.newText("코드32 by 김용배, CC BY 라이선스", display.contentWidth/2, display.contentHeight*0.87, "Content/font/ONE Mobile POP.ttf", 30)
	soundEffectinfo2:setFillColor(0.4)
	local soundEffectinfo3 = display.newText("코드2 by 김용배, CC BY 라이선스", display.contentWidth/2, display.contentHeight*0.89, "Content/font/ONE Mobile POP.ttf", 30)
	soundEffectinfo3:setFillColor(0.4)
	local soundEffectinfo4 = display.newText("코드7 by 김용배, CC BY 라이선스", display.contentWidth/2, display.contentHeight*0.91, "Content/font/ONE Mobile POP.ttf", 30)
	soundEffectinfo4:setFillColor(0.4)
	local soundEffectinfo5 = display.newText("코드19 by 김용배, CC BY 라이선스", display.contentWidth/2, display.contentHeight*0.93, "Content/font/ONE Mobile POP.ttf", 30)
	soundEffectinfo5:setFillColor(0.4)
	local soundEffectinfo6 = display.newText("코드3 by 김용배, CC BY 라이선스", display.contentWidth/2, display.contentHeight*0.95, "Content/font/ONE Mobile POP.ttf", 30)
	soundEffectinfo6:setFillColor(0.4)
	--창 닫기
	local close = display.newImage("Content/images/개발/close.png", display.contentWidth*0.92, display.contentHeight*0.04)
	


	----넝어가기-----------------------
	local function back(event)
		audio.play(SE1, {channel=5})
		composer.gotoScene("opening")
	end
	close:addEventListener("tap", back)
	


	-- 레이어 정리
	sceneGroup:insert(background)
	sceneGroup:insert(creator)
	sceneGroup:insert(develop)
	sceneGroup:insert(disign)
	sceneGroup:insert(scenario)
	sceneGroup:insert(name1)
	sceneGroup:insert(name2)
	sceneGroup:insert(name3)
	sceneGroup:insert(name4)
	sceneGroup:insert(font)
	sceneGroup:insert(fontinfo)
	sceneGroup:insert(BGM)
	sceneGroup:insert(BGMinfo)
	sceneGroup:insert(soundEffect)
	sceneGroup:insert(soundEffectinfo1)
	sceneGroup:insert(soundEffectinfo2)
	sceneGroup:insert(soundEffectinfo3)
	sceneGroup:insert(soundEffectinfo4)
	sceneGroup:insert(soundEffectinfo5)
	sceneGroup:insert(soundEffectinfo6)
	sceneGroup:insert(close)
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