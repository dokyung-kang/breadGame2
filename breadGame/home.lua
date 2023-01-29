-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------
local gauge, expDisplay

local composer = require( "composer" )
local scene = composer.newScene()

syrub = 0
ingredient = 0

composer.setVariable("s", syrub)
composer.setVariable("m", ingredient)

function moveToBook(event)
	audio.play( soundTable["clickSound"],  {channel=5}) 
	print("도감으로 이동")
	showCoin.isVisible = false
	composer.gotoScene("bookMain")
end

function moveToBreadRoom(event)
	audio.play( soundTable["clickSound"],  {channel=5}) 
	print("빵방으로 이동")
	coinX = 0.608 - (string.len(coinNum)-1)*0.01
	showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.05
	composer.gotoScene("breadRoom")
end
---------------업적으로 이동---------------------
local function  gotoAchieve(event)
	audio.play( soundTable["clickSound"],  {channel=5}) 
	print("업적으로 이동")
	---------showCoin 관련 수정
	coinX = 0.53 - (string.len(coinNum)-1)*0.01
	showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.053
	composer.gotoScene("achieve")
end

----------------- 경험치에 따른 레벨업 관련 ---------------------
local json = require("json")

local function parse2()
	filename = system.pathForFile("Content/JSON/ingredient.json")
	ingredients, pos2, msg2 = json.decodeFile(filename)
end
parse2()

local kindOfSyrup = 0
local kindOfIngre = 0

local function ingreRandom() --시럽/재료 각각 랜덤으로 하나씩 보상--
	audio.play( soundTable["rewardSound"] ,  {channel=7})
	local n = math.random(2, 4) --초코시럽(2), 딸기시럽(3), 슈크림시럽(4)
	ingreCnt[n] = ingreCnt[n] + 1
	kindOfSyrup = n

	n = math.random(5, 11) -- 재료 랜덤하게
	ingreCnt[n] = ingreCnt[n] + 1
	kindOfIngre = n

	--보상 표시--
	local rewardGroup = display.newGroup()

	local rewardSyrup = display.newImage(rewardGroup, ingredients[kindOfSyrup].image)
	rewardSyrup.x, rewardSyrup.y = display.contentWidth*0.555, display.contentHeight*0.5

	local rewardIngre = display.newImage(rewardGroup, ingredients[kindOfIngre].image)
	rewardIngre.x, rewardIngre.y = display.contentWidth*0.555, display.contentHeight*0.55

	transition.moveTo(rewardSyrup, {time = 2000, x=display.contentWidth*0.138, y=display.contentHeight*0.444} ) 
	transition.moveTo(rewardIngre, {time = 2000, x=display.contentWidth*0.158, y=display.contentHeight*0.444} ) 

	transition.fadeOut(rewardGroup, {timer = 1500, delay = 1500})
	audio.play( soundTable["rewardSound"],  {channel=7} )
end

levelUpFlag = 0 
local function levelUpPop( n ) --레벨업 창 화면에 띄우기 --
	print("레벨업!!!!!!!!!"..n.."으로")
	--audio.play( soundTable["levelUpSound"] ,  {channel=6})
	
	levelUpFlag = 1

	levelGroup = display.newGroup()

	levelDarkening = display.newImageRect(levelGroup, "Content/images/dark.png", 1440*2, 710*7)
	levelDarkening.x, levelDarkening.y = display.contentCenterX, display.contentCenterY
	
	local levelUpPopMark = display.newImage(levelGroup, "Content/images/levelUp.png")
	levelUpPopMark.x, levelUpPopMark.y = display.contentCenterX, display.contentCenterY*0.8
	showNewLevel = display.newText(n, display.contentWidth*0.075, display.contentHeight*0.045, "Content/font/ONE Mobile POP.ttf", 100)
	showNewLevel.x, showNewLevel.y = display.contentWidth*0.52, display.contentHeight*0.37
	showNewLevel:setFillColor(1)

	
	levelGroup:insert(showNewLevel)
	
	local message = display.newImage(levelGroup, "Content/images/text_levelUp.png", display.contentCenterX, display.contentHeight*0.5)

	local message2 = display.newText(levelGroup, "폭탄빵을 만들 확률 ".. (10-portion)*10 .."% > "..(10-(portion+0.5))*10 .."%", display.contentCenterX, display.contentHeight*0.6, "Content/font/ONE Mobile POP.ttf", 100)
	message2:setFillColor(1)
	message2.size = 70

	transition.fadeOut(levelGroup, {timer = 2000, delay = 2000})

	-- **레벨업 넘어갈 때 게이지와 경험치 표시 변경 코드--
	gauge.isVisible = false
	expDisplay.isVisible = false

	gauge = display.newImageRect("Content/images/gauge.png", 300, 50)
	gauge.x, gauge.y = 345, 100
	gauge.isVisible = false
	
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
	--
	
	ingreRandom()
