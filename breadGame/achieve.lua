-----------------------------------------------------------------------------------------
--
-- achieve.lua
--
-----------------------------------------------------------------------------------------

-- JSON 파싱
local json = require('json')
local json2 = require('json')
local json3 = require('json')

local Data, pos, msg
local Data2, pos2, msg2
local Data3, pos3, msg3

local function parse()
	local filename = system.pathForFile("Content/JSON/achieveList.json")
	Data, pos, msg = json.decodeFile(filename)
	local filename2 = system.pathForFile("Content/JSON/ingredient.json")
	Data2, pos2, msg2 = json.decodeFile(filename2)
	local filename3 = system.pathForFile("Content/JSON/questCnt.json")
	Data3, pos3, msg3 = json.decodeFile(filename3)

	--디버그
	if Data then
		print(Data[1].title)
	else
		print(pos)
		print(msg)
	end
	--
end
parse()

local composer = require( "composer" )
local scene = composer.newScene()
--돈 전역변수
--coinNum = 0
--빵 제작 전역변수
--bread_count = 0
--폭탄빵 제작 전역변수
--bomb_count = 0
--연속 일반빵 제작 전역변수
--breadNormal_count = 0
--폭탄빵 연속 제작 전역변수
--breadBomb_count = 0
--빵 도감 채운 개수 전역변수
--breadBook_count = openBreadsCnt()
--breadBook_count = 0
--빵 방 빵 채운 개수 전역변수
--breadRoom_count = 0

--빵 도감 채운 개수 전역변수
breadBook_count = 0
--업그레이드 빵 도감 채운 개수
breadBookUP_count = 0
for n = 1, 4 do
	for m = 1, 8 do	
		if openBread[n][m] ~= 0 then
			breadBook_count = breadBook_count + 1
		end
	end
end
for n = 1, 4 do
	for m = 1, 8 do
		if openUBread[n][m] ~= 0 then
			breadBookUP_count = breadBookUP_count + 1
		end
	end
end

function scene:create( event )
	local sceneGroup = self.view
	--배경
	local background = display.newImageRect("Content/images/업적/achieveBG.png", display.contentWidth, display.contentHeight)
	background.x, background.y = display.contentWidth/2, display.contentHeight/2
	--배경 위
	--local top = display.newImage("Content/images/업적/top.png")
	--top.x, top.y = display.contentWidth/2, display.contentHeight*0.05
	--홈 버튼
	local home = display.newImage("Content/images/업적/home.png", display.contentWidth*0.9, display.contentHeight*0.05)
	--업적 디자인
	local icon = display.newImage("Content/images/업적/achieveIcon.png", 200, 200)
	icon.x, icon.y = display.contentWidth*0.15, display.contentHeight*0.05
	--업적 제목
	local acheiveName = display.newImage("Content/images/업적/achieveText.png", display.contentWidth*0.26, display.contentHeight*0.05)
	--돈 상자
	local goldBox = display.newImage("Content/images/업적/gold.png", display.contentWidth*0.5, display.contentHeight*0.05)
	--돈 상자 표시(임시)
	--local goldText = display.newText(coinNum, display.contentWidth*0.54, display.contentHeight*0.053,"font/ONE Mobile POP.ttf", 40)
	--goldText:setTextColor(0)
	--goldText.text = coinNum
	------------showCoin 관련 수정
	coinX = 0.586 - (string.len(coinNum)-1)*0.01
	showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.052
	--아래 그림자
	local shadow = display.newImage("Content/images/업적/shadow.png")
	shadow.x, shadow.y = display.contentWidth/2, display.contentHeight*0.86
	local SE2 = audio.loadSound("Content/audio/reward.wav")
	local SE3 = audio.loadSound("Content/audio/cash.wav")
	
	local questGroup = display.newGroup()

	local questBox = {} 			--큰 상자
	local quest_title = {}			--제목
	local quest_info = {}			--설명
	local title_red = {}			--빨간 제목 리본
	local title_blue = {}			--파랑 제목 리본					
	local priceImg = {}					--동전 그림
	local price = {}				--보상
	local title = {}				--제목
	local info = {}					--정보
	local cat = {}					--고양이 그림
	local catHide ={}				--고양이 숨김
	local priceText = {} 			--돈 금액
	local finishText = {} 			--교육 완료!
	local bubble_p = {} 			--말풍선 분홍
	local bubble_w = {} 			--말풍선 하양
	local cntBText = {}				--업적 달성 표시
	local cntB = {}					--업적 달정 목표
	local cntBIng = {}				--업적 달성 현황
	local flag = {}					--전역 변수 넘겨받기용

	local q = {}					--업적 달성 성공: 1 표시 변수
	for i = 1, 7 do
		q[i] = {}
	end

	--2차원 배열
	for i = 1, 7 do
		priceImg[i] = {}
		price[i] = {}
		title[i] = {}
		info[i] = {}
		cat[i] = {}
		catHide[i] = {}
		priceText[i] = {}
		finishText[i] = {}
		bubble_p[i] = {}
		bubble_w[i] = {}
		cntBText[i] = {}
		cntB[i] = {}
		cntBIng[i] = {}
	end


--------연습-------------

	--quest_clear[1][1] = 1
	--quest_clear[2][1] = 1
	--quest_clear[2][2] = 1
	--quest_clear[2][3] = 1
	--quest_clear[2][4] = 1
	--quest_clear[3][1] = 1
	--quest_clear[3][2] = 1
	--quest_clear[4][1] = 1
	--quest_clear[4][2] = 1
	--quest_clear[5][1] = 1
	--quest_clear[5][2] = 1
	--quest_clear[5][3] = 1
	--quest_clear[5][4] = 1
	--quest_clear[6][1] = 1
	--quest_clear[6][2] = 1
	--quest_clear[6][3] = 1
	--quest_clear[6][4] = 1
	--quest_clear[7][1] = 1
	--quest_clear[7][2] = 1
	--quest_clear[7][3] = 1

----------------------


---------홈 이동------- 


	local function start(event)
	---------showCoin 관련 수정
		coinX = 0.584 - (string.len(coinNum)-1)*0.01
		showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.04
		audio.play(SE1, {channel=5})
		composer.gotoScene("home")
	end
	home:addEventListener("tap", start)


---------화면에 배치------
	--행--
	for i = 1, #Data do
			--흰 상자
			questBox[i] = display.newImage(questGroup, Data[i].img)
			questBox[i].x, questBox[i].y = display.contentWidth/2, display.contentHeight*0.15 + 700*(i-1)
			--제목 파랑
			title_blue[i] = display.newImage(questGroup, Data[i].titleImg2)
			title_blue[i].x, title_blue[i].y = questBox[i].x, questBox[i].y - 250
			title_blue[i].isVisible = false
			--제목 빨강
			title_red[i] = display.newImage(questGroup, Data[i].titleImg1)
			title_red[i].x, title_red[i].y = questBox[i].x, questBox[i].y - 250
			--제목 글
			quest_title[i] = display.newText(questGroup, Data[i].title, display.contentWidth*0.5, questBox[i].y-260, "Content/font/ONE Mobile POP.ttf")
			quest_title[i].size = 50
			quest_title[i]:setFillColor(1)
			--정보 글
			quest_info[i] = display.newText(questGroup, Data[i].info, display.contentWidth*0.5, questBox[i].y-110, "Content/font/ONE Mobile POP.ttf")
			--quest_info[i].align = left
			quest_info[i].size = 45
			quest_info[i]:setFillColor(0)
			--제목 내용
			title[i][1] = Data[i].title1
			title[i][2] = Data[i].title2
			title[i][3] = Data[i].title3
			title[i][4] = Data[i].title4
			--정보 내용
			info[i][1] = Data[i].info1
			info[i][2] = Data[i].info2
			info[i][3] = Data[i].info3
			info[i][4] = Data[i].info4
			--업적 달성 목표
			cntB[i][1] = Data[i].cntB1
			cntB[i][2] = Data[i].cntB2
			cntB[i][3] = Data[i].cntB3
			cntB[i][4] = Data[i].cntB4
			--보상 내용
			price[i][1] = Data[i].price1
			price[i][2] = Data[i].price2
			price[i][3] = Data[i].price3
			price[i][4] = Data[i].price4
			--고양이 얼굴
			cat[i][1] = display.newImage(questGroup, Data[i].cat1)
			cat[i][2] = display.newImage(questGroup, Data[i].cat2)
			cat[i][3] = display.newImage(questGroup, Data[i].cat3)
			cat[i][4] = display.newImage(questGroup, Data[i].cat4)
			cat[i][1].isVisible = false
			cat[i][2].isVisible = false
			cat[i][3].isVisible = false
			cat[i][4].isVisible = false
			--말풍선 분홍
			bubble_p[i][1] = display.newImage(questGroup, Data[i].bubble_pink1)
			bubble_p[i][2] = display.newImage(questGroup, Data[i].bubble_pink2)
			bubble_p[i][3] = display.newImage(questGroup, Data[i].bubble_pink3)
			bubble_p[i][4] = display.newImage(questGroup, Data[i].bubble_pink4)
			bubble_p[i][1].isVisible = false
			bubble_p[i][2].isVisible = false
			bubble_p[i][3].isVisible = false
			bubble_p[i][4].isVisible = false
			--보상 사진
			priceImg[i][1] = display.newImage(questGroup, Data[i].priceImg1)
			priceImg[i][2] = display.newImage(questGroup, Data[i].priceImg2)
			priceImg[i][3] = display.newImage(questGroup, Data[i].priceImg3)
			priceImg[i][4] = display.newImage(questGroup, Data[i].priceImg4)
			priceImg[i][1].isVisible = false
			priceImg[i][2].isVisible = false
			priceImg[i][3].isVisible = false
			priceImg[i][4].isVisible = false

		--열--
		for j = 1, 4 do
			--줄마다 고양이 개수 조절
			if i == 1 and j == 2 then
				break
			end
			if i == 3 and j == 3 then
				break
			end
			if i == 4 and j == 3 then
				break
			end
			if i == 7 and j == 4 then
				break
			end
			--고양이 위치
			cat[i][j].x, cat[i][j].y = questBox[i].x - 435 + (j-1)*290, questBox[i].y + 120
			--고양이 숨기기
			catHide[i][j] = display.newImage(questGroup, Data[i].catHide)
			catHide[i][j].x, catHide[i][j].y = questBox[i].x - 435 + (j-1)*290, questBox[i].y + 120
			--목표 표시
			cntBText[i][j] = display.newText(questGroup, Data[i].cntB, questBox[i].x - 430 + (j-1)*290, questBox[i].y + 140, "Content/font/ONE Mobile POP.ttf")
			cntBText[i][j].size = 30
			cntBText[i][j]:setFillColor(1)
			--목표 현황 표시
			cntBIng[i][j] = display.newText(questGroup, "0", questBox[i].x - 465 + (j-1)*290, questBox[i].y + 140, "Content/font/ONE Mobile POP.ttf")
			cntBIng[i][j].size = 30
			cntBIng[i][j]:setFillColor(1)
			cntBIng[i][j].isVisible = false
			--말풍선 분홍
			--bubble_p[i][j] = display.newImage(questGroup, Data[i].bubble_pink)
			bubble_p[i][j].x, bubble_p[i][j].y = questBox[i].x - 435 + (j-1)*290, questBox[i].y - 10
			--bubble_p[i][j].isVisible = false
			--말풍선 하양
			bubble_w[i][j] = display.newImage(questGroup, Data[i].bubble_white)
			bubble_w[i][j].x, bubble_w[i][j].y = questBox[i].x - 435 + (j-1)*290, questBox[i].y - 10
			bubble_w[i][j].isVisible = false
			--동전 이미지
			--priceImg[i][j] = display.newImage(questGroup, "Content/images/업적/coin.png")
			priceImg[i][j].x, priceImg[i][j].y = questBox[i].x - 490 + (j-1)*290, questBox[i].y - 15
			--priceImg[i][j].isVisible = false
			--보상 표시
			priceText[i][j] = display.newText(questGroup, Data[i].price, questBox[i].x - 405 + (j-1)*290, questBox[i].y - 10, "Content/font/ONE Mobile POP.ttf")
			priceText[i][j].size = 33
			priceText[i][j]:setFillColor(0)
			--교육 완료!
			finishText[i][j] = display.newText(questGroup, "교육완료!", questBox[i].x - 430 + (j-1)*290, questBox[i].y - 5, "Content/font/ONE Mobile POP.ttf")
			finishText[i][j].size = 35
			finishText[i][j]:setFillColor(0.5)
			finishText[i][j].isVisible = false
		end
	end
-----------업적 현황 표시----------

	local cntQ = {}
	for i = 1, 7 do
		cntQ[i] = {}
	end
---달성 조건 배열로 넣기(코드 길이 줄이는 용도)
	for i = 1, 7 do
		cntQ[i][1] = Data3[i].qCnt1
		cntQ[i][2] = Data3[i].qCnt2
		cntQ[i][3] = Data3[i].qCnt3
		cntQ[i][4] = Data3[i].qCnt4
	end

---flag 변수에 값 넣기(코드 길이 줄이는 용도)
	flag[1] = 1
	flag[2] = bread_count
	flag[3] = breadNormal_count
	flag[4] = breadBomb_count
	flag[5] = bomb_count
	flag[6] = breadBook_count + breadBookUP_count
	flag[7] = breadRoom_count

---현황 시작되면 표시
	for i = 2, 7 do
		if flag[i] > 0 then
			cntBText[i][1].text = cntB[i][1]							--표시 위한 목표 값 넣기
			cntBText[i][1].x = questBox[i].x - 410 + (1-1)*290			--위치 수정
			cntBIng[i][1].isVisible = true								--표시 위한 현황 값 표시
			cntBIng[i][1].text = flag[i]								--표시 위한 현황 값 넣기
		end
		for j = 2, 4 do
			if i == 3 and j == 3 then
				break
			end
			if i == 4 and j == 3 then
				break
			end
			if i == 7 and j == 4 then
				break
			end
			if flag[i] > cntQ[i][j - 1] then
				cntBText[i][j].text = cntB[i][j]						--표시 위한 목표 값 넣기
				cntBText[i][j].x = questBox[i].x - 410 + (j-1)*290		--위치 수정
				cntBIng[i][j].isVisible = true							--표시 위한 현황 값 표시
				cntBIng[i][j].text = flag[i]							--표시 위한 현황 값 넣기
			end
		end
	end

	----------업적 목표 도달 시---------

	--q[1][1] = 1
	quest_clear[1][1] = 1
	for i = 2, 7 do
		for j = 1, 4 do
			if i == 3 and j == 3 then
				break
			end
			if i == 4 and j == 3 then
				break
			end
			if i == 7 and j == 4 then
				break
			end
			if flag[i] >= cntQ[i][j] then
				--q[i][j] = 1
				quest_clear[i][j] = 1
			end
		end
	end


-------------업적 달성 시----------

	for i = 1, 7 do
		for j = 1, 4 do
			if quest_clear[i][j] == 1 then
				quest_title[i].text = title[i][j]							--제목 변화
				quest_info[i].text = info[i][j]								--정보 변화
				cat[i][j].isVisible = true									--고양이 등장
				cntBText[i][j].isVisible = false							--업적 목표 표시 지우기
				cntBIng[i][j].isVisible = false								--업적 현황 지우기
				display.remove(catHide[i][j])								--고양이 숨기기 지우기
				if i == 1 and j == 1 then									--줄마다 업적 모두 달성시 제목 빨강->파랑
					display.remove(title_red[i])
					title_blue[i].isVisible = true
				elseif i == 3 and j == 2 then
					display.remove(title_red[i])
					title_blue[i].isVisible = true
				elseif i == 4 and j == 2 then
					display.remove(title_red[i])
					title_blue[i].isVisible = true
				elseif i == 7 and j == 3 then
					display.remove(title_red[i])
					title_blue[i].isVisible = true
				elseif j == 4 then
					display.remove(title_red[i])
					title_blue[i].isVisible = true
				end
				if price_have[i][j] == 1 then
					bubble_w[i][j].isVisible = true							--말풍선 하양 표시
					finishText[i][j].isVisible = true						--교육 완료! 표시
				else
					bubble_p[i][j].isVisible = true								--말풍선 분홍 등장
					priceImg[i][j].isVisible = true									--동전 이미지 등장
					priceText[i][j].text = price[i][j]							--보상 표시
					if type(price[i][j]) ~= "number" then						--보상이 돈이 아니면
						--priceImg[i][j].isVisible = false							--동전 이미지 숨기기
						priceText[i][j].x = priceText[i][j].x + 6				--보상 글 위치 더 옆으로
						priceText[i][j].size = 34								--글씨 더 크게
					end
					if type(price[i][j]) == "number" then
						if price[i][j] >= 10000 then
							priceImg[i][j].x = priceImg[i][j].x - 7
							priceText[i][j].x = priceText[i][j].x + 4
						end
					end
					local function catch(event)									--보상 클릭 시
						--audio.play(SE2, {channel=7})
						--audio.stopWithDelay(420, {channel=7})
						display.remove(bubble_p[i][j])							--말풍선 분홍 지우기
						display.remove(priceText[i][j])							--보상 표시 지우기
						price_have[i][j] = 1 									--보상받음 표시
						if type(price[i][j]) == "number" then 					--보상이 돈이면
							audio.play(SE3, {channel=7})
							audio.stopWithDelay(770, {channel=7})
							coinNum = coinNum + price[i][j]						--총 금액에 더하기
							--goldText.text = coinNum							--화면에 총 금액 표시(임시)
							showCoin.text = coinNum								--화면에 총 금액 표시
							coinX = 0.586 - (string.len(coinNum)-1)*0.01
							showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.052
						elseif price[i][j] == "시럽 3종" then					--보상이 시럽 3종이면	
							audio.play(SE2, {channel=4})
							audio.stopWithDelay(420, {channel=4})								
							ingreCnt[2] = ingreCnt[2] + 1 						--시럽 3종 개수 각각 +1
							ingreCnt[3] = ingreCnt[3] + 1
							ingreCnt[4] = ingreCnt[4] + 1
						elseif price[i][j] == "재료 7종" then					--보상이 부재료 7종이면
							audio.play(SE2, {channel=4})
							audio.stopWithDelay(420, {channel=4})	
							ingreCnt[5] = ingreCnt[5] + 1 						--부재료 7종 개수 각각 +1
							ingreCnt[6] = ingreCnt[6] + 1
							ingreCnt[7] = ingreCnt[7] + 1
							ingreCnt[8] = ingreCnt[8] + 1
							ingreCnt[9] = ingreCnt[9] + 1
							ingreCnt[10] = ingreCnt[10] + 1
							ingreCnt[11] = ingreCnt[11] + 1
						elseif price[i][4] == "카펫" then						--보상이 카펫이면
							audio.play(SE2, {channel=4})
							audio.stopWithDelay(420, {channel=4})
							if i == 2 then
								wallCnt[5] = 1
								wallPaperFlag[5] = 1
							end
							if i == 5 then 
								wallCnt[6] = 1
								wallPaperFlag[6] = 1
							end
						end
						priceImg[i][j].isVisible = false							--동전 이미지 지우기
						bubble_w[i][j].isVisible = true							--말풍선 하양 표시
						finishText[i][j].isVisible = true						--교육 완료! 표시
					end
					bubble_p[i][j]:addEventListener("tap", catch)				--클릭 시
				end
			end
		end
	end

	local widget = require( "widget" )
	local function scroll( event )
		if ( event.phase == "began" ) then
			display.getCurrentStage():setFocus( event.target )
			event.target.isFocus = true

			event.target.yStart = event.target.y

		elseif ( event.phase == "moved" ) then
			if ( event.target.isFocus ) then
				event.target.y = event.target.yStart + event.yDelta	
			end
		elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
			if ( event.target.isFocus ) then
			display.getCurrentStage():setFocus( nil )
			event.target.isFocus = false
			end
			display.getCurrentStage():setFocus( nil )
			event.target.isFocus = false
		end
		if ( event.limitReached ) then
	        if ( event.direction == "up" ) then print( "Reached bottom limit" )
	        elseif ( event.direction == "down" ) then print( "Reached top limit" )
	        end
	    end
	end
	local scrollView = widget.newScrollView(
		{
	        horizontalScrollDisabled=true,
	        top = 250,
	        width = 1440,
	        height = 2300,
	        backgroundColor = { 0, 0, 0, 0 }
		}
	)
	scrollView:insert(questGroup)
	scrollView:addEventListener("touch", scroll)


	--레이어 정리--
	sceneGroup:insert(background)
	sceneGroup:insert(scrollView)
	--sceneGroup:insert(top)
	sceneGroup:insert(home)
	sceneGroup:insert(icon)
	sceneGroup:insert(acheiveName)
	sceneGroup:insert(goldBox)
	--sceneGroup:insert(goldText)		-- 임시
	sceneGroup:insert(shadow)
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
		composer.removeScene("achieve")		
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