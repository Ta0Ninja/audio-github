local pd <const> = playdate
local gfx <const> = pd.graphics
--what the audio does after you finish recording
recording = false
samplePlaying = false
currentAudioSelection= 1
function endOfRecording(record)
    recording = false
    pd.sound.micinput.stopListening()
    print('recording stopped =^O')
    --setting buffers to 
    data[1] = #buffers
    pauseLines[#pauseLines+1] = #lines
    data[2] = pauseLines
    --saving to json files
    pd.datastore.write(lines, 'data/lines', true)
    pd.datastore.write(data, 'data/audio/data', true)
    --saving a pda file
    buffers[#buffers]:save('data/audio/audio'..#buffers..'.pda')
    print('recording saved\n')
end
