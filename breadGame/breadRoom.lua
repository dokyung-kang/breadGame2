---- 인벤토리 ---

local composer = require( "composer" )
local scene = composer.newScene()
local text_list
local close
local check

local levelNum

local background_room1
local background_room2
local background_carpet
local homeIcon
local bookIcon
local breadIcon
local text_breadRoom
local coinIcon
local gray_upperLeft
local gray_upperRight
local gray_lowerLeft
local gray_lowerRight
local text_bookIcon
local store
local text_storeIcon
local temp
local text_tempIcon
local breadRoom
local text_breadRoomIcon
local pushIcon
local text_push
local text_deco
local dia

local icon
local icon_inven = {}
local check_list = {}
local check_inven = {}
local bread_name = {}
local bread_name_text = {}
local bread_inven = {}
local pushIcon
local text_push2
local breadRoom_image = {}
--local breadGroup = display.newGroup()
local k
--local breadRoom_count = 0 		--전역변수 때문에 지웁니다!
-- 넣은 빵의 세부정보 --
--[[local breadInfo_background
local breadInfo_profile

local breadInfo_image = {}
local breadInfo_level = {} -- 빵 도감에서 주는 Json에서는 breadInfo에 레벨 정보까지 추가하기
local breadInfo_name = {}
local breadInfo_text = {}
local breadInfoGroup = display.newGroup()]]

local reverse
local t1
-- count 변수 : 빵방에 넣은 빵이 없을 때 인덱스 에러 피하기 위한 장치 --
local count = 0

-- 새빵 (미해금0 , 해금 -1, 확인했음 1로 변화)
--[[
openBread = { {-1, 1, 1, 1, -1, 1, 1, 1}, {-1, 0, 0, 0, 0, 0, 0, 0}, 
				{1, 0, 0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0, 0, 0} }
openUBread = { {1, 1, 1, 1, 1, 1, 1, 1}, {0, 0, 0, 0, 0, 0, 0, 0}, 
				{0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0} }	

]]

--사운드
soundTable = {
	clickSound = audio.loadSound( "Content/audio/click.wav" ),
}

--JSON 파싱
local json = require('json')

local function parse()
	local filename = system.pathForFile("Content/JSON/breadInfo.json")
	Data, pos, msg = json.decodeFile(filename)
end

-- 업그레이드 빵 파싱
local function parseUBreadInfo() 
	filename = system.pathForFile("Content/JSON/ubreadInfo.json")
	uBreadInfo = json.decodeFile(filename)
	
end

parse()
parseUBreadInfo()

---*꾸미기방 위해서------------------------------------------------------------
local function carpet_parse()
	local filename = system.pathForFile("Content/JSON/wallPaper.json")
	wallPaper, pos, msg = json.decodeFile(filename)

	if wallPaper then
		print(wallPaper[1].name)
	else
		print(pos)
		print(msg)
	end
end
carpet_parse()

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

-- 장식 회수 관련 코드----------------------------------
function comebackToList( event )
	if ( event.phase == "began" ) then
		display.getCurrentStage():setFocus( event.target )
		event.target.isFocus = true
	elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
		audio.play( soundTable["clickSound"],  {channel=5}) 

		local idx = event.target.idx 
		event.target:removeSelf()
		breadRoom_deco[idx] = nil

		print(idx)
		print(decoFlag[idx])
		
		decoFlag[idx] = 1
		delete_deco_from_list[idx] = 0
		end
	display.getCurrentStage():setFocus( nil )
	event.target.isFocus = false
end
	
local breadOutGroup = display.newGroup()
----------------------------------------------------------------

function scene:create( event )
	local sceneGroup = self.view

    -- 배경 --
	background_room1 = display.newImageRect("Content/images/room1.png", display.contentWidth, display.contentHeight)
	background_room1.x, background_room1.y = display.contentWidth*0.5, display.contentHeight*0.5

	background_room2 = display.newImageRect("Content/images/room2.png", display.contentWidth, display.contentHeight)
	background_room2.x, background_room2.y = display.contentWidth*0.5, display.contentHeight*0.5

	background_carpet = display.newImageRect("Content/images/carpet.png", display.contentWidth, display.contentHeight)
	background_carpet.x, background_carpet.y = display.contentWidth*0.5, display.contentHeight*0.5
	background_carpet.isVisible = false

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
	
	-- 빵 넣기 아이콘 --
	local putBreadGroup = display.newGroup()
	pushIcon = display.newImageRect("Content/images/push.png", display.contentWidth*0.25, display.contentHeight*0.05)
	pushIcon.x, pushIcon.y = display.contentWidth*0.24, display.contentHeight*0.15

	text_push = display.newImage("Content/images/text_breadPush.png")
	text_push.x, text_push.y = display.contentWidth*0.24, display.contentHeight*0.15
    text_push:toFront()

	local list

	local breadRoom_image = {}
	breadGroup = display.newGroup()

	-- 넣은 빵의 세부정보 --
	local breadInfo_background
	local breadInfo_profile

	local breadInfo_image = {}
	local breadInfo_level = {} -- 빵 도감에서 주는 Json에서는 breadInfo에 레벨 정보까지 추가하기
	local breadInfo_name = {}
	local breadInfo_text = {}
	local breadInfoGroup = display.newGroup()
	--local breadOutGroup = display.newGroup()
	local haveopen = 0

	local function BreadMove(obj)
		print("빵무브")
		wMove = math.random( 2, 5 )
		hMove = math.random( 5, 7 )
		speed = math.abs(wMove - obj.x) * math.random( 90, 120 )
		transition.moveTo( obj, { x=wMove, y=hMove, time=speed } )
		t1 = timer.performWithDelay(1000, shake, 0)   
	end
	-- Bmove에 대상 이미지!
	local function shake(event)
		print("shake")
		local t10 = event.target.param10

		--BreadMove(breadRoom_image[t10])
		if (reverse == 0) then
		reverse = 1
		transition.to(event.target, {rotation=-15, time=2, transition=easing.inOutCubic })
		else
		reverse = 0
		transition.to(event.target, {rotation=15, time=2, transition=easing.inOutCubic })
		end   
		print(reverse)
	end

	-- 뒤뚱뒤뚱 걸어가기...
	-- 예) walk(breadRoom_image[k])   
	local function rockRect(event)
       if ( reverse == 0 ) then
           reverse = 1
           transition.to( event.source.obj , { rotation=-5, time=600, transition=easing.inOutCubic } )
       else
           reverse = 0
           transition.to( event.source.obj , { rotation=5, time=600, transition=easing.inOutCubic } )
       end
   end   

    local function walk(b)         
      fun2 = timer.performWithDelay( 600, rockRect, 0 )
      fun2.obj = b
      local dx = math.random( 100, 1300 )
      local dy = math.random( 600, 2000 )
      print(dx..", "..dy)
      distanceX = math.abs(dx-b.x)
      distanceY = math.abs(dy-b.y)
      transition.to( b, { time = (distanceX + distanceY) * 10, x = dx, y = dy, transition=easing.linear } )
    end
    --walk(b13)

	--클릭하면 커졌다가 작아짐 (b13에 오브젝트 대입!)
	-- 작아지지 않는 에러 발생
   --[[local function re( event )
      transition.scaleTo( event.source.obj , { xScale=1, yScale=1, time=800 } )
   end

   local function taptap1( event )
      transition.scaleTo( event.target, { xScale=1.2, yScale=1.2, time=800 } )    
      fun = timer.performWithDelay( 800, re, 1 ) 
      fun.obj = event.name    
   end
   --b13:addEventListener("tap", taptap1)
   ]]
		
	local function infoClosed(event)
		audio.play( soundTable["clickSound"],  {channel=5}) 
	--	for i=1, 64 do
			--if(breadInfo_name[i] ~= nill) then
				breadInfoGroup:toBack()
				--closeIcon:removeSelf()
		--	end
		--end
	end
	
	-- 빵 클릭시 세부 정보 뜨게 --
	local function show_breadinfo(event)
		if( event.phase == "began" ) then
			if(haveopen == 0) then
				display.getCurrentStage():setFocus( event.target )
				event.target.isFocus = true

				audio.play( soundTable["clickSound"],  {channel=5}) 

				local k = event.target.param2
				local index1 = event.target.param12
				local index2 = event.target.param13
				local info = event.target.param14

				--print("출력은 "..k)
					-- 빵 정보 창 --
				breadInfo_background = display.newImageRect(breadInfoGroup, "Content/images/breadInfo_background.png", display.contentWidth, display.contentHeight*0.2)
				breadInfo_background.x, breadInfo_background.y = display.contentWidth*0.5, display.contentHeight*0.9
				
				breadInfo_profile = display.newImageRect(breadInfoGroup, "Content/images/breadInfo_profile.png", display.contentWidth*0.25, display.contentHeight*0.15)
				breadInfo_profile.x, breadInfo_profile.y = display.contentWidth*0.2, display.contentHeight*0.9

				if (lv ~= nill) then
					levelNum = Bread_level[index1][index2]
				else
					levelNum = 1
				end
				breadInfo_level = display.newText(breadInfoGroup, "Lv." .. levelNum ,display.contentWidth*1.5, display.contentHeight*1.5,"Content/font/ONE Mobile POP.ttf", 75)
				breadInfo_level:setFillColor(0)
				breadInfo_level.x, breadInfo_level.y = display.contentWidth*0.41, display.contentHeight*0.84

				name = info[index1].breads[index2].name
				breadInfo_name[k] =  display.newText(breadInfoGroup, name, display.contentWidth*0.5, display.contentHeight*0.6, "Content/font/ONE Mobile POP.ttf")
				breadInfo_name[k]:setFillColor(0)
				breadInfo_name[k].size = 75	

				length = string.len(name)
				--print("빵이름 길이는" .. length)

				-- 빵 이름 길이에 상관없이 위치 잘 뜨게 --
				mul = 0.55
				nul = length / 3
				mul = mul + (0.018 * (nul-2))
				breadInfo_name[k].x, breadInfo_name[k].y = display.contentWidth*mul, display.contentHeight*0.84
				
				sentence = info[index1].breads[index2].sentence
				breadInfo_text[k] =  display.newText(breadInfoGroup, sentence, display.contentWidth*0.5, display.contentHeight*0.68, "Content/font/ONE Mobile POP.ttf")
				breadInfo_text[k]:setFillColor(0)
				breadInfo_text[k].size = 50
				breadInfo_text[k].x, breadInfo_text[k].y = display.contentWidth*0.67, display.contentHeight*0.92

				image = info[index1].breads[index2].image
				breadInfo_image[k] = display.newImageRect(breadInfoGroup, "Content/images/"..image..".png", display.contentWidth*0.17, display.contentHeight*0.1)
				breadInfo_image[k].x, breadInfo_image[k].y = display.contentWidth*0.2, display.contentHeight*0.9

				breadInfoGroup:toFront()

				closeIcon = display.newImageRect(breadInfoGroup, "Content/images/close.png", display.contentWidth*0.1, display.contentHeight*0.05)
				closeIcon.x, closeIcon.y = display.contentWidth*0.962, display.contentHeight*0.811

				sceneGroup:insert(breadInfoGroup)
				closeIcon:addEventListener("tap", infoClosed)
			end
		elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
			display.getCurrentStage():setFocus( nil )
			event.target.isFocus = false
		end
	end

	-- 빵 넣기 클릭 이벤트 --
	function catch(event)
		if ( event.phase == "began" ) then
			display.getCurrentStage():setFocus( event.target )
			event.target.isFocus = true
		elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
			if (haveopen == 0) then
				haveopen = 1
				audio.play( soundTable["clickSound"],  {channel=5}) 

				list = display.newImageRect(putBreadGroup, "Content/images/list.png", display.contentWidth*0.78, display.contentHeight*0.62)
				list.x, list.y = display.contentWidth*0.5, display.contentHeight*0.54
		
				text_list = display.newImage(putBreadGroup, "Content/images/text_breadList.png")
				text_list.x, text_list.y = display.contentWidth*0.5, display.contentHeight*0.27

				close = display.newImageRect(putBreadGroup, "Content/images/close.png", display.contentWidth*0.1, display.contentHeight*0.05)
				close.x, close.y = display.contentWidth*0.8565, display.contentHeight*0.24
				
				push = display.newImageRect(putBreadGroup, "Content/images/push.png", display.contentWidth*0.25, display.contentHeight*0.05)
				push.x, push.y = display.contentWidth*0.5, display.contentHeight*0.79

				text_push2 = display.newImage(putBreadGroup, "Content/images/text_push2.png")
				text_push2.x, text_push2.y = display.contentWidth*0.477, display.contentHeight*0.79

				-- ***미해금까지 같이 뜨게 하여 에러 해결 중*** --
				sceneGroup:insert(putBreadGroup)

				index1, index2 = 1, 1
				local jul = 0.15

				breadsCNT = 64
				local m = 0
				
				local iconIndex = 1
				-- 일반 빵 -- 
				for i=1, 64 do 
					if i <= 32 then -- '일반 빵'에서 해금된 빵 가져오기
						jsc = openBread
						info = Data
					else -- '업글 빵'에서 해금된 빵 가져오기
						jsc = openUBread
						info = uBreadInfo
					end

					lock = jsc[index1][index2]
						if i % 3 == 1 then
							jul = jul + 0.33
						end

					local j = i + 3

					-- 도감에서 미해금(0)이 아닌 경우 빵이 뜨게 하기(해금(-1), 확인(1)) --
					if lock ~= 0 then
						-- 흰색 네모 창 --
						icon_inven[iconIndex] = display.newImageRect(breadGroup, "Content/images/icon.png", display.contentWidth*0.23, display.contentHeight*0.12)

						icon_inven[iconIndex].param2 = index1
						icon_inven[iconIndex].param3 = index2
						icon_inven[iconIndex].param4 = info

						image = info[index1].breads[index2].image
						bread_inven[iconIndex] = display.newImageRect(breadGroup,  "Content/images/"..image..".png", display.contentWidth*0.16, display.contentHeight*0.08)
						bread_inven[iconIndex].x, bread_inven[iconIndex].y = display.contentWidth*0.25, display.contentHeight*0.37

						breadName = info[index1].breads[index2].name
						bread_name[iconIndex] = display.newText(breadGroup, breadName, display.contentWidth*0.2, display.contentHeight*0.2,"Content/font/ONE Mobile POP.ttf", 34)
						bread_name[iconIndex]:setFillColor(0)
						breadGroup:toFront()

						-- 한 줄에 3개씩 뜨게 위치 설정--
						if(j%3 == 1 or i == 1) then
							icon_inven[iconIndex].x = display.contentWidth*0.13
							icon_inven[iconIndex].y = display.contentHeight*(0.177 + (0.13*m))

							bread_name[iconIndex].x = display.contentWidth*0.136
							bread_name[iconIndex].y = display.contentHeight*(0.225 + (0.13*m))

							bread_inven[iconIndex].x = display.contentWidth*0.14
							bread_inven[iconIndex].y = display.contentHeight*(0.177 + (0.13*m))	
							iconIndex = iconIndex + 1	
						end
						if(j%3 == 2 or i == 2) then
							icon_inven[iconIndex].x = display.contentWidth*0.38
							icon_inven[iconIndex].y = display.contentHeight*(0.177 + (0.13*m))
						
							bread_name[iconIndex].x = display.contentWidth*0.386
							bread_name[iconIndex].y = display.contentHeight*(0.225 + (0.13*m))

							bread_inven[iconIndex].x = display.contentWidth*0.39
							bread_inven[iconIndex].y = display.contentHeight*(0.177 + (0.13*m))
							iconIndex = iconIndex + 1
						end
						if(j%3 ==0) then
							icon_inven[iconIndex].x = display.contentWidth*0.63
							icon_inven[iconIndex].y = display.contentHeight*(0.177 + (0.13*m))

							bread_name[iconIndex].x = display.contentWidth*0.636
							bread_name[iconIndex].y = display.contentHeight*(0.225 + (0.13*m))

							bread_inven[iconIndex].x = display.contentWidth*0.63
							bread_inven[iconIndex].y = display.contentHeight*(0.177 + (0.13*m))
							iconIndex = iconIndex + 1
							m = m + 1
						end
						--print("icon개수는"..iconIndex)
						
						-- 체크표시했으면(빵방에 넣었으면) 닫기 눌렀다가 빵넣기 다시 눌러도 체크가 다시 나타나게 함
						for i=1,  breadsCNT do 
							if(check_list[i] ~= nill) then
								check_inven[i].isVisible = true
								if(check_list[i] == 0) then
									check_inven[i]:toFront()
								end
							end
						end
					-- *** 에러 해결용 추가 코드 *** --
					else
						icon_inven[iconIndex] = display.newImageRect(breadGroup, "Content/images/illu_book_secret.png", display.contentWidth*0.29, display.contentHeight*0.17)

						breadGroup:toFront()
						
						-- 한 줄에 3개씩 뜨게 위치 설정--
						if(j%3 == 1 or i == 1) then
							icon_inven[iconIndex].x = display.contentWidth*0.13
							icon_inven[iconIndex].y = display.contentHeight*(0.18 + (0.13*m))
							iconIndex = iconIndex + 1	
						end
						if(j%3 == 2 or i == 2) then
							icon_inven[iconIndex].x = display.contentWidth*0.38
							icon_inven[iconIndex].y = display.contentHeight*(0.18 + (0.13*m))
							iconIndex = iconIndex + 1
						end
						if(j%3 ==0) then
							icon_inven[iconIndex].x = display.contentWidth*0.63
							icon_inven[iconIndex].y = display.contentHeight*(0.18 + (0.13*m))
							iconIndex = iconIndex + 1
							m = m + 1
						end
					end
					index2 = index2 + 1
						if index2 == 9 then
							index2 = 1
							index1 = index1 + 1
						end

						if i==32 then
							index1, index2 = 1, 1
							info = uBreadInfo
						end
				end

				-- 스크롤 --
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
					-- *** 에러 해결용 추가 코드 *** --
					if ( event.limitReached ) then
						if ( event.direction == "up" ) then print( "Reached bottom limit" )
						elseif ( event.direction == "down" ) then print( "Reached top limit" )
						end
					end
				end

				local scrollView = widget.newScrollView(
					{
						horizontalScrollDisabled=true,
						left = 165,
						top = 790,
						width = 1115,
						height = 1150,
						backgroundColor = { 0, 0, 0 , 0}

					}
				)

				-- 빵을 체크 클릭/해제할 때 발생하는 이벤트 --
				function checked( event )
					if ( event.phase == "began" ) then
						print("체크했당")

						audio.play( soundTable["clickSound"],  {channel=5}) 
						
						-- 몇 번째 아이콘인지 매개변수 전달 --
						local k = event.target.param1
						local index1 = event.target.param2
						local index2 = event.target.param3
						local info = event.target.param4

						-- 0인 경우 체크 제거 --
						if(check_list[k] == 0) then
							breadRoom_count = breadRoom_count - 1
							display.remove(check_inven[k])
							display.remove(breadRoom_image[k])
							check_list[k] = 1

						-- 1인 경우 체크 추가 --
						else
							breadRoom_count = breadRoom_count + 1
							--print(k.."체크인벤 k값")
							check_inven[k] = display.newImageRect(breadGroup, "Content/images/check.png", display.contentWidth*0.027, display.contentHeight*0.014)
						
							local n1 = k % 3
							local n2 = math.floor(k / 3)

							if event.target.x >= 907 then
								check_inven[k].x = event.target.x*0.859
								check_inven[k].y = display.contentHeight*(n2 * 0.13)
							elseif event.target.x >= 547 then
								check_inven[k].x = event.target.x*0.762
								check_inven[k].y = display.contentHeight*((n2 + 1) * 0.13)
							elseif event.target.x >= 187 then
								check_inven[k].x = event.target.x*0.315
								check_inven[k].y = display.contentHeight*((n2 + 1) * 0.13)
							end
							--print(idx1)
							--print(event.target.x)	
							--print(event.target.y)	

							check_list[k] = 0

							-- 체크와 동시에 빵방에 삽입 --
							image = info[index1].breads[index2].image
							breadRoom_image[k] = display.newImageRect(breadOutGroup, "Content/images/"..image..".png", display.contentWidth*0.17, display.contentHeight*0.1)
							breadRoom_image[k].x, breadRoom_image[k].y = math.random(display.contentWidth*0.088, display.contentWidth*0.915), math.random(display.contentHeight*0.26, display.contentHeight*0.72)
							breadRoom_image[k]:toBack()
						
							breadRoom_image[k].param12 = index1
							breadRoom_image[k].param13 = index2
							breadRoom_image[k].param14 = info
							
							breadRoom_image[k]:addEventListener("touch", show_breadinfo)

							breadRoom_image[k].param10 = k
							breadRoom_image[k]:addEventListener("touch", shake)

							-- 새로 추가한 모션 --
							walk(breadRoom_image[k])
							
							sceneGroup:insert(breadOutGroup)
							putBreadGroup:toFront()

							for i=1, breadsCNT do -- 빵 개수만큼 체크 개수 생성
								if(check_list[i] == 0 and check_inven[i] ~= nill) then
									--check_inven[i]:toFront()
									breadRoom_image[i].param2 = i
								end
							end
							
						end
						display.getCurrentStage():setFocus( event.target )
						event.target.isFocus = true

						-- 빵방에 있는 빵 개수 카운트 --
					elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
					end
					display.getCurrentStage():setFocus( nil )
					event.target.isFocus = false
				end

				scrollView:insert(breadGroup)
				scrollView:addEventListener("touch", scroll)
				putBreadGroup:insert(scrollView)

				-- 창 닫기 --
				local function closed( event )
					if ( event.phase == "began" ) then
						display.getCurrentStage():setFocus( event.target )
						event.target.isFocus = true
					elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
						audio.play( soundTable["clickSound"],  {channel=5}) 
						haveopen = 0
						putBreadGroup:toBack()

						for i=1, breadsCNT do
							display.remove(bread_name[i])
							display.remove(icon_inven[i])
							display.remove(bread_inven[i])

							-- 체크 잠시 사라지게 했다가 다시 뜨게 함
							--if(check_list[i] == 0 and check_inven[i] ~= nill) then
							if(check_inven[i] ~= nill) then
								check_inven[i].isVisible = false
							end
						end
					end
					display.getCurrentStage():setFocus( nil )
					event.target.isFocus = false
				end

				close:addEventListener("touch", closed)

				index1, index2 = 1, 1
				local jsc, index
				for i=1, 64 do 
					if i <= 32 then -- '일반 빵'에서 해금된 빵 가져오기
						jsc = openBread
						info = Data
					else -- '업글 빵'에서 해금된 빵 가져오기
						jsc = openUBread
						info = uBreadInfo
					end
					lock = jsc[index1][index2]
					if lock ~= 0 then
						icon_inven[i].param1 = i
						--print(lock)
						icon_inven[i]:addEventListener("touch", checked)
					end

					index2 = index2 + 1
						if index2 == 9 then
							index2 = 1
							index1 = index1 + 1
						end

						if i==32 then
							index1, index2 = 1, 1
							info = uBreadInfo
						end
				end
				push:addEventListener("touch", closed)
			end
		end
		display.getCurrentStage():setFocus( nil )
		event.target.isFocus = false
	end	
	pushIcon:addEventListener("touch", catch)

	-- 씬 이동 --
	local function moveToBook(event)
		audio.play( soundTable["clickSound"],  {channel=5}) 
		print("도감으로 이동")
		---------showCoin 관련 수정
		showCoin.isVisible = false
		showCoin.x, showCoin.y = display.contentWidth*0.35, display.contentHeight*0.04
		showCoin:setFillColor(0)
		-------수정	
			if(count > 0) then
				for i=1, breadsCNT do
					if(breadRoom_image[i] ~= nill) then
						breadRoom_image[i].isVisible = false
					end
				end
			end
		composer.gotoScene("bookMain")
	end

	local function moveToStore(event)
		audio.play( soundTable["clickSound"],  {channel=5}) 
		print("상점으로 이동")
		---------------showCoin 관련 수정
		showCoin.isVisible = true
		coinX = 0.583 - (string.len(coinNum)-1)*0.01
		showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.05
		showCoin:setFillColor(0)
		-------수정	
			if(count > 0) then
				for i=1, breadsCNT do
					if(breadRoom_image[i] ~= nill) then
						breadRoom_image[i].isVisible = false
					end
				end
			end
		composer.gotoScene("store_i")
	end

	local function moveToAchieve(event)
		audio.play( soundTable["clickSound"],  {channel=5}) 
		print("업적으로 이동")
		---------------showCoin 관련 수정
		showCoin.isVisible = true
		coinX = 0.586 - (string.len(coinNum)-1)*0.01
		showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.053
		showCoin:setFillColor(0)
		-------수정	
			if(count > 0) then
				for i=1, breadsCNT do
					if(breadRoom_image[i] ~= nill) then
						breadRoom_image[i].isVisible = false
					end
				end
			end
		composer.gotoScene("achieve")
	end

	--* 꾸미기방 연결 -- 
	local function moveToDeco(event)
		audio.play( soundTable["clickSound"],  {channel=5}) 
		print("꾸미기로 이동")
		---------------showCoin 관련 수정
		showCoin.isVisible = true
		showCoin.x, showCoin.y = display.contentWidth*0.558, display.contentHeight*0.053
		showCoin:setFillColor(0)
		-------수정	
			if(count > 0) then
				for i=1, breadsCNT do
					if(breadRoom_image[i] ~= nill) then
						breadRoom_image[i].isVisible = false
					end
				end
			end
		composer.gotoScene("decorationC")

	end
	--
	
	local function moveToHome(event)
		audio.play( soundTable["clickSound"],  {channel=5}) 
		print("홈으로 이동")
		------------------showCoin 관련 수정
		showCoin.isVisible = true
		coinX = 0.584 - (string.len(coinNum)-1)*0.01
		showCoin.x, showCoin.y = display.contentWidth*coinX, display.contentHeight*0.04
		showCoin:setFillColor(0)
		-------수정	
			if(count > 0) then
				for i=1, breadsCNT do
					if(breadRoom_image[i] ~= nill) then
						breadRoom_image[i].isVisible = false
					end
				end
			end
		composer.gotoScene("home")
	end

	bookIcon:addEventListener("tap", moveToBook)
	store:addEventListener("tap", moveToStore)
	homeIcon:addEventListener("tap", moveToHome)
	temp:addEventListener("tap", moveToAchieve)
	dia:addEventListener("tap", moveToDeco)

	----------------에러 수정--------------------

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
	    	--sceneGroup:insert(breadGroup)
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

		--------------------------------버튼, x 탭시 팝업창 내리기---------------------------------------------------
	    local function tapListener(event)
	    	print("탭 화면사라짐")
	    end
	    --[[
	    bookIcon:addEventListener("tap", tapListener)
	    store:addEventListener("tap", tapListener)
		homeIcon:addEventListener("tap", tapListener)
		temp:addEventListener("tap", tapListener)
		]]
----------------------------------------------------------------------------------------------
		--빵방에 카펫, 장식 넣기
		if carpetIndex ~= 0 then -- 배경카펫
			print(carpetIndex .. " part5 에서")
			background_carpet = display.newImageRect(wallPaper[carpetIndex].image2, display.contentWidth, display.contentHeight)
			background_carpet.x, background_carpet.y = display.contentWidth*0.5, display.contentHeight*0.5

			composer.setVariable("forItemRoomBackground", carpetIndex)
			
			sceneGroup:insert(background_carpet)

			if breadRoom_deco[1] ~= nil then -- intro.lua에 전역변수 확인
				print("breadRoom_deco[1]를 맨 앞으로 당기자")
				breadRoom_deco[1]:toFront()
			end

			if breadRoom_deco[2] ~= nil then 
				print("breadRoom_deco[2]를 맨 앞으로 당기자")
				breadRoom_deco[2]:toFront()
			end

			if breadOutGroup ~= nil then
				print("빵 아이들을 맨 앞으로 당기자")
				breadOutGroup:toFront()
			end
			carpetIndex = 0
		end

		if decoIndex[1] == 1 then
			breadRoom_deco[decoIndex[1]] = display.newImageRect(deco[decoIndex[1]].image2, display.contentWidth*0.17, display.contentHeight*0.1)
			breadRoom_deco[decoIndex[1]].x, breadRoom_deco[decoIndex[1]].y = display.contentWidth*0.43, display.contentHeight*0.18
			breadRoom_deco[decoIndex[1]].name = "장식"..decoIndex[1]
			sceneGroup:insert(breadRoom_deco[decoIndex[1]])

			decoIndex[1] = 0
		end

		if decoIndex[2] == 2 then
			breadRoom_deco[decoIndex[2]] = display.newImageRect(deco[decoIndex[2]].image2, display.contentWidth*0.17, display.contentHeight*0.1)
			breadRoom_deco[decoIndex[2]].x, breadRoom_deco[decoIndex[2]].y = display.contentWidth*0.55, display.contentHeight*0.18
			breadRoom_deco[decoIndex[2]].name = "장식"..decoIndex[2]
			sceneGroup:insert(breadRoom_deco[decoIndex[2]])

			decoIndex[2] = 0
		end

--[[	if decoIndex ~= 0 then
			breadRoom_deco[decoIndex] = display.newImageRect(deco[decoIndex].image2, display.contentWidth*0.17, display.contentHeight*0.1)
			--자리 고정
			if decoIndex == 1 then
			breadRoom_deco[decoIndex].x, breadRoom_deco[decoIndex].y = display.contentWidth*0.43, display.contentHeight*0.18
			else
			breadRoom_deco[decoIndex].x, breadRoom_deco[decoIndex].y = display.contentWidth*0.55, display.contentHeight*0.18
			end
			--math.random(display.contentWidth*0.12, display.contentWidth*0.9), math.random(display.contentHeight*0.31, display.contentHeight*0.71)
			breadRoom_deco[decoIndex].name = "장식"..decoIndex
			sceneGroup:insert(breadRoom_deco[decoIndex])

			decoIndex = 0
		end]]
		
		for i=1, #deco do
		if breadRoom_deco[i] ~= nil then
			print("장식 회수 가능한지.")
			breadRoom_deco[i]:addEventListener("touch", comebackToList)
			breadRoom_deco[i].idx = i
		end
		end

---------------------------------------------------------------------------------------------------------------------		
	end
	
end

function scene:hide( event )

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