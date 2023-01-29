-----------------------------------------------------------------------------------------
--
-- deco.lua
--
-----------------------------------------------------------------------------------------

-- JSON 파싱
local widget = require( "widget" )

local composer = require( "composer" )
local scene = composer.newScene()

local json = require('json')

local function parse()
	local filename = system.pathForFile("Content/JSON/deco.json")
	deco, pos, msg = json.decodeFile(filename)

	if deco then
		print(deco[1].name)
	else
		print(pos)
		print(msg)
	end
end
parse()
local temp
local function gotoBreadRoomFromD(event)
	audio.play( soundTable["clickSound"],  {channel=5}) 
	composer.gotoScene("breadRoom")
	print("빵방으로 가서 아이템 적용")
	
	if event.target.name == "pushBtn" then
		for i=1,2 do
			if decoIndex[i] ~= 0 and decoFlag[decoIndex[i]] == 1 then
			-- 고른 아이템 목록에서 삭제
			
			decoFlag[decoIndex[i]] = 0 
			delete_deco_from_list[decoIndex[i]] = 1
			end
		end

	else
		decoIndex[1] = 0
		decoIndex[2] = 0
	end
	--카펫 체크와 관여되지 않게--
	tempIndex = carpetIndex
	if beforeCarpetIndex ~= 0 then
		print("이전 카펫 인덱스는" .. beforeCarpetIndex)
		carpetIndex = beforeCarpetIndex

		check_done[tempIndex] = 0
		print(tempIndex.."의 check를 해제합니다."..check_done[tempIndex])
		check_done[beforeCarpetIndex] = 1
		print(beforeCarpetIndex.."의 check를 합니다"..check_done[beforeCarpetIndex])
	else
		check_done = {0, 0, 0, 0, 0, 0}
	end
	carpetIndex = 0
end

local background_room1
local background_room2
local background_carpet
local homeIcon
local breadIcon
local text_breadRoom
local coinIcon
local gray_upperLeft
local gray_upperRight
local gray_lowerLeft
local gray_lowerRight
local bookIcon
local text_bookIcon
local store
local text_storeIcon
local temp
local text_tempIcon
local dia
local text_deco
local pushIcon
local text_push 

local carpetChange = -1
local beforeCarpet 

