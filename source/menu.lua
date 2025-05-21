local pd <const> = playdate
local gfx <const> = pd.graphics

-- menu items
function pd.gameWillPause()
        local menu = pd.getSystemMenu()
        menu:removeAllMenuItems()
        --reset to new auido
        menu:addMenuItem("new =^0", function()
            --remove lines
            lines = {0}
            pd.datastore.write(lines, 'data/lines', true)
            --delet audio
            buffers = {}
            data[1] = 0
            pd.datastore.write(data, 'data/audio/data', true)
            --stop sample playing
            samplePlaying = false
            samplePlayerx=(screenCenterX-(screenCenterX/1.7))-1
            print('\nit reset >^]')
        end)
    end
    