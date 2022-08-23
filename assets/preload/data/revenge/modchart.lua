-- this gets called starts when the level loads.
function start(song) -- arguments, the song name
    print("Succesfully loaded (revenge)... have fun ;)")
        

end

-- this gets called every beat
function beatHit(beat)

end

-- this gets called every step
function stepHit(step) 
    if curStep == 64 then
        for i = 4, 7 do -- go to the center
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 275,getActorAngle(i) + 0, 0.6, 'setDefault')
        end
    end
    if curStep == 64 then
        strumLine1Visible = false -- removes the first line of notes and strums lol
        for i=0,3 do
            tweenFadeIn(i,0,0.1)
        end
    end
end





function setDefault(id)
	_G['defaultStrum'..id..'X'] = getActorX(id)
end