function scene:create( event )
	local sceneGroup = self.view

	--breadRoom.lua 동일 코드 --

    -- 배경 --
	background_room1 = display.newImageRect("Content/images/room1.png", display.contentWidth, display.contentHeight)
	background_room1.x, background_room1.y = display.contentWidth*0.5, display.contentHeight*0.5

	background_room2 = display.newImageRect("Content/images/room2.png", display.contentWidth, display.contentHeight)
	background_room2.x, background_room2.y = display.contentWidth*0.5, display.contentHeight*0.5

	background_carpet = display.newImageRect("Content/images/carpet.png", display.contentWidth, display.contentHeight)
	background_carpet.x, background_carpet.y = display.contentWidth*0.5, display.contentHeight*0.5
	background_carpet.isVisible = false
	
	carpetChange = composer.getVariable("forItemRoomBackground")
	if carpetChange == nil then
		carpetChange = -1
	end
	
	if carpetChange > 0 then -- 배경카펫
		background_carpet = display.newImageRect(wallPaper[carpetChange].image2, display.contentWidth, display.contentHeight)
		background_carpet.x, background_carpet.y = display.contentWidth*0.5, display.contentHeight*0.5
		beforeCarpet = carpetChange
	elseif carpetChange == 0 and beforeCarpet ~= nil then
		background_carpet = display.newImageRect(wallPaper[beforeCarpet].image2, display.contentWidth, display.contentHeight)
		background_carpet.x, background_carpet.y = display.contentWidth*0.5, display.contentHeight*0.5
		beforeCarpet = carpetChange
	end
	
	-- 홈, 빵방, 코인 --
	homeIcon = display.newImageRect("Content/images/home.png", display.contentWidth*0.07, display.contentHeight*0.04)
	homeIcon.x, homeIcon.y = display.contentWidth*0.08, display.contentHeight*0.05

	breadIcon = display.newImageRect("Content/images/breadRoom2.png", display.contentWidth*0.1, display.contentHeight*0.05)
	breadIcon.x, breadIcon.y = display.contentWidth*0.2, display.contentHeight*0.054

	text_breadRoom = display.newImageRect("Content/images/text_breadRoom.png", display.contentWidth*0.46, display.contentHeight*0.27)
	text_breadRoom.x, text_breadRoom.y = display.contentWidth*0.3, display.contentHeight*0.05

	coinIcon = display.newImage("Content/images/coins.png")
	coinIcon.x, coinIcon.y = display.contentWidth*0.525, display.contentHeight*0.05
		
	showCoin.isVisible = true
	coinX = 0.608 - (string.len(coinNum)-1)*0.01
	showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.05
	
	-- 다른 페이지 넘어가는 아이콘 및 회색 배경 --
	gray_upperLeft = display.newImage("Content/images/shadow.png")
	gray_upperLeft.x, gray_upperLeft.y = display.contentWidth*0.73, display.contentHeight*0.06

	gray_upperRight = display.newImage("Content/images/shadow.png")
	gray_upperRight.x, gray_upperRight.y = display.contentWidth*0.9, display.contentHeight*0.06

	gray_lowerLeft = display.newImage("Content/images/shadow.png")
 	gray_lowerLeft.x, gray_lowerLeft.y = display.contentWidth*0.73, display.contentHeight*0.145

	gray_lowerRight = display.newImage("Content/images/shadow.png")
 	gray_lowerRight.x, gray_lowerRight.y = display.contentWidth*0.9, display.contentHeight*0.145

	bookIcon = display.newImage("Content/images/book.png");
 	bookIcon.x, bookIcon.y = display.contentWidth*0.73, display.contentHeight*0.05

	text_bookIcon = display.newImage("Content/images/text_Book2.png")
	text_bookIcon.x, text_bookIcon.y = display.contentWidth*0.73, display.contentHeight*0.081

	store = display.newImageRect("Content/images/store.png", 170, 170)
 	store.x, store.y = display.contentWidth*0.904, display.contentHeight*0.047

	text_storeIcon = display.newImage("Content/images/text_store.png")
	text_storeIcon.x, text_storeIcon.y = display.contentWidth*0.9, display.contentHeight*0.08
	
	temp = display.newImage("Content/images/success.png")
 	temp.x, temp.y = display.contentWidth*0.73, display.contentHeight*0.14
 
	text_tempIcon = display.newImage("Content/images/text_acheivements.png")
	text_tempIcon.x, text_tempIcon.y = display.contentWidth*0.73, display.contentHeight*0.17
 
	dia = display.newImageRect("Content/images/dia.png", display.contentWidth*0.09, display.contentHeight*0.04)
	dia.x, dia.y = display.contentWidth*0.9, display.contentHeight*0.138
 
	text_deco = display.newImage("Content/images/text_deco.png")
	text_deco.x, text_deco.y = display.contentWidth*0.9, display.contentHeight*0.17

	pushIcon = display.newImageRect("Content/images/push.png", display.contentWidth*0.25, display.contentHeight*0.05)
	pushIcon.x, pushIcon.y = display.contentWidth*0.24, display.contentHeight*0.15

	text_push = display.newImage("Content/images/text_breadPush.png")
	text_push.x, text_push.y = display.contentWidth*0.24, display.contentHeight*0.15
    text_push:toFront()
	--

	-- 꾸미기 창 --

	local popGroup = display.newGroup()

	local window = display.newImageRect(popGroup, "Content/images/list.png", display.contentWidth*0.78, display.contentHeight*0.62)
	window.x, window.y = display.contentWidth*0.5, display.contentHeight*0.54

	local close = display.newImageRect(popGroup, "Content/images/close.png", display.contentWidth*0.1, display.contentHeight*0.05)
	close.x, close.y = 1240, 583--display.contentWidth*0.8565, display.contentHeight*0.24

	local pushBtn = display.newImageRect(popGroup, "Content/images/pushBtn.png", display.contentWidth*0.25, display.contentHeight*0.05)
	pushBtn.x, pushBtn.y = display.contentWidth*0.5, display.contentHeight*0.79

    local menuGroup = display.newGroup()
	
	local carpetBtn = display.newRect(menuGroup, 460, 667, 280, 150)
	carpetBtn:setFillColor(0)
	carpetBtn.alpha = 0.01
	popGroup:insert( carpetBtn )

	local carpetText = display.newImage(menuGroup, "Content/images/text_carpet.png")
	carpetText.x, carpetText.y = 460, 667
	popGroup:insert( carpetText )

	local decoBtn = display.newRect(990, 667, 280, 150)
	decoBtn:setFillColor(0)
	decoBtn.alpha = 0.01
	popGroup:insert( decoBtn )

	local decoText = display.newImage(menuGroup, "Content/images/text_decorC.png")
	decoText.x, decoText.y = 990, 667
	popGroup:insert( decoText ) 

	close.name = "close"
	close:addEventListener("tap", gotoBreadRoomFromD) 

	pushBtn.name = "pushBtn"
	pushBtn:addEventListener("tap", gotoBreadRoomFromD)

	carpetBtn:addEventListener("tap", gotoDecoC)

    ------------------------
    local carpetGroup = display.newGroup()

	local choiceMark = display.newImage(carpetGroup, "Content/images/chosen.png")
	choiceMark.x, choiceMark.y = 980, 760
	popGroup:insert( choiceMark )

	local product_bar = {}
	local p_pic_bar = {}
	local p_pic = {}
	local p_checkBox = {}
	local p_check = {}

	local ingreName = {}
	local ingreInfo = {}
	--local defaultBox 

	--임시--
	--decoFlag = { 1, 1 }
	local overlapFlag = 0
	local idx = 1
	for i=1, #deco do
		if decoFlag[i] == 1 then
			product_bar[i] = display.newImage(carpetGroup, "Content/images/deco_bar.png")
			product_bar[i].x, product_bar[i].y = display.contentWidth*0.39, display.contentHeight*(0.06+0.13* (idx-1))
			p_pic_bar[i] = display.newImage(carpetGroup, "Content/images/deco_box.png")
		    p_pic_bar[i].x, p_pic_bar[i].y = display.contentWidth*0.11, display.contentHeight*(0.06+0.13* (idx-1))

		    p_pic[i] = display.newImageRect(carpetGroup, deco[i].image, 200, 200)
			p_pic[i].x, p_pic[i].y = display.contentWidth*0.11, display.contentHeight*(0.06+0.13* (idx-1))
			p_pic[i].name = i

			p_checkBox[i] = display.newImage(carpetGroup, "Content/images/deco_checkBox.png")
			p_checkBox[i].x, p_checkBox[i].y = display.contentWidth*0.06, display.contentHeight*(0.06+0.13* (idx-1) - 0.03)


			p_check[i] = display.newImage(carpetGroup, "Content/images/deco_check.png")
			p_check[i].x, p_check[i].y = display.contentWidth*0.06, display.contentHeight*(0.06+0.13* (idx-1) - 0.03)
			p_check[i].isVisible = false

			--중복 체크 불가 구현			
			local function checked( event ) 
				audio.play( soundTable["clickSound"],  {channel=5}) 
				if p_check[i].isVisible == false then
					p_check[i].isVisible = true
					print("체크하겠습니다.")
					decoIndex[i] = i
				else
					p_check[i].isVisible = false
					decoIndex[i] = 0
					print("체크 해제하겠습니다.")
				end
			end
			--[[local function checked( event ) 
				if p_check[i].isVisible == false then
					for j=1, #deco do
						if p_check[j] ~= nil and p_check[j].isVisible ~= nil and p_check[j].isVisible == true then
							overlapFlag = 1
							print("중복됐습니다.")
							break
						end
					end
					if overlapFlag == 0 then
						p_check[i].isVisible = true
						print("체크하겠습니다.")
						decoIndex = i
					else
						overlapFlag = 0
					end
				else
					p_check[i].isVisible = false
					decoIndex = 0
					print("체크 해제하겠습니다.")
				end
			end]]
			p_checkBox[i]:addEventListener("tap", checked)

			local nameOptions = 
			{
				text = deco[i].name,
				x = display.contentWidth*(0.41 + 0.24 - 0.1),
				y = display.contentHeight*(0.04 + 0.13*(idx-1)),
				width = 1000,
				font = "Content/font/ONE Mobile POP.ttf",
				fontSize = 60,
				align = "left"
			}
			ingreName[i] = display.newText(nameOptions) 
			ingreName[i]:setFillColor(0)
			carpetGroup:insert(ingreName[i])

			local sentenceOptions = 
			{
				text = deco[i].sentence,
				x = display.contentWidth*(0.41 + 0.24 - 0.1),
				y = display.contentHeight*(0.04 +0.13*(idx-1)+ 0.04),
				width = 1000,
				font = "Content/font/ONE Mobile POP.ttf",
				fontSize = 45,
				align = "left"
			}
			idx = idx + 1
			ingreInfo[i] = display.newText(sentenceOptions)
			ingreInfo[i]:setFillColor(0)
			carpetGroup:insert(ingreInfo[i])
		end
	end

	local scrollView = widget.newScrollView(
	{
		horizontalScrollDisabled=true,
		left = 169,
		top = 800,
		width = 1115,
		height = 1150,
		backgroundColor = { 0, 0, 0, 0 }

	} )
	scrollView:insert( carpetGroup )
	popGroup:insert( scrollView )

	sceneGroup:insert(background_room1)
	sceneGroup:insert(background_room2)
	sceneGroup:insert(background_carpet)
			
	sceneGroup:insert(homeIcon)
	sceneGroup:insert(breadIcon) 
	sceneGroup:insert(text_breadRoom) 
	sceneGroup:insert(coinIcon) 
	sceneGroup:insert(gray_lowerLeft) 
	sceneGroup:insert(gray_lowerRight) 
	sceneGroup:insert(gray_upperLeft) 
	sceneGroup:insert(gray_upperRight) 
	sceneGroup:insert(bookIcon)
	sceneGroup:insert(text_bookIcon)
	sceneGroup:insert(store)
		
	sceneGroup:insert(text_storeIcon)
	sceneGroup:insert(temp)
	sceneGroup:insert(text_tempIcon)
	sceneGroup:insert(text_deco)
	sceneGroup:insert(dia)
	sceneGroup:insert(pushIcon)
	sceneGroup:insert(text_push)

	sceneGroup:insert(menuGroup)
	sceneGroup:insert(popGroup)


	local explainText = display.newText("※장식은 빵방에서 터치로 회수할 수 있습니다.", display.contentWidth*0.55, 558 ,"Content/font/ONE Mobile POP.ttf")
	explainText.size = 37
	explainText:setFillColor(0.5)

	sceneGroup:insert(explainText)

	--
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		
	elseif phase == "did" then
		if decoFlag[1] == 0 and delete_deco_from_list[1] == 1 then
			breadRoom_deco_ver2[1].isVisible = true
		end

		if decoFlag[2] == 0 and delete_deco_from_list[2] == 1 then
			breadRoom_deco_ver2[2].isVisible = true
		end
		--[[if composer.getVariable("decoNum") == 1 and decoFlag[1] == 0 then
			breadRoom_deco[1].x, breadRoom_deco[1].y = display.contentWidth*0.43, display.contentHeight*0.18
		end

		if composer.getVariable("decoNum") == 2 and decoFlag[2] == 0 then
			breadRoom_deco[2].x, breadRoom_deco[2].y = display.contentWidth*0.55, display.contentHeight*0.18
		end

		if breadRoom_deco[1] ~= nil then
		breadRoom_deco[1]:removeEventListener("touch", comebackToList)
		sceneGroup:insert(breadRoom_deco[1])
		end
		if breadRoom_deco[2] ~= nil then
		breadRoom_deco[2]:removeEventListener("touch", comebackToList)
		sceneGroup:insert(breadRoom_deco[2])
		end]]
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then

	elseif phase == "did" then
		composer.removeScene("decorationD")
		breadRoom_deco_ver2[1].isVisible = false
		breadRoom_deco_ver2[2].isVisible = false
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene