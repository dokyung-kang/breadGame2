-----------------------------------------------------------------------------------------
--
-- bookInfo.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

parseUBreadInfo()
parseBreadInfo()

BackGround = display.newImage("Content/images/main_background.png")
BackGround.x, BackGround.y = display.contentWidth/2, display.contentHeight/2

function scene:create( event )
	local sceneGroup = self.view

	Index = composer.getVariable( "Id" )
	Index1 = composer.getVariable( "Id1" )
	Index2 = composer.getVariable( "Id2" )

	local BreadJson, open, cnt
	if Index == 1 then
		BreadJson = BreadInfo[Index1].breads[Index2]
		open = openBread
		cnt = breadsCnt[Index1][Index2]
		lv = Bread_level[Index1][Index2]
	else
		BreadJson = UBreadInfo[Index1].breads[Index2]
		open = openUBread
		cnt = UbreadsCnt[Index1][Index2]
		lv = 10
	end

-- [backGroup] 도감, 홈 버튼
	local backGroup = display.newGroup()
	local infoGround = display.newImage(backGroup, "Content/images/illuBook_info.png")
	infoGround.x, infoGround.y = display.contentWidth/2, display.contentHeight/2
	local illuBook = display.newImage(backGroup, "Content/images/back.png")
	illuBook.x, illuBook.y = BackGround.x*0.25, BackGround.y*0.1
	local illuBook_text = display.newImage(backGroup ,"Content/images/text_Book.png")
	illuBook_text.x, illuBook_text.y = infoGround.x*0.53, infoGround.y*0.1
	local home = display.newImage(backGroup, "Content/images/home.png")
	home.x, home.y = BackGround.x*1.75, BackGround.y*0.1
	sceneGroup:insert(BackGround)
	sceneGroup:insert(backGroup)

-- 도감 이동
	local function goBook(event)
		audio.play(soundTable["clickSound"],  {channel=5})	
		print("다시 도감으로!!")	
		composer.removeScene("bookInfo")
		composer.gotoScene( "bookMain" )
	end
	
	illuBook:addEventListener("tap", goBook)
	illuBook_text:addEventListener("tap", goBook)

-- 홈 이동
	local function goHome(event)
		audio.play(soundTable["clickSound"],  {channel=5})	
		print("goHome!!")
		composer.removeScene("bookInfo")
		-------showCoin 관련 수정
		showCoin.isVisible = true
		coinX = 0.584 - (string.len(coinNum)-1)*0.01
		showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.04
		showCoin.text = coinNum
		composer.gotoScene( "home" )
	end
	home:addEventListener("tap",goHome)

-- [coinGroup] CoinAndCnt 보유코인, 빵개수
	local coinText, cntText, coin 
	local coinGroup

	local function CoinAndCnt()
		coinGroup = display.newGroup()		
		coin = display.newImage(coinGroup, "Content/images/coins.png")
		coin.x, coin.y = BackGround.x*1.01, BackGround.y*0.1	
		coinX = 0.590 - (string.len(coinNum)-1)*0.01
		coinText = display.newText(coinGroup, coinNum, display.contentWidth*coinX, BackGround.y*0.1, Font.font_POP, 42 )
		coinText:setFillColor(0)
		cntText = display.newText(coinGroup, BreadJson.name.."의 개수 : "..cnt, BackGround.x*0.6, BackGround.y*0.45, Font.font_POP, 60)
		cntText:setFillColor(0)
		sceneGroup:insert(coinGroup)
	end

-- [makeLvPrice] 레벨업, 진화 비용
	local levelPrice = { }
	local function makeLvPrice()
		levelPrice[1] = BreadInfo[Index1].breads[Index2].Lv1
		levelPrice[2] = BreadInfo[Index1].breads[Index2].Lv2
		levelPrice[3] = BreadInfo[Index1].breads[Index2].Lv3
		levelPrice[4] = BreadInfo[Index1].breads[Index2].Lv4
		levelPrice[5] = BreadInfo[Index1].breads[Index2].Lv5
		levelPrice[6] = BreadInfo[Index1].breads[Index2].Lv6
		levelPrice[7] = BreadInfo[Index1].breads[Index2].Lv7
		levelPrice[8] = BreadInfo[Index1].breads[Index2].Lv8
		levelPrice[9] = BreadInfo[Index1].breads[Index2].Lv9
		levelPrice[10] = BreadInfo[Index1].breads[Index2].Lv10
	end
	makeLvPrice()

-- [makeSalePrice] 되팔기 비용
	local salePrice
	local function  makeSalePrice()
		salePrice = 0
		for i=1, lv do			
			salePrice = salePrice + levelPrice[i]
		end
		if index == 2 then
			salePrice = salePrice * 2
		else
			salePrice = salePrice * 1.5
		end
		-- 반죽만 있는 빵 가격
		if Index1 == 1 and Index2 == 1 then 
			salePrice = 300
		end
	end
	makeSalePrice()

-- [NameAndLv] 기본빵일때 빵이름 + 레벨
	local breadName, lvGroup
	local function NameAndLv()  
		lvGroup = display.newGroup()
		breadName = display.newText(lvGroup, BreadJson.name.."  Lv."..lv, infoGround.x, infoGround.y*0.335, Font.font_POP, 70)
		sceneGroup:insert(lvGroup)
	end

-- [salekey] 판매키, 가격 생성
	local saleGroup, saleC, saleKey, saleKeyText, sCoin
	local function salekey()
		makeSalePrice()
		saleGroup = display.newGroup()
		saleKey = display.newImage(saleGroup,"Content/images/illuBook_sale.png")
		saleKey.x, saleKey.y = infoGround.x*0.55, infoGround.y*1.5
		saleKeyText = display.newImage(saleGroup, "Content/images/text_sale.png")
		saleKeyText.x, saleKeyText.y = saleKey.x*0.72, saleKey.y*1.002

		salePriceLen = string.len(salePrice)
		sCoin = display.newImage(saleGroup,"Content/images/coin.png")
		sCoin.y = saleKey.y
		if salePriceLen <= 3 then 
			sCoin.x = saleKey.x*1.2
		else
			sCoin.x = saleKey.x*1.2 - (salePriceLen-3)*25
		end		
		saleC = display.newText(saleGroup, salePrice, sCoin.x+135, infoGround.y*1.5, 
			200, 50, Font.font_POP, 50)
		sceneGroup:insert(saleGroup)
	end

-- [upSetGroup] Up키 셋팅 -- cnt > 0 and Index == 1
	local upgradeKey, upText, uCoin, upCoin
	local upSetGroup
	local function UpSet ()	
		upSetGroup = display.newGroup()
		if lv == 10 then
			upKey = display.newImage(upSetGroup, "Content/images/illuBook_upgrade2.png")
			upText = display.newImage(upSetGroup, "Content/images/text_upgrade.png")
			upKey.x, upKey.y = infoGround.x*1.45, infoGround.y*1.5	
			upText.x, upText.y = upKey.x*0.9, upKey.y						
		else			-- lv < 10
			upKey = display.newImage(upSetGroup, "Content/images/illuBook_upgrade.png")
			upText = display.newImage(upSetGroup, "Content/images/text_levelUpSmall.png")
			upKey.x, upKey.y = infoGround.x*1.45, infoGround.y*1.5	
			upText.x, upText.y = upKey.x*0.9, upKey.y*1.003			
		end

		levelPriceLen = string.len(levelPrice[lv])
		uCoin = display.newImage(upSetGroup, "Content/images/coin.png")
		uCoin.y = infoGround.y*1.5
		if levelPriceLen <= 3 then 
			uCoin.x = upKey.x*1.08
		else
			uCoin.x = upKey.x*1.08 - (levelPriceLen-3)*25
		end		
		upCoin = display.newText(upSetGroup, levelPrice[lv], uCoin.x+135, upKey.y, 
			200, 50, Font.font_POP, 50)
		
		sceneGroup:insert(upSetGroup)
	end

-- [sale] 판매 작동 함수 (빵 - 1 (개수==0이면 판매X, 업X), 코인 + a)	
	local function sale( event )
		audio.play(soundTable["cashSound"],  {channel=4})	
		cnt = cnt - 1
		if Index == 1 then
			breadsCnt[Index1][Index2] = cnt
		else
			UbreadsCnt[Index1][Index2] = cnt
		end
		coinNum = coinNum + salePrice
		coinGroup:removeSelf()		
		CoinAndCnt()
		if cnt < 1 then 
			if upSetGroup ~= null then
				upSetGroup:removeSelf()
			end
			saleGroup:removeSelf()
		end
	end

