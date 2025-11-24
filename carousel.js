document.addEventListener('DOMContentLoaded', () => {
  const carousel = document.querySelector('.carousel');
  if (!carousel) return;

  const container = carousel.querySelector('.carousel-container');
  const items = Array.from(container.querySelectorAll('.carousel-item'));
  const prevBtn = carousel.querySelector('.carousel-btn.prev');
  const nextBtn = carousel.querySelector('.carousel-btn.next');
  const indicatorsWrap = carousel.querySelector('.carousel-indicators');

  if (items.length === 0) return;

  let index = items.findIndex(it => it.classList.contains('active'));
  if (index === -1) index = 0;

  if (indicatorsWrap) {
    indicatorsWrap.innerHTML = '';
    items.forEach((_, i) => {
      const dot = document.createElement('span');
      dot.className = 'dot' + (i === index ? ' active' : '');
      dot.addEventListener('click', () => {
        index = i;
        showSlide();
        resetAutoplay();
      });
      indicatorsWrap.appendChild(dot);
    });
  }

  function updateTransform() {
    container.style.transform = `translateX(${-index * 100}%)`;
  }
  function updateActive() {
    items.forEach((it, i) => it.classList.toggle('active', i === index));
    const dots = indicatorsWrap ? indicatorsWrap.querySelectorAll('.dot') : [];
    dots.forEach((d, i) => d.classList.toggle('active', i === index));
  }
  function showSlide() {
    if (index < 0) index = items.length - 1;
    if (index >= items.length) index = 0;
    updateTransform();
    updateActive();
  }

  prevBtn && prevBtn.addEventListener('click', () => { index--; showSlide(); resetAutoplay(); });
  nextBtn && nextBtn.addEventListener('click', () => { index++; showSlide(); resetAutoplay(); });

  const AUTOPLAY_MS = 5000;
  let autoplay = setInterval(() => { index++; showSlide(); }, AUTOPLAY_MS);
  function resetAutoplay() {
    clearInterval(autoplay);
    autoplay = setInterval(() => { index++; showSlide(); }, AUTOPLAY_MS);
  }

  carousel.addEventListener('mouseenter', () => clearInterval(autoplay));
  carousel.addEventListener('mouseleave', () => resetAutoplay());
  carousel.addEventListener('focusin', () => clearInterval(autoplay));
  carousel.addEventListener('focusout', () => resetAutoplay());

  let startX = 0, distX = 0;
  const THRESHOLD = 40;
  carousel.addEventListener('touchstart', (e) => { startX = e.touches[0].clientX; distX = 0; clearInterval(autoplay); });
  carousel.addEventListener('touchmove', (e) => { distX = e.touches[0].clientX - startX; });
  carousel.addEventListener('touchend', () => {
    if (Math.abs(distX) > THRESHOLD) {
      if (distX < 0) index++; else index--;
      showSlide();
    }
    resetAutoplay();
  });

  showSlide();
});
