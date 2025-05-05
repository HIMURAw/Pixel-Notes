local notes = {}

-- Save note for a player
RegisterNetEvent('pixel-notes:saveNote')
AddEventHandler('pixel-notes:saveNote', function(note)
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not notes[identifier] then
        notes[identifier] = {}
    end
    
    notes[identifier] = note
end)

-- Load note for a player
RegisterNetEvent('pixel-notes:loadNote')
AddEventHandler('pixel-notes:loadNote', function()
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    if notes[identifier] then
        TriggerClientEvent('pixel-notes:loadNote', source, notes[identifier])
    else
        TriggerClientEvent('pixel-notes:loadNote', source, '')
    end
end) 