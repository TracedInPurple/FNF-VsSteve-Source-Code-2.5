-- this gets called starts when the level loads.
function start(song) -- arguments, the song name
    print("Succesfully loaded (practice)... have fun ;)")
    for i = 4, 7 do -- go to the center
        tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 275,getActorAngle(i) + 0, 0.6, 'setDefault')
    end
    for i = 0, 3 do -- go off screen
        tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 500,getActorAngle(i) + 0, 0.6, 'setDefault')
    end



    function setDefault(id)
	_G['defaultStrum'..id..'X'] = getActorX(id)
    end
end
