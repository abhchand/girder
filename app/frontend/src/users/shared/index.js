function showSlidingFrame(dataId) {
  const oldEl = document.querySelector(
    '.auth-container__sliding-frame.selected'
  );
  const newEl = document.querySelector(
    `.auth-container__sliding-frame[data-id='${dataId}']`
  );

  if (oldEl.dataset.id !== newEl.dataset.id) {
    oldEl.classList.remove('selected');
    newEl.classList.add('selected');
  }
}

export { showSlidingFrame };
