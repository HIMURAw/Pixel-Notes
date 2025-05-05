Config = {}

-- Inventory Selection
Config.Inventory = 'ox_inventory' -- Options: 'qb-inventory' or 'ox_inventory'

-- Item Settings
Config.NoteItem = {
    name = 'stickynote',
    label = 'Note',
    weight = 1,
    stack = false,
    close = true,
    description = 'A note with written text'
}

-- Cooldown Settings
Config.Cooldown = {
    enabled = true,
    duration = 5 -- seconds
}

-- Notification Settings
Config.Notifications = {
    success = {
        type = 'success',
        duration = 5000
    },
    error = {
        type = 'error',
        duration = 5000
    }
}
