local notes = {}
local cooldowns = {}

QBCore = exports['qb-core']:GetCoreObject()

local function InitializeDatabase()
    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS `player_notes` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(60) NOT NULL,
            `note_content` text NOT NULL,
            `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `identifier` (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged)
        print("^2Notes database initialized with oxmysql^7")
    end)
end

InitializeDatabase()

-- Function to give item based on inventory system
local function GiveNoteItem(source, noteContent)
    if Config.Inventory == 'qb-inventory' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            -- Add metadata to store note content
            local info = {
                note = noteContent
            }
            print("^3[DEBUG] Adding note with content: " .. noteContent .. "^7")
            Player.Functions.AddItem(Config.NoteItem.name, 1, false, info)
            TriggerClientEvent('QBCore:Notify', source, "Note added and item received!", Config.Notifications.success.type, Config.Notifications.success.duration)
        else
            print("^1[ERROR] Player not found! source: " .. tostring(source) .. "^7")
        end
    elseif Config.Inventory == 'ox_inventory' then
        print("^3[DEBUG] Adding note with content (ox): " .. noteContent .. "^7")
        exports.ox_inventory:AddItem(source, Config.NoteItem.name, 1, {
            note = noteContent
        })
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Note System',
            description = 'Note added and item received!',
            type = Config.Notifications.success.type,
            duration = Config.Notifications.success.duration
        })
    end
end

RegisterNetEvent('pixel-notes:saveNote', function(note)
    local src = source
    local now = os.time()

    if Config.Cooldown.enabled and cooldowns[src] and now - cooldowns[src] < Config.Cooldown.duration then
        if Config.Inventory == 'qb-inventory' then
            TriggerClientEvent('QBCore:Notify', src, "You're adding notes too quickly, please wait!", Config.Notifications.error.type, Config.Notifications.error.duration)
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Note System',
                description = "You're adding notes too quickly, please wait!",
                type = Config.Notifications.error.type,
                duration = Config.Notifications.error.duration
            })
        end
        return
    end

    cooldowns[src] = now
    local identifier = GetPlayerIdentifier(src, 0)

    exports.oxmysql:execute(
        'INSERT INTO player_notes (identifier, note_content) VALUES (?, ?)',
        { identifier, note },
        function()
            GiveNoteItem(src, note)
        end
    )
end)

RegisterNetEvent('pixel-notes:loadNote', function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    exports.oxmysql:fetch(
        'SELECT note_content FROM player_notes WHERE identifier = ? ORDER BY created_at DESC LIMIT 1',
        { identifier },
        function(result)
            if result and result[1] then
                TriggerClientEvent('pixel-notes:loadNote', src, result[1].note_content)
            else
                TriggerClientEvent('pixel-notes:loadNote', src, '')
            end
        end
    )
end)

-- Item usage event
RegisterNetEvent('pixel-notes:useNote', function(item)
    local src = source
    local noteContent = nil

    print("^3[DEBUG] Received item usage request^7")
    print("^3[DEBUG] Full item data: " .. json.encode(item) .. "^7")

    if Config.Inventory == 'qb-inventory' then
        -- For qb-inventory, check both possible locations of the note content
        if item.info and item.info.note then
            noteContent = item.info.note
            print("^3[DEBUG] Found note in item.info.note: " .. tostring(noteContent) .. "^7")
        elseif item.metadata and item.metadata.note then
            noteContent = item.metadata.note
            print("^3[DEBUG] Found note in item.metadata.note: " .. tostring(noteContent) .. "^7")
        else
            print("^1[ERROR] No note content found in item^7")
            print("^1[ERROR] Item info: " .. json.encode(item.info) .. "^7")
            print("^1[ERROR] Item metadata: " .. json.encode(item.metadata) .. "^7")
        end
    else -- ox_inventory
        -- For ox_inventory, we need to get the item metadata from the inventory
        local inventory = exports.ox_inventory:GetInventory(src)
        print("^3[DEBUG] Retrieved inventory from ox_inventory: " .. json.encode(inventory) .. "^7")
        
        if inventory and inventory.items then
            for _, invItem in pairs(inventory.items) do
                if invItem.slot == item.slot then
                    if invItem.metadata and invItem.metadata.note then
                        noteContent = invItem.metadata.note
                        print("^3[DEBUG] Found note content in ox_inventory metadata: " .. tostring(noteContent) .. "^7")
                    end
                    break
                end
            end
        end
        
        if not noteContent then
            print("^1[ERROR] No note content found in ox_inventory item^7")
            print("^1[ERROR] Inventory items: " .. json.encode(inventory and inventory.items or {}) .. "^7")
        end
    end

    if noteContent and noteContent ~= "" then
        print("^2[SUCCESS] Showing note content to player^7")
        TriggerClientEvent('pixel-notes:showNote', src, noteContent)
    else
        print("^1[ERROR] Note content is empty or nil^7")
        if Config.Inventory == 'qb-inventory' then
            TriggerClientEvent('QBCore:Notify', src, "This note is empty!", Config.Notifications.error.type, Config.Notifications.error.duration)
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Note System',
                description = "This note is empty!",
                type = Config.Notifications.error.type,
                duration = Config.Notifications.error.duration
            })
        end
    end
end)
