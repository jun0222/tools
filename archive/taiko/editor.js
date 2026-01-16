const notes = [];
const timeline = document.getElementById('timeline');

function render() {
  timeline.innerHTML = '';
  notes.forEach(note => {
    const el = document.createElement('div');
    el.className = `note ${note.type}`;
    el.style.left = `${note.time}px`;
    el.textContent = note.type === 'don' ? 'ド' : 'カ';
    timeline.appendChild(el);
  });
}

function addNote(type) {
  const time = notes.length * 100;
  notes.push({ time, type });
  render();
}

document.getElementById('addDon').addEventListener('click', () => addNote('don'));
document.getElementById('addKa').addEventListener('click', () => addNote('ka'));

document.addEventListener('keydown', e => {
  if (e.code === 'KeyD') addNote('don');
  if (e.code === 'KeyK') addNote('ka');
});

document.getElementById('save').addEventListener('click', () => {
  localStorage.setItem('taikoNotes', JSON.stringify(notes));
});

document.getElementById('load').addEventListener('click', () => {
  const loaded = JSON.parse(localStorage.getItem('taikoNotes') || '[]');
  notes.length = 0;
  notes.push(...loaded);
  render();
});

render();
