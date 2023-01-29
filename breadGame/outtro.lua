-----------------------------------------------------------------------------------------
--
-- outtro.lua
--
-----------------------------------------------------------------------------------------

-- JSON 파싱
local json = require('json')

local Data, pos, msg

local function parse()
	local filename = system.pathForFile("Content/JSON/outtro.json")
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
--

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	--배경화면
	local background = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight)
	--skip버튼
	local skip_B = display.newText("SKIP", display.contentWidth*0.92, display.contentHeight*0.04, "Content/font/ONE Mobile POP.ttf")
	skip_B.size = 50
	skip_B:setFillColor(0)
	--말풍선
	local bubble = display.newImage("Content/images/아웃트로/bubble.png", display.contentWidth/2, display.contentHeight*0.86)

	--local name = display.newImage("images/인트로/name.png", display.contentWidth*0.1, display.contentHeight*0.8, display.contentWidth, display.contentHeight)
	--클릭 버튼
	local click = display.newImage("Content/images/아웃트로/click.png", bubble.x + 550, bubble.y + 165)
	--대사
	local script = display.newText("더미 텍스트", bubble.x, bubble.y-20, "Content/font/ONE Mobile POP.ttf")
	--script.width = display.contentWidth*0.6
	script.size = 65
	script:setFillColor(0)

	local function skip(event)
		local options = {
			effect = "crossFade",
			time = 200
		}
		composer.gotoScene("ending", options)
	end
	skip_B:addEventListener("tap", skip)

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
			composer.gotoScene("ending", options)
		end
	end
	nextScript()


	local function tap( event )
		audio.play(SE1, {channel=5})
		audio.stopWithDelay(420, {channel=5})
		nextScript()
	end
	background:addEventListener("tap", tap)

	-- 레이어 정리
	sceneGroup:insert(background)
	sceneGroup:insert(skip_B)
	sceneGroup:insert(bubble)
	--sceneGroup:insert(name)
	sceneGroup:insert(click)
	sceneGroup:insert(script)
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
		composer.removeScene("outtro")
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