-- [upGroup] 업그레이드창 함수 (기본빵-1, 코인-a, 업빵+1)
	local dark, upWindow, upSuc, upNew1, upNew2
	local upBread, upBreadN, upBreadI
	local upDel, upCheckI, upCheckT
	local upGroup

	local function upgradeOK (event)
		audio.play(soundTable["clickSound"],  {channel=5})	
		coinGroup:removeSelf()
		upGroup:removeSelf()
		CoinAndCnt()	
	end

	local function upgrade() 
		audio.play( soundTable["breadSound"],  {channel=3} )
		cnt = cnt - 1
		if cnt < 1 then
			upSetGroup:removeSelf()
			saleGroup:removeSelf()
		end		
		breadsCnt[Index1][Index2] = cnt
		UbreadsCnt[Index1][Index2] = UbreadsCnt[Index1][Index2] + 1
		openUBread[Index1][Index2] = -1
		coinNum = coinNum - levelPrice[lv]
		upGroup = display.newGroup()
		Uimage = UBreadInfo[Index1].breads[Index2].image
		dark = display.newImageRect(upGroup, "Content/images/dark.png", 1440*2, 710*7)
		dark.x, dark.y = BackGround.x, BackGround.y
		upWindow = display.newImage(upGroup, "Content/images/window.png")
		upWindow.x, upWindow.y = BackGround.x, BackGround.y*1.1
		upSuc = display.newText(upGroup, "빵 진화 성공", upWindow.x, upWindow.y*0.5, Font.font_POP, 100)
		upNew1 = display.newImage(upGroup, "Content/images/new.png")
		upNew1.x, upNew1.y = upWindow.x*0.6, upWindow.y*0.7

		halo = display.newImage(upGroup, "Content/images/halo.png")
		halo.x, halo.y = upWindow.x, upWindow.y*0.9
			halo.rotation = -45
		local reverse = 1
		local function rock()
			if (reverse == 0) then
				reverse = 1
				transition.to(halo, {rotation=-45, time=1000, transition=easing.inOutCubic })
			else
				reverse = 0
				transition.to(halo, {rotation=45, time=1000, transition=easing.inOutCubic })
			end
		end

		timer.performWithDelay(900, rock, 0)
		upBread = display.newImageRect(upGroup, "Content/images/"..Uimage..".png", 620, 620)
		upBread.x, upBread.y = upWindow.x, upWindow.y*0.9

		upBreadN = display.newText(upGroup, UBreadInfo[Index1].breads[Index2].name, upWindow.x, upWindow.y*1.12, Font.font_POP, 80)
		upBread_options = 
		{
		    text = UBreadInfo[Index1].breads[Index2].sentence,     
		    x = upWindow.x,
		    y = upWindow.y*1.235,
		    width = 890,
		    height = 240,
		    font = Font.font_POP,   
		    fontSize = 50,
		    align = "center"  -- Alignment parameter
		}		
		upBreadI = display.newText(upBread_options)
		upBreadN:setFillColor(0)
		upBreadI:setFillColor(0)
		upGroup:insert(upBreadI)
		upDel = display.newImage(upGroup, "Content/images/delete.png")
		upDel.x, upDel.y = upWindow.x*1.77, upWindow.y*0.46
		upCheckI = display.newImage(upGroup, "Content/images/button.png")
		upCheckI.x, upCheckI.y = upWindow.x, upWindow.y*1.45
		upCheckT = display.newImage(upGroup, "Content/images/text_OK.png")
		upCheckT.x, upCheckT.y = upCheckI.x, upCheckI.y
	
		sceneGroup:insert(upGroup)
		upDel:addEventListener("tap", upgradeOK)
		upCheckI:addEventListener("tap", upgradeOK)
	end

-- [levelUp] 레벨업 함수 
	local function levelUp( event )
		if coinNum >= levelPrice[lv] and lv == 10 then
			upgrade()
		elseif coinNum >= levelPrice[lv] then
			audio.play(soundTable["levelUpSound"],  {channel=6})
			coinNum = coinNum - levelPrice[lv]
			lv = lv + 1		
			Bread_level[Index1][Index2] = lv
			coinGroup:removeSelf()
			lvGroup:removeSelf()			
			CoinAndCnt()					
			NameAndLv()	
			upSetGroup:removeSelf()
			saleGroup:removeSelf()		
			if cnt > 0 then
				UpSet()
				upKey:addEventListener("tap", levelUp)
				salekey()
				saleKey:addEventListener("tap", sale)				
			end	
		end
	end

-- [infoGroup, lvGroup, saleC] info function (빵이름, 빵이미지, 빵소개, 빵레벨, 새빵)
	
