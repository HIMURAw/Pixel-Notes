const notepad = document.getElementById('notepad');
const noteText = document.getElementById('noteText');
const closeBtn = document.getElementById('closeBtn');
const saveBtn = document.getElementById('saveBtn');

// Listen for messages from the game client
window.addEventListener('message', function(event) {
    const data = event.data;

    switch(data.type) {
        case 'openNotepad':
            notepad.classList.remove('hidden');
            // Load existing note when opening
            fetch(`https://${GetParentResourceName()}/loadNote`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            });
            break;

        case 'closeNotepad':
            notepad.classList.add('hidden');
            break;

        case 'loadNote':
            noteText.value = data.note;
            break;
    }
});

// Close button handler
closeBtn.addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/closeNotepad`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
});

// Save button handler
saveBtn.addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/saveNote`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            note: noteText.value
        })
    });
}); 