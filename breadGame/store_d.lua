-----------------------------------------------------------------------------------------
--
-- store_d.lua
--
-----------------------------------------------------------------------------------------
local json = require('json')
local deco, pos, msg
--

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

local composer = require( "composer" )
local scene = composer.newScene()


--위젯:스크롤--
local widget = require( "widget" )

local ingreGroup = display.newGroup()
local cnt = {}

local function displayIngreCnt(i)
	cnt[i] = display.newText(ingreGroup, decoCnt[i].."개", display.contentWidth*0.8, display.contentHeight*(0.06+0.13* (i-1)), "Content/font/ONE Mobile POP.ttf")
	cnt[i].x, cnt[i].y = display.contentWidth*0.8, display.contentHeight*(0.06+0.13* (i-1))
	cnt[i]:setFillColor( 0.894, 0.772, 0.713 )
	cnt[i].size = 50
end

local function printAllCnt()
	for i=1, #deco do
		displayIngreCnt(i)
	end
end

local function deleteBeforeCnt(i)
	display.remove(cnt[i])
end

local function deleteAllCnt()
	for i=1, #deco do
		deleteBeforeCnt(i)
	end
end

function scene:create( event )
	local sceneGroup = self.view

	local topGroup = display.newGroup()

	local background = display.newImage("Content/images/storeBackground.png")
	background.x, background.y = display.contentCenterX, display.contentCenterY
	
	local store = display.newImageRect("Content/images/store.png", 200, 200)
	store.x, store.y = display.contentWidth*0.15, display.contentHeight*0.04
	
	local storeText = display.newImage("Content/images/text_store2.png")
	storeText.x, storeText.y = display.contentWidth*0.28, display.contentHeight*0.05

	coins = display.newImage("Content/images/coins.png")	
	coins.x, coins.y = display.contentWidth*0.5, display.contentHeight*0.05
	coinX = 0.583 - (string.len(coinNum)-1)*0.01
	showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.05

	local explainText = display.newText("※장식과 카펫은 1개만 구매가능합니다.", display.contentWidth*0.6, display.contentHeight*0.08 ,"Content/font/ONE Mobile POP.ttf")
	explainText.size = 40
	explainText:setFillColor(1)

	local home = display.newImage("Content/images/home.png")
	home.x, home.y = display.contentWidth*0.9, display.contentHeight*0.05
	home:addEventListener("tap", gotoh) 

	local productType = display.newImage("Content/images/top_bar.png")
	productType.x, productType.y = display.contentWidth*0.5, display.contentHeight*0.12

	local choiceMark = display.newImage("Content/images/chosen.png")

	choiceMark.x, choiceMark.y = display.contentWidth*0.5, display.contentHeight*0.14

	local ingredientBtn = display.newRect(display.contentWidth*0.2, display.contentHeight*0.12, 280, 150)
	ingredientBtn.alpha = 0.01
	local ingredientText = display.newImage("Content/images/text_ingre.png")
	ingredientText.x, ingredientText.y = display.contentWidth*0.2, display.contentHeight*0.12 

	local decoBtn = display.newRect(display.contentWidth*0.5, display.contentHeight*0.12, 280, 150)
	decoBtn.alpha = 0.01
	local decoText = display.newImage("Content/images/text_decorC.png")
	decoText.x, decoText.y = display.contentWidth*0.5, display.contentHeight*0.12

	local wallBtn = display.newRect(display.contentWidth*0.8, display.contentHeight*0.12, 280, 150)
	wallBtn.alpha = 0.01
	local wallText = display.newImage("Content/images/text_carpet.png")
	wallText.x, wallText.y = display.contentWidth*0.8, display.contentHeight*0.12

	topGroup:insert(background)
	topGroup:insert(store)
	topGroup:insert(storeText)
	topGroup:insert(coins)
	topGroup:insert(explainText)
	topGroup:insert(home)
	topGroup:insert(productType)
	topGroup:insert(choiceMark)
	topGroup:insert(ingredientBtn)
	topGroup:insert(ingredientText)
	topGroup:insert(decoBtn)
	topGroup:insert(decoText)
	topGroup:insert(wallBtn)
	topGroup:insert(wallText)	

	ingredientBtn:addEventListener("tap", gotoi)
	wallBtn:addEventListener("tap", gotow)

	-- 이 부분이 달라짐 store_i, store_d, store_w의 차이--
	--commonFrame()

	local listGroup = display.newGroup()
	local background2 = display.newImage("Content/images/storeBackground.png")

	background2.x, background2.y = display.contentCenterX, display.contentCenterY

	local product_bar = {}
	local p_pic_bar = {}
	local p_pic = {}
	--local cnt = {}
	local ingreName = {}
	local ingreInfo = {}
	local defaultBox 


	for i=1, #deco do
		product_bar[i] = display.newImage(ingreGroup, "Content/images/product_bar.png")
		product_bar[i].x, product_bar[i].y = display.contentWidth*0.5, display.contentHeight*(0.06+0.13* (i-1))
		p_pic_bar[i] = display.newImage(ingreGroup, "Content/images/syrup_bar.png")
	    p_pic_bar[i].x, p_pic_bar[i].y = display.contentWidth*0.22, display.contentHeight*(0.06+0.13* (i-1))

	    p_pic[i] = display.newImageRect(ingreGroup, deco[i].image, 200, 200)
		p_pic[i].x, p_pic[i].y = display.contentWidth*0.22, display.contentHeight*(0.06+0.13* (i-1))
		p_pic[i].name = i

		displayIngreCnt(i)
		cnt[i]:removeSelf()

		local nameOptions = 
		{
			text = deco[i].name,
			x = display.contentWidth*(0.41 + 0.24),
			y = display.contentHeight*(0.04 + 0.13*(i-1)),
			width = 1000,
			font = "Content/font/ONE Mobile POP.ttf",
			fontSize = 60,
			align = "left"
		}
		ingreName[i] = display.newText(nameOptions) 
		ingreName[i]:setFillColor(0)
		ingreGroup:insert(ingreName[i])

		local sentenceOptions = 
		{
			text = deco[i].sentence,
			x = display.contentWidth*(0.41 + 0.24),
			y = display.contentHeight*(0.04 +0.13*(i-1)+ 0.04),
			width = 1000,
			font = "Content/font/ONE Mobile POP.ttf",
			fontSize = 45,
			align = "left"
		}
		ingreInfo[i] = display.newText(sentenceOptions)
		ingreInfo[i]:setFillColor(0)
		ingreGroup:insert(ingreInfo[i])

	listGroup:insert(background2)
	listGroup:insert(ingreGroup)

	local function pop( event )
		audio.play( soundTable["clickSound"] ,  {channel=5})
		composer.setVariable("pickedIndex_d", i)
		composer.gotoScene("store_d_p")
	end

	p_pic[i]:addEventListener("tap", pop)

	end

	sceneGroup:insert(topGroup)
	sceneGroup:insert(listGroup)

	topGroup:toFront()

	local scrollS
	scrollS = display.newImage("Content/images/scrollShadow.png")
	scrollS.x, scrollS.y =  display.contentCenterX, display.contentHeight*0.99

	local scrollView = widget.newScrollView(
		{
	        horizontalScrollDisabled=true,
	        top = 400,
	        width = 1440,
	        height = 2150,
	        hideBackground = true
		}
	)
	scrollView:insert(ingreGroup)
	sceneGroup:insert(scrollView)
	sceneGroup:insert(scrollS)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
	elseif phase == "did" then
		printAllCnt()
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
	elseif phase == "did" then
		deleteAllCnt()
		for i=1, #deco do
			if decoCnt[i] == 1 and delete_deco_from_list[i] == 0 then
				decoFlag[i] = 1
				print(i.."인덱스의 flag는"..decoFlag[i].."\n")
			end
		end
		composer.removeScene("store_d")
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