-- [infoBasic]
	local breadImage, breadSentence, new, bread_options
	local infoGroup
	local function infoBasic()
		infoGroup = display.newGroup()
		CoinAndCnt()
		makeLvPrice()
		if Index == 1 then -- 기본 빵
			NameAndLv()
		else
			breadName = display.newText(infoGroup, BreadJson.name, infoGround.x, infoGround.y*0.335, Font.font_POP, 70)
		end
		if Index1 == 1 and Index2 == 1 then
			breadImage = display.newImageRect(infoGroup, "Content/images/"..BreadJson.image..".png",700,700)
		else
			breadImage = display.newImageRect(infoGroup, "Content/images/"..BreadJson.image..".png",900,900)
		end
		breadImage.x, breadImage.y = infoGround.x, infoGround.y*0.8
		bread_options = 
		{
		    text = BreadJson.sentence,     
		    x = infoGround.x,
		    y = infoGround.y*1.26,
		    width = 950,
		    height = 350,
		    font = Font.font_POP,   
		    fontSize = 55,
		    align = "center"  -- Alignment parameter
		}
		breadSentence = display.newText(bread_options)
		infoGroup:insert(breadSentence)
		breadSentence:setFillColor(0)	
		if open[Index1][Index2] == -1 then
			new = display.newImage(infoGroup, "Content/images/new.png")
			new.x, new.y = BackGround.x*0.45, BackGround.y*0.55	
			open[Index1][Index2] = 1
		end	

		if cnt > 0 then
			salekey()	
			saleKey:addEventListener("tap", sale)
		end
		if cnt > 0 and Index == 1 then 
			UpSet()
			upKey:addEventListener("tap", levelUp)
		end
		sceneGroup:insert(infoGroup)
	end

	infoBasic()


-- 방향키 작동 함수 (이전, 다음 빵으로 이동)
	local function moveLeftKey( event )
		audio.play(soundTable["clickSound"],  {channel=5})	
		local index1, index2
		if Index1 == 1 and Index2 == 1 then
		elseif Index2 == 1 then
			index1, index2 = Index1 - 1, 8
			if open[index1][index2] ~= 0 then
				composer.setVariable("Id1", index1)
				composer.setVariable("Id2", index2)
				composer.setVariable("Id", Index)
				composer.removeScene("bookInfo")		
				composer.gotoScene( "bookInfo" )
				print("옆으로 쓩")
			end
		else
			index1, index2 = Index1, Index2 - 1
			if open[index1][index2] ~= 0 then
				composer.setVariable("Id1", index1)
				composer.setVariable("Id2", index2)
				composer.setVariable("Id", Index)
				composer.removeScene("bookInfo")		
				composer.gotoScene( "bookInfo" )
				print("옆으로 쓩")
			end
		end
	end

	local function moveRightKey( event )
		audio.play(soundTable["clickSound"],  {channel=5})	
		local index1, index2
		if Index1 == 4 and Index2 == 8 then
		elseif Index2 == 8 then
			index1, index2 = Index1 + 1, 1
			if open[index1][index2] ~= 0 then
				composer.setVariable("Id1", index1)
				composer.setVariable("Id2", index2)
				composer.setVariable("Id", Index)
				composer.removeScene("bookInfo")		
				composer.gotoScene( "bookInfo" )
				print("옆으로 쓩")
			end
		else
			index1, index2 = Index1, Index2 + 1
			if open[index1][index2] ~= 0 then
				composer.setVariable("Id1", index1)
				composer.setVariable("Id2", index2)
				composer.setVariable("Id", Index)
				composer.removeScene("bookInfo")		
				composer.gotoScene( "bookInfo" )
				print("옆으로 쓩")
			end
		end
	end

-- [keyGroup] 방향키
	local keyGroup, leftKey, rightKey
	local function nextKey()
		keyGroup = display.newGroup()
		local index1, index2
		if Index1 == 1 and Index2 == 1 then
		elseif Index2 == 1 then
			index1, index2 = Index1 - 1, 8
			if open[index1][index2] ~= 0 then
				leftKey = display.newImage(keyGroup,"Content/images/illuBook_left.png")
				leftKey.x, leftKey.y = infoGround.x*0.1, infoGround.y
				leftKey:addEventListener("tap", moveLeftKey)
			end
		else
			index1, index2 = Index1, Index2 - 1
			if open[index1][index2] ~= 0 then
				leftKey = display.newImage(keyGroup,"Content/images/illuBook_left.png")
				leftKey.x, leftKey.y = infoGround.x*0.1, infoGround.y
				leftKey:addEventListener("tap", moveLeftKey)
			end
		end
		if Index1 == 4 and Index2 == 8 then
		elseif Index2 == 8 then
			index1, index2 = Index1 + 1, 1
			if open[index1][index2] ~= 0 then
				rightKey = display.newImage(keyGroup,"Content/images/illuBook_right.png")
				rightKey.x, rightKey.y = infoGround.x*1.9, infoGround.y	
				rightKey:addEventListener("tap", moveRightKey)
			end
		else
			index1, index2 = Index1, Index2 + 1
			if open[index1][index2] ~= 0 then
				rightKey = display.newImage(keyGroup,"Content/images/illuBook_right.png")
				rightKey.x, rightKey.y = infoGround.x*1.9, infoGround.y
				rightKey:addEventListener("tap", moveRightKey)	
			end
		end
		sceneGroup:insert(keyGroup)	
	end
--
	nextKey()

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
