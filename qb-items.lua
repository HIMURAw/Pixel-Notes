QBShared.Items = {
    ['stickynote'] = {
        name = 'stickynote',
        label = 'Note',
        weight = 1,
        type = 'item',
        image = 'stickynote.png',
        unique = true,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'A note with written text',
        client = {
            event = 'pixel-notes:useNote',
            anim = { dict = 'mp_common', clip = 'givetake1_a' },
            prop = { model = 'prop_note_01', pos = vec3(0.0, 0.0, 0.0), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
        }
    }
} 