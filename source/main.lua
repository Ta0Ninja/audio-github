local pd <const> = playdate
local gfx <const> = pd.graphics

import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/crank'
--display stuff
pd.setCrankSoundsDisabled(true)
pd.display.setScale(2)
gfx.setLineWidth(5)
gfx.setLineCapStyle(gfx.kLineCapStyleRound)
--set up variables =^]
screenSizeX, screenSizeY =pd.display:getSize()
screenCenterX, screenCenterY = screenSizeX/2, screenSizeY/2
x=(screenCenterX-(screenCenterX/1.7))-1
samplePlayerx=(screenCenterX-(screenCenterX/1.7))-1
microphoneLevel = (pd.sound.micinput.getLevel())*5
currentLineViewed = 0
--lists
pauseLines = {1}
buffers = {}
lines = {0}
data = {0, pauseLines}
--load lists
lines = pd.datastore.read('data/lines')
data = pd.datastore.read('data/audio/data')
--[[if there is something in data[2] it will
import it to the list pauseLines]]--
if #pauseLines ~= 1 then
    pauseLines = data[2]
end
--imports all of the audios to buffers list
for currentBuffer =1, data[1] do
    buffers[currentBuffer] = pd.sound.sample.new('data/audio/audio'..currentBuffer)
    print('audio imported:',#buffers)
end
--[[if there ISNT somethin in the lines list it will
set it to the microhpon level]]--
if lines[1] == 0 then
    lines[1] = microphoneLevel
end
--importing images
boaderImage = gfx.image.new("images/boader")
--then import things so they can use the variables
import 'recording'
import 'boader'
import 'menu'
makeBoader(boaderImage)
--main loop
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
	crankTicks = pd.getCrankTicks(7)
    --amplifies the microphone level so you can see it better
    microphoneLevel = (pd.sound.micinput.getLevel()*5)
    microphoneSource = pd.sound.micinput.getSource()

    --draw lines
    --draws every line in the list every frame
    for currentLine = 1, #lines do
        if recording == true then
            if currentLine == #lines then
                --[[if its recording then it will add
                new lines to the list once per for loop]]--
                lines[#lines+1] = microphoneLevel
            end
        end
        --drawing the other lines
        gfx.drawLine(
            x+(currentLine/1.5),
            (screenCenterY-10*(lines[currentLine])),
            x+1+(currentLine/1.5),
            (screenCenterY+10*(lines[currentLine]))
        )
    end
    --line shows you where you are when sample is playing
    if samplePlaying == true then
        gfx.drawLine(
            samplePlayerx,
            (screenCenterY-20),
            samplePlayerx+1,
            (screenCenterY+20)
        )
        --increases the position of the line by this much each frame
        samplePlayerx+=0.71
    end
    --recorder
    if pd.buttonJustPressed(pd.kButtonA) then
        if recording then
            --force stop recording
            pd.sound.micinput.stopRecording()
            pd.sound.micinput.stopListening()
            recording = false
        else
            --start recording
            buffers[#buffers+1] = pd.sound.sample.new(10, pd.sound.kFormat16bitStereo)
            pd.sound.micinput.recordToSample(buffers[#buffers], endOfRecording)
            pd.sound.micinput.startListening(microphoneSource)
            recording = true
            print('started recording :~}')
        end
    end
    --player
    if pd.buttonJustPressed(pd.kButtonB) then
        --[[you can only play stuff-
        -if there is audio TO play and if your not recording =^} ]]--
        if #buffers > 0 then
            if recording == false then
                if samplePlaying == false then
                    --plays from first audio   
                    print('playnig audio')
                    samplePlaying = true
                    currentAudioSelection =1
                    currentLineViewed = 0
                    buffers[currentAudioSelection]:play()
                    currentAudioSelection+=1
                    samplePlayerx=(screenCenterX-(screenCenterX/1.7))-1
                elseif samplePlaying == true then
                    print('stoped audio\n')
                    --stops the audio playing
                    samplePlaying = false
                    samplePlayerx=(screenCenterX-(screenCenterX/1.7))-1
                end
            end
        end
    end
    -- playing one audio after another
    if samplePlaying then
        currentLineViewed +=1
        if currentAudioSelection > 1 then
            if currentAudioSelection <#data[2] then
                if currentLineViewed == data[2][currentAudioSelection]-1 then
                    buffers[currentAudioSelection]:play()
                    currentAudioSelection+=1
                    print('played next audio',currentAudioSelection-1)
                end
            end
        end
    end

end