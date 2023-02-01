-----------------------------------------------------------------------------------------
--
-- opening.lua
--
-----------------------------------------------------------------------------------------
local loadsave = require( "loadsave" )
local composer = require( "composer" )
local scene = composer.newScene()
--local json = require( "json" ) 

--사운드
soundTable = {
	--backgroundMusic = audio.loadStream("Content/audio/background.mp3"),
	bombSound = audio.loadSound( "Content/audio/bomb.wav" ),
	breadSound = audio.loadSound( "Content/audio/bread.wav" ),
	cashSound = audio.loadSound( "Content/audio/cash.wav" ),
	clickSound = audio.loadSound( "Content/audio/click.wav" ),
	levelUpSound = audio.loadSound( "Content/audio/levelUp.wav" ),
	rewardSound = audio.loadSound( "Content/audio/reward.wav"  )
}

-- 빵의 개수 --breadsCnt
breadsCnt = { {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, 
				{0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0} ,{0, 0, 0, 0, 0, 0, 0, 0}	}
UbreadsCnt = { {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, 
				{0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0} 		}
-- 새빵 (미해금0 , 해금 -1, 확인했음 1로 변화) 
openBread = { {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, 
            {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0} ,{0, 0, 0, 0, 0, 0, 0, 0}}
openUBread = { {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, 
            {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0} } 
-- 빵레벨
Bread_level = { {1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1}, 
				{1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1} }
--업적달성
quest_clear = {{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}
--quest_clear = {}
--for i = 1, 7 do
--	quest_clear[i] = {}
--end
--보상받음
price_have = {{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}
--price_have = {}
--for i = 1, 7 do
--	price_have[i] = {}
--end

function scene:create( event )
	local sceneGroup = self.view
	--배경화면
	local background = display.newImage("Content/images/시작/openingBG.png", display.contentCenterX, display.contentCenterY,
		display.contentWidth, display.contentHeight)
	--제목
	local title = display.newImage("Content/images/시작/title.png", display.contentWidth/2, display.contentHeight*0.15)
	--설정 이미지
	local setting = display.newImage("Content/images/시작/setting.png", display.contentWidth*0.92, display.contentHeight*0.04)	
	--클릭 텍스트
	local clickText = display.newText("여기를 터치하여 시작하세요", display.contentWidth/2, display.contentHeight*0.24, "Content/font/ONE Mobile POP.ttf", 60)
	transition.blink( clickText , { time=1700 })
	--음악 설정 그룹
	local settingGroup = display.newGroup()
	--음악 설정 상자
	local soundBox = display.newImage(settingGroup, "Content/images/시작/soundBox.png", display.contentWidth/2, display.contentHeight/2)
	--음악 설정 글
	local settingText = display.newImage(settingGroup, "Content/images/시작/settingIcon.png", display.contentWidth/2, display.contentHeight*0.355)
	--효과음 글
	local soundEffectText = display.newImage(settingGroup, "Content/images/시작/SEIcon.png", display.contentWidth*0.25, display.contentHeight*0.48)
	--배경음악 글
	local BGMText = display.newImage(settingGroup, "Content/images/시작/BGMIcon.png", display.contentWidth*0.25, display.contentHeight*0.575)
	--창 닫기
	local close = display.newImage(settingGroup, "Content/images/시작/close.png", display.contentWidth*0.88, display.contentHeight*0.33)
	--개발정보 아이콘
	local develop = display.newImage("Content/images/시작/devInfo.png", display.contentWidth*0.81, display.contentHeight*0.04)
	
	--효과음on/off
	local soundEffectOn = {}
	local soundEffectOff = {}
	--배경음악 on/off
	local BGMOn = {}
	local BGMOff = {}
	--효과음&배경음악 소리 조절 디자인
	for i = 1, 18 do
		soundEffectOff[i] = display.newImage(settingGroup, "Content/images/시작/soundOff.png", display.contentWidth*0.48 + ((i - 1) * 28), display.contentHeight*0.477)
		soundEffectOn[i] = display.newImage(settingGroup, "Content/images/시작/soundOn.png", display.contentWidth*0.48 + ((i - 1) * 28), display.contentHeight*0.477)
		BGMOff[i] = display.newImage(settingGroup, "Content/images/시작/soundOff.png", display.contentWidth*0.48 + ((i - 1) * 28), display.contentHeight*0.577)
		BGMOn[i] = display.newImage(settingGroup, "Content/images/시작/soundOn.png", display.contentWidth*0.48 + ((i - 1) * 28), display.contentHeight*0.577)
	end	
	--효과음 아이콘
	local soundEffectImg = display.newImage(settingGroup, "Content/images/시작/soundEffect.png", display.contentWidth*0.4, display.contentHeight*0.472)
	--배경음악 아이콘
	local BGMImg = display.newImage(settingGroup, "Content/images/시작/BGM.png", display.contentWidth*0.4, display.contentHeight*0.576)
	--효과음 조절 바
	local soundEffectBar = display.newImage(settingGroup, "Content/images/시작/soundBar.png")
	--배경음악 조절 바
	local BGMBar = display.newImage(settingGroup, "Content/images/시작/soundBar.png")
	
	--배경음악
	local BGM = audio.loadSound("Content/audio/background.mp3")
	audio.play(BGM, {channel=1, loops=-1})
	--배경음악 설정
	audio.setMaxVolume(1, { channel=1 })
	audio.setVolume(0.5, {channel=1})
	
	--효과음
	--버튼 클릭
	SE1 = audio.loadSound("Content/audio/click.wav")
	--보상 획득
	--SE2 = audio.loadSound("sound/보상 획득/코드2/코드2.wav")
	--동전 소리
	--빵 완성
	--폭탄빵 완성
	--레벨업

	--효과음 설정
	for i=2,7 do
		audio.setMaxVolume(1, { channel=i })
		audio.setVolume(0.5, {channel=i})
	end


-------음악 기본 설정-------------
	soundEffectBar.x, soundEffectBar.y = display.contentWidth*0.48 + 224, display.contentHeight*0.474
	BGMBar.x, BGMBar.y = display.contentWidth*0.48 + 224, display.contentHeight*0.576
	
	for i = 1, 9 do
		soundEffectOn[i].isVisible = true
		BGMOn[i].isVisible = true
		soundEffectOff[i].isVisible = false
		BGMOff[i].isVisible = false
	end
	for i = 10, 18 do
		soundEffectOn[i].isVisible = false
		BGMOn[i].isVisible = false
		soundEffectOff[i].isVisible = true
		BGMOff[i].isVisible = true
	end
---------------------------------


	-------설정 클릭 시 창 나오기-------
	local function pop(event)
		audio.play(SE1, {channel=5})
		settingGroup:toFront()
	end
	setting:addEventListener("tap", pop)


	-------창 닫기--------------------
	local function exit(event)
		audio.play(SE1, {channel=5})
		settingGroup:toBack()
	end
	close:addEventListener("tap", exit)



	-------개발 정보--------------------
	local function devInfo(event)
		audio.play(SE1, {channel=5})
		composer.gotoScene("dev", options)
	end
	develop:addEventListener("tap", devInfo)



	----넝어가기-----------------------
	local function start(event)
		local options = {
			effect = "crossFade",
			time = 200
		}
		audio.play(SE1, {channel=5})
		composer.gotoScene("intro", options)
	end
	clickText:addEventListener("tap", start)
	


	---저장 데이터 시도---------------------------
	local gameSettings = {
		coinDB = 3000;
	}
	loadsave.saveTable(gameSettings, "gameData.json");


	-----------효과음/배경음 조절----------


	local function BGMscroll( event )
		if ( event.phase == "began" ) then
			display.getCurrentStage():setFocus( event.target )
			event.target.isFocus = true

			event.target.xStart = event.target.x

		elseif ( event.phase == "moved" ) then
			if ( event.target.isFocus ) then
				event.target.x = event.target.xStart + event.xDelta
				if event.target.x < display.contentWidth*0.48  then		--왼쪽으로 이탈 방지
					event.target.x = display.contentWidth*0.48
				end
				if event.target.x > display.contentWidth*0.8 then		--오른쪽으로 이탈 방지
					event.target.x = display.contentWidth*0.48 + 476
				end
				for i = 1, 18 do
					if BGMBar.x > BGMOff[i].x then
						BGMOff[i].isVisible = false
						BGMOn[i].isVisible = true
					else
						BGMOff[i].isVisible = true
						BGMOn[i].isVisible = false
					end
				end

			end
				local BGMvolume = event.target.x/(4.76+0.48)/100 - 1.33
				audio.setVolume(BGMvolume, {channel=1})	
				if event.target.x == display.contentWidth*0.48 then		--볼륨 최소(음소거)
					audio.setVolume(0, {channel=1})
				end
				if event.target.x == display.contentWidth*0.48 + 476 then	--볼륨 최대
					audio.setVolume(1, {channel=1})
				end

		elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
			if ( event.target.isFocus ) then
			display.getCurrentStage():setFocus( nil )
			event.target.isFocus = false
			end
			display.getCurrentStage():setFocus( nil )
			event.target.isFocus = false
		end
	end
	BGMBar:addEventListener("touch", BGMscroll)
-----------------
	local function soundEffectscroll( event )
		if ( event.phase == "began" ) then
			display.getCurrentStage():setFocus( event.target )
			event.target.isFocus = true

			event.target.xStart = event.target.x

		elseif ( event.phase == "moved" ) then
			if ( event.target.isFocus ) then
				event.target.x = event.target.xStart + event.xDelta	
				if event.target.x < display.contentWidth*0.48  then 		--왼쪽으로 이탈 방지
					event.target.x = display.contentWidth*0.48				
				end
				if event.target.x > display.contentWidth*0.8 then			--오른쪽으로 이탈 방지
					event.target.x = display.contentWidth*0.48 + 476		
				end
				for i = 1, 18 do
					if  soundEffectBar.x >  soundEffectOff[i].x then
						soundEffectOff[i].isVisible = false
						 soundEffectOn[i].isVisible = true
					else
						 soundEffectOff[i].isVisible = true
						 soundEffectOn[i].isVisible = false
					end
				end
			end
				SEvolume = event.target.x/(4.76+0.48)/100 - 1.33
				for i = 2, 7 do
					audio.setVolume(SEvolume, {channel=i})	
					if event.target.x == display.contentWidth*0.48 then			--음소거
						audio.setVolume(0, {channel=i})
					end
					if event.target.x == display.contentWidth*0.48 + 476 then	--볼륨 최대
						audio.setVolume(1, {channel=i})
					end
				end

		elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
			if ( event.target.isFocus ) then
			display.getCurrentStage():setFocus( nil )
			event.target.isFocus = false
			end
			display.getCurrentStage():setFocus( nil )
			event.target.isFocus = false
		end
	end
	 soundEffectBar:addEventListener("touch",  soundEffectscroll)


	-- 레이어 정리
	sceneGroup:insert(settingGroup)
	sceneGroup:insert(background)
	sceneGroup:insert(title)
	sceneGroup:insert(setting)
	sceneGroup:insert(clickText)
	sceneGroup:insert(develop)
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
		--composer.removeScene("opening")
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