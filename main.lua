local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local movieclip = require( "movieclip" )

local widget = require( "widget" )

local physics = require("physics")
physics.start()
physics.setScale( 40 )
display.setStatusBar( display.HiddenStatusBar )

display.setDefault( "anchorX", 0.0 )	
display.setDefault( "anchorY", 0.0 )

bitsize=20
speed=100

horizontal=1
score=-1
colorvar=1
gamestage="menu"

function spawnsky()
	sky = display.newRect(  0, -100, 400, 700)
	sky:setFillColor(1,1,1)
end

spawnsky()

Flappy=display.newRect( 50, centerY, bitsize, bitsize)
	
function spawnflappy()
	Flappy=display.newCircle( 50, centerY, bitsize, bitsize)
	physics.addBody(Flappy, {density= 1, friction= 0, bounce= 1})
	Flappy:setFillColor ( 0, 0, 0)
	Flappy.gravityScale=0.9
	Flappy:setLinearVelocity( speed, -200)
	Flappy.isFixedRotation = true
end


function colorchange()
	score=score+1
	display.remove(ScoreText)
	ScoreText = display.newText(score, centerX-50, centerY-50, native.systemFontBold, 100 )
	ScoreText:setFillColor( 0, 0, 0)
	if score<10 then
		ScoreText.x=centerX-25
	elseif score>99 then
		ScoreText.x=centerX-75
	end
	if colorvar<6 then  
		colorvar= colorvar + 1
	else
		colorvar=1
	end
	if colorvar==1 then
		sky:setFillColor(1,0,0)
	elseif colorvar==2 then
		sky:setFillColor(1,0,1)
	elseif colorvar==3 then 
		sky:setFillColor(0,1,1)
	elseif colorvar==4 then
		sky:setFillColor(0,0,1)
	elseif colorvar==5 then
		sky:setFillColor(0,1,0)
	elseif colorvar==6 then
		sky:setFillColor(1,1,0)
	end
end



function endgame()
	gamestage="score"
	display.remove(Flappy)
	score=-1
	sky:setFillColor(1,0,0)
	timer.performWithDelay( 1000, spawnstart)
	timer.performWithDelay( 20, removewalls)
end

function removewalls()
	for i= 1,10 do
		display.remove(edgeR[i])
		display.remove(edgeL[i])
	end
end
function uppush ( event )
	if event.phase=="began" and gamestage=="begun" then
		local lvx, lvy =Flappy:getLinearVelocity()
		Flappy:setLinearVelocity( lvx, -230)
	end
end

function rebound()
	if gamestage=="begun" then
		if Flappy.x>(2*centerX)-bitsize then
			horizontal=1
			timer.performWithDelay( 20, spawnleft, 1)
			colorchange()
			Flappy:setLinearVelocity( -speed)
		end
		if Flappy.x<0 then
			horizontal=-1
			timer.performWithDelay( 20, spawnright, 1)
			colorchange()
			Flappy:setLinearVelocity( speed)
		end
	end
end

function startgame()
	display.remove(startbutton)
	gamestage="begun"
	spawnright()
	colorchange()
	display.remove(Flappy)
	spawnflappy()
	horizontal=1
end

function spawnstart()
	sky:setFillColor(1,1,1)
	startbutton= display.newImage("starticon1.png", -40, centerY+100)
	startbutton:addEventListener("touch", startgame)

end

spawnstart()

Runtime:addEventListener( "collision", endgame )
Runtime:addEventListener("enterFrame", rebound)
sky:addEventListener("touch", uppush)

edgeR={}
edgeL={}
edgeB={}
edgeT={}

function spawnright()
	local spaceR=math.random(1,9)
	for i= 1,10 do
		display.remove(edgeL[i])
		if i==spaceR or i==spaceR+1 then
		else
			edgeR[i] = display.newRect( (centerX*2), (i*50)-50, 35, 35)
			physics.addBody( edgeR[i], "static", {density=0, friction=0, bounce=0})
			edgeR[i]:setFillColor( 0, 0, 0)
			edgeR[i]:rotate( 45)
		end
	end
end

function spawnleft()
	local spaceL=math.random(1,9)
	for i= 1,10 do
		display.remove(edgeR[i])
		if i==spaceL or i==spaceL+1 then
		else
			edgeL[i] = display.newRect( 0, (i*50)-50, 35, 35)
			physics.addBody( edgeL[i], "static", {density=0, friction=0, bounce=0})
			edgeL[i]:setFillColor( 0, 0, 0)
			edgeL[i]:rotate( 45)
		end
	end
end

for i= 1,7 do
	edgeB[i] = display.newRect( (i*50)-40, (centerY*2)+20, 35, 35)
	physics.addBody( edgeB[i], "static", {density=0, friction=0, bounce=0})
	edgeB[i]:setFillColor( 0, 0, 0)
	edgeB[i]:rotate( 45)
end

for i= 1,7 do
	edgeT[i] = display.newRect( (i*50)-40, -70, 35, 35)
	physics.addBody( edgeT[i], "static", {density=0, friction=0, bounce=0})
	edgeT[i]:setFillColor( 0, 0, 0)
	edgeT[i]:rotate( 45)
end