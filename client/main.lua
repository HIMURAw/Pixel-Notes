QBCore = exports['qb-core']:GetCoreObject()
local isNotepadOpen = false
local isNoteOpen = false

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

-- Function to show a note
function ShowNote(noteContent)
    isNoteOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "showNote",
        note = noteContent
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

RegisterNUICallback('closeNote', function(data, cb)
    isNoteOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Event handlers
RegisterNetEvent('pixel-notes:loadNote')
AddEventHandler('pixel-notes:loadNote', function(note)
    SendNUIMessage({
        type = "loadNote",
        note = note
    })
end)

RegisterNetEvent('pixel-notes:showNote')
AddEventHandler('pixel-notes:showNote', function(noteContent)
    ShowNote(noteContent)
end)

RegisterNetEvent('pixel-notes:notification')
AddEventHandler('pixel-notes:notification', function(message)
    -- You can use your preferred notification system here
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end)

-- Item usage
RegisterNetEvent('pixel-notes:useNote')
AddEventHandler('pixel-notes:useNote', function(item)
    print("^3[DEBUG] Item usage triggered^7")
    print("^3[DEBUG] Full item data: " .. json.encode(item) .. "^7")

    if Config.Inventory == 'qb-inventory' then
        -- For qb-inventory, we need to pass the complete item data
        if item then
            print("^3[DEBUG] Sending complete qb-inventory item data^7")
            TriggerServerEvent('pixel-notes:useNote', item)
        else
            print("^1[ERROR] No item data received^7")
        end
    else
        -- For ox_inventory, we need to pass the slot number
        if item and item.slot then
            print("^3[DEBUG] Sending ox_inventory item slot: " .. item.slot .. "^7")
            TriggerServerEvent('pixel-notes:useNote', {slot = item.slot})
        else
            print("^1[ERROR] No slot information found in ox_inventory item^7")
        end
    end
end)
