return {
    ['stickynote'] = {
        label = 'Note',
        weight = 1,
        stack = false,
        close = true,
        description = 'A note with written text',
        client = {
            event = 'pixel-notes:useNote',
            anim = { dict = 'mp_common', clip = 'givetake1_a' },
            prop = { model = 'prop_note_01', pos = vec3(0.0, 0.0, 0.0), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
        }
    }
} 