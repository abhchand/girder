function dateToYMD(date) {
  const d = date.getDate();
  const m = date.getMonth() + 1;
  const y = date.getFullYear();

  // eslint-disable-next-line no-magic-numbers
  return `${String(y)}-${m <= 9 ? `0${m}` : m}-${d <= 9 ? `0${d}` : d}`;
}

// Parse a date string of YYYY-MM-DD format in *local* time
function parseLocalYMDString(ymdStr) {
  if (!ymdStr) {
    return null;
  }

  const parts = ymdStr.split('-');
  // eslint-disable-next-line no-magic-numbers
  return new Date(parts[0], parts[1] - 1, parts[2]);
}

export { dateToYMD, parseLocalYMDString };
