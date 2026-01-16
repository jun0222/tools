const judgeLineX = 100;
const speed = 0.3; // px/ms

let notes = [];
let startTime = 0;

function render() {
  const now = Date.now() - startTime;
  const timeline = document.getElementById('timeline');
  const noteElements = timeline.getElementsByClassName('note');

  Array.from(noteElements).forEach((el, i) => {
    const noteTime = notes[i].time;
    const distance = judgeLineX + (noteTime - now) * speed;
    el.style.left = `${distance}px`;
  });

  requestAnimationFrame(render);
}

document.getElementById('start').addEventListener('click', () => {
  const saved = JSON.parse(localStorage.getItem('taikoNotes') || '[]');
  if (saved.length === 0) {
    alert('譜面がありません');
    return;
  }

  notes = saved;
  startTime = Date.now();
  requestAnimationFrame(render);
});

document.addEventListener('keydown', e => {
  if (e.code === 'Space') {
    const now = Date.now() - startTime;
    const hit = notes.find(n => Math.abs(n.time - now) < 100);
    if (hit) {
      const diff = Math.abs(hit.time - now);
      console.log(diff < 50 ? '良' : '可');
    } else {
      console.log('不可');
    }
  }
});
