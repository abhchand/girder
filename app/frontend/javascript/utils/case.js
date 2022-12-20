const toSnakeCase = (string) => {
  return string.replace(/\W+/gu, ' ')
    .split(/ |\B(?=[A-Z])/u)
    .map(word => word.toLowerCase())
    .join('_');
};

export { toSnakeCase }
