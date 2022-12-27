/*
 * Derive the `id` value from the Rails-style microformat name
 * E.g. -
 *  `creator[widget_attributes][0][price]` -> creator_widget_attributes_0_price
 *
 * See: https://wonderfullyflawed.wordpress.com/2009/02/17/rails-forms-microformat/
 */
const idFromName = (name) => {
  return name.replace(/\[/gu, '_').replace(/\]/gu, '');
}

export {
  idFromName
}
