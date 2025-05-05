local isNotepadOpen = false

-- Command to open the notepad
RegisterCommand('notepad', function()
    if not isNotepadOpen then
        OpenNotepad()
    else
        CloseNotepad()
    end
end)

-- Key binding (F7 by default)
RegisterKeyMapping('notepad', 'Open Notepad', 'keyboard', 'F7')

-- Function to open the notepad
function OpenNotepad()
    isNotepadOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openNotepad"
    })
end

-- Function to close the notepad
function CloseNotepad()
    isNotepadOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeNotepad"
    })
end

-- NUI Callbacks
RegisterNUICallback('closeNotepad', function(data, cb)
    CloseNotepad()
    cb('ok')
end)

RegisterNUICallback('saveNote', function(data, cb)
    TriggerServerEvent('pixel-notes:saveNote', data.note)
    cb('ok')
end)

RegisterNUICallback('loadNote', function(data, cb)
    TriggerServerEvent('pixel-notes:loadNote')
    cb('ok')
end)

-- Event handler for loading notes
RegisterNetEvent('pixel-notes:loadNote')
AddEventHandler('pixel-notes:loadNote', function(note)
    SendNUIMessage({
        type = "loadNote",
        note = note
    })
end) 