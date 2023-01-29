-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" ) 
local scene = composer.newScene()

local m_image
local m_text
local m_cnt
local syrup_cnt
local syrup_image
local syrup_text
local box1 
local choco
local vanilla
local strawberry

function scene:create( event )
	local sceneGroup = self.view
	--ingredient = 0 -- 선택안할때 대비

	-- 배경 --
	local s_background = display.newImage("Content/image/syrup_choice.png", display.contentWidth, display.contentHeight)
	s_background.x, s_background.y = display.contentWidth/2, display.contentHeight/2
	local syrup_box =  display.newImage("Content/image/syrup_box.png", display.contentWidth*0.496, display.contentHeight*0.534)
	local m = composer.getVariable("m")
	--m_image = display.newImage("m")
	print(m)
	if m == 1 then 
		m_image = display.newImage("Content/image/glitter.png", display.contentWidth * 0.76, display.contentHeight * 0.515)
		m_text = display.newText("반짝이", display.contentWidth * 0.765, display.contentHeight * 0.562, "Content/font/ONE Mobile POP.ttf", 33.5)
		m_text:setFillColor(0)
	    m_cnt = display.newText("보유 개수 : "..ingreCnt[5], display.contentWidth * 0.795, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
		m_cnt:setFillColor(0)
	elseif m == 2 then
		m_image = display.newImage("Content/image/sausage.png", display.contentWidth * 0.76, display.contentHeight * 0.515)
		m_text = display.newText("소세지", display.contentWidth * 0.765, display.contentHeight * 0.562, "Content/font/ONE Mobile POP.ttf", 33.5)
		m_text:setFillColor(0)
	    m_cnt = display.newText("보유 개수 : "..ingreCnt[6], display.contentWidth * 0.795, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
		m_cnt:setFillColor(0)
	elseif m == 3 then 
		m_image = display.newImage("Content/image/bean.png", display.contentWidth * 0.76, display.contentHeight * 0.51)
		m_text = display.newText("팥", display.contentWidth * 0.765, display.contentHeight * 0.561, "Content/font/ONE Mobile POP.ttf", 33.5)
		m_text:setFillColor(0)
	    m_cnt = display.newText("보유 개수 : "..ingreCnt[7], display.contentWidth * 0.795, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
		m_cnt:setFillColor(0)
	elseif m == 4 then 
		m_image = display.newImage("Content/image/cheese.png", display.contentWidth * 0.76, display.contentHeight * 0.515)
		m_text = display.newText("치즈", display.contentWidth * 0.765, display.contentHeight * 0.562, "Content/font/ONE Mobile POP.ttf", 33.5)
		m_text:setFillColor(0)
	    m_cnt = display.newText("보유 개수 : "..ingreCnt[8], display.contentWidth * 0.795, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
		m_cnt:setFillColor(0)
	elseif m == 5 then 
		m_image = display.newImage("Content/image/corn.png", display.contentWidth * 0.765, display.contentHeight * 0.51)
		m_text = display.newText("옥수수", display.contentWidth * 0.765, display.contentHeight * 0.562, "Content/font/ONE Mobile POP.ttf", 33.5)
		m_text:setFillColor(0)
	    m_cnt = display.newText("보유 개수 : "..ingreCnt[9], display.contentWidth * 0.795, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
		m_cnt:setFillColor(0)
	elseif m == 6 then 
		m_image= display.newImage("Content/image/oreopowder.png", display.contentWidth * 0.76, display.contentHeight * 0.515)
		m_text = display.newText("오레오가루", display.contentWidth * 0.765, display.contentHeight * 0.562, "Content/font/ONE Mobile POP.ttf", 33.5)
		m_text:setFillColor(0)
	    m_cnt = display.newText("보유 개수 : "..ingreCnt[10], display.contentWidth * 0.795, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
		m_cnt:setFillColor(0)
	elseif m == 7 then 
		m_image= display.newImage("Content/image/sugarpowder.png", display.contentWidth * 0.764, display.contentHeight * 0.515)
		m_text = display.newText("슈가파우더", display.contentWidth * 0.765, display.contentHeight * 0.562, "Content/font/ONE Mobile POP.ttf", 33.5)
		m_text:setFillColor(0)
	    m_cnt = display.newText("보유 개수 : "..ingreCnt[11], display.contentWidth * 0.795, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
		m_cnt:setFillColor(0)
	end

	box1 = display.newImage("Content/image/box1.png", display.contentWidth*0.492, display.contentHeight*0.651)

	--재료칸 클릭시--
	local material_box =  display.newImage("Content/image/material_box.png", display.contentWidth*0.762, display.contentHeight*0.534)
	local function myTouchListener( event )
 
	    if ( event.phase == "began" ) then
	    	audio.play( soundTable["clickSound"],  {channel=5}) 
	    	composer.setVariable("s", syrub)
	    	ingredient = 0
	    	composer.setVariable("m", ingredient)
	        composer.gotoScene("material")
		end
	end
 
	material_box:addEventListener("touch", myTouchListener)

	--초코 시럽--
	choco = display.newImage("Content/image/choco.png", display.contentWidth * 0.35, display.contentHeight * 0.624)
	--hoco.x, choco.y = display.contentWidth * 0.505, display.contentHeight * 2.31

	local function choco_button( event ) 
 		syrub = 1
	    if ( event.phase == "began" ) then
	    	audio.play( soundTable["clickSound"],  {channel=5}) 
	    	display.remove( syrup_image )
	   		syrup_image = display.newImage("Content/image/choco_syrup.png", display.contentWidth*0.495, display.contentHeight*0.517)
	    	display.remove(syrup_cnt)
	    	syrup_cnt = display.newText("보유 개수 : "..ingreCnt[2], display.contentWidth * 0.53, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
			syrup_cnt:setFillColor(0)
	    	display.remove(syrup_text)
	    	syrup_text = display.newText("초코 시럽", display.contentWidth * 0.5, display.contentHeight * 0.562, "Content/font/ONE Mobile POP.ttf", 33.5)
			syrup_text:setFillColor(0)
	    	composer.setVariable("s", syrub)
			--syrup_image.x, syrup_image.y = display.contentWidth * 0.505, display.contentHeight * 0.78
		end
	end
 
	choco:addEventListener( "touch", choco_button )

	--딸기 시럽--
	strawberry = display.newImage("Content/image/strawberry.png", display.contentWidth * 0.484, display.contentHeight * 0.623)
	--strawberry.x, strawberry.y = display.contentWidth * 0.63, display.contentHeight * 2.29

	local function strawberry_button( event ) 
 		syrub = 2
	    if ( event.phase == "began" ) then
	    	audio.play( soundTable["clickSound"],  {channel=5}) 
	    	display.remove( syrup_image )
	   		syrup_image = display.newImage("Content/image/strawberry_syrup.png", display.contentWidth*0.495, display.contentHeight*0.517)
	    	display.remove(syrup_cnt)
	    	syrup_cnt = display.newText("보유 개수 : "..ingreCnt[3], display.contentWidth * 0.53, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
			syrup_cnt:setFillColor(0)
	    	display.remove(syrup_text)
	    	syrup_text = display.newText("딸기 시럽", display.contentWidth * 0.5, display.contentHeight * 0.562, "Content/font/ONE Mobile POP.ttf", 33.5)
			syrup_text:setFillColor(0)
	    	composer.setVariable("s", syrub)
			--syrup_image.x, syrup_image.y = display.contentWidth * 0.495, display.contentHeight * 0.65
		end
	end
 
	strawberry:addEventListener( "touch", strawberry_button )

	--바닐라 시럽--
	vanilla = display.newImage("Content/image/vanilla.png", display.contentWidth * 0.63, display.contentHeight * 0.624)
	--vanilla.fill.effect = "filter.brightness"
	--vanilla.fill.effect.intensity = 0.4

	local function vinailla_button( event ) 
 		syrub = 3
		print("바닐라"..syrub)
	    if ( event.phase == "began" ) then
	    	audio.play( soundTable["clickSound"],  {channel=5}) 
	    	display.remove( syrup_image )
	   		syrup_image = display.newImage("Content/image/vanilla_syrup.png", display.contentWidth*0.495, display.contentHeight*0.517)
	    	display.remove(syrup_cnt)
	    	syrup_cnt = display.newText("보유 개수 : "..ingreCnt[4], display.contentWidth * 0.53, display.contentHeight * 0.484, "Content/font/ONE Mobile POP.ttf", 23)
			syrup_cnt:setFillColor(0)
	    	display.remove(syrup_text)
	    	syrup_text = display.newText("바닐라 시럽", display.contentWidth * 0.5, display.contentHeight * 0.562, "Content/font/ONE Mobile POP.ttf", 33.5)
			syrup_text:setFillColor(0)
	    	composer.setVariable("s", syrub)
			--syrup_image.x, syrup_image.y = display.contentWidth * 0.49, display.contentHeight * 0.55
		end
	end
 
	vanilla:addEventListener( "touch", vinailla_button )

	--굽기 버튼--
	local start_button = display.newImage("Content/image/start.png", display.contentWidth*0.5, display.contentHeight*0.71)

	local function start( event )
		audio.play( soundTable["clickSound"],  {channel=5}) 
		-- 시럽 재료 둘 다 선택x
		if m == 0 and syrub == 0 then 
	    	showCoin.isVisible = true
	        composer.gotoScene("plus")
		end
		--시럽만 선택
		if m == 0 and syrub ~= 0 then 
			if ingreCnt[syrub + 1] > 0 then 
				ingreCnt[syrub + 1] = ingreCnt[syrub + 1] - 1
	    		showCoin.isVisible = true
	        	composer.gotoScene("plus")
	        end
	    end
	    --재료만 선택
	    if m ~= 0 and syrub == 0 then 
	    	if ingreCnt[m + 4] > 0 then 
				ingreCnt[m + 4] = ingreCnt[m + 4] - 1
	    		showCoin.isVisible = true
	        	composer.gotoScene("plus")
	        end
	    end
	    --시럽 재료 둘 다 선택
	    if m ~= 0 and syrub ~= 0 then 
	    	if ingreCnt[m + 4] > 0 and ingreCnt[syrub + 1] > 0 then 
				ingreCnt[m + 4] = ingreCnt[m + 4] - 1
				ingreCnt[syrub + 1] = ingreCnt[syrub + 1] - 1
	    		showCoin.isVisible = true
	        	composer.gotoScene("plus")
	        end
	    end
	end
	start_button:addEventListener("touch", start)


	--닫기 버튼--
	local close_button = display.newImage("Content/images/시작/close.png", display.contentWidth*0.872, display.contentHeight*0.355)

	local function close( event )
 
	    if ( event.phase == "began" ) then
	    	audio.play( soundTable["clickSound"],  {channel=5}) 
	    	showCoin.isVisible = true
			syrub = 0
			ingredient = 0
			composer.setVariable("m", syrub)
			composer.setVariable("s", ingredient)
	        composer.gotoScene("home")
		end
	end
	close_button:addEventListener("touch", close)


	--레이어 정리--
	sceneGroup:insert( s_background )
	sceneGroup:insert( syrup_box )
	sceneGroup:insert( material_box )
	--sceneGroup:insert( m_image )
	--sceneGroup:insert( syrup_image )
	sceneGroup:insert( box1 )

	sceneGroup:insert(choco)
	sceneGroup:insert(vanilla)
	sceneGroup:insert(strawberry)
	
	--[[
	if syrub == 1 then
		sceneGroup:insert( syrup_image )
	elseif syrub == 2 then 
		sceneGroup:insert( syrup_image )
	elseif syrub == 3 then
		sceneGroup:insert( syrup_image )
	end
	]]

	sceneGroup:insert( start_button )
	sceneGroup:insert( close_button )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		---deleteBeforeNum()
		---deleteBeforeLevel()
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
		--forCoin()
		--forLevel()
		
		composer.removeScene("syrup")
		if m_image ~= nil then 
			m_image:removeSelf()
		end
		if m_text ~= nil then 
			m_text:removeSelf()
		end
		if m_cnt ~= nil then 
			m_cnt:removeSelf()
		end
		if syrup_image ~= nil then
			syrup_image:removeSelf() 
		end
		if syrup_text ~= nil then
			syrup_text:removeSelf() 
		end
		if syrup_cnt ~= nil then 
			syrup_cnt:removeSelf()
		end

		
--[[	choco:removeSelf()
			vanilla:removeSelf()
			strawberry:removeSelf()
		if choco == 1 then
			choco:removeSelf()
		elseif vanilla == 1 then
			vanilla:removeSelf()
		elseif strawberry == 1 then
			strawberry:removeSelf()
	end]]

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