end

showLevel = display.newText(levelNum, display.contentWidth*0.075, display.contentHeight*0.045, "Content/font/ONE Mobile POP.ttf", 90)
showLevel:setFillColor(1)

function levelUp() --레벨업 --
	print("레벨 몇이냐면..."..levelNum.."!!!!!!!")

	for i=2, 10 do
		if exp >= expList[i] and levelFirstTime[i] == 1 then
			levelNum = i
			if i == 10 then
				coinNum = coinNum + 10000
			else 
				coinNum = coinNum + 3000
			end
			levelFirstTime[i] = 0
			levelUpPop(levelNum)

			showCoin.text = coinNum
			coinX = 0.584 - (string.len(coinNum)-1)*0.01
			showCoin.x = display.contentWidth*coinX
			showLevel.text = levelNum
			break
		end
	end
end

function scene:create( event )
	local sceneGroup = self.view

	showCoin.text = coinNum
	coinX = 0.584 - (string.len(coinNum)-1)*0.01
	showCoin.x = display.contentWidth*coinX

	local background = display.newImage("Content/images/인트로/face_love.png")
	background.x, background.y = display.contentCenterX, display.contentCenterY

	local level = display.newImage("Content/images/level.png")
	level.x, level.y = display.contentWidth*0.07, display.contentHeight*0.04

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

	local function gotoStore(event)
		audio.play( soundTable["clickSound"],  {channel=5}) 
		coinX = 0.583 - (string.len(coinNum)-1)*0.01
		showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.05
		composer.gotoScene("store_i")
	end
	store:addEventListener("tap", gotoStore)

	
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

	book:addEventListener("tap", moveToBook)
	breadRoom:addEventListener("tap", moveToBreadRoom)
	----------업적 관련 추가--------------
	success:addEventListener("tap", gotoAchieve)
	-------------------------------------
	
	--[[
	----------엔딩보기 추가---------------
	local ending = display.newText("엔딩보기", display.contentWidth*0.95, display.contentHeight*0.99, "font/ONE Mobile POP.ttf", 40)
	--ending:setFillColor(0.5)
	function gotoEnd(event)
		----------------showCoin관련 수정
		showCoin.isVisible = false
		composer.gotoScene("outtro")
	end
	ending:addEventListener("tap", gotoEnd)
	]]
	
	-------------------------------------
	--재료 추가 버튼--
	local material_button = display.newImage("Content/image/material_button.png", display.contentWidth, display.contentHeight)
	material_button.x, material_button.y = display.contentWidth * 0.138, display.contentHeight * 0.444

	local function plus( event )
 
	    if ( event.phase == "began" ) then
	    	audio.play( soundTable["clickSound"],  {channel=5}) 
			showCoin.isVisible = false
	        composer.gotoScene("syrup")
		end
	end
	material_button:addEventListener("touch", plus)


	sceneGroup:insert( background )
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
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
	elseif phase == "did" then
	end	
end


function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
	elseif phase == "did" then
		composer.removeScene("home")
		composer.removeScene("result")

		if levelUpFlag == 1 then
			gauge.isVisible = false
			expDisplay.isVisible = false
		end
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