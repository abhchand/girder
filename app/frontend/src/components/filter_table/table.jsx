import './table.scss';

import PropTypes from 'prop-types';
import React from 'react';

const Table = (props) => {
  /*
   * This is *not* a component-level empty state. It is a table-level empty state
   * that's shown when there are 0 displayable items (because of a search filter
   * or any other reason).
   *
   * If the FilterTable itself should be replaced with alternate when zero rows
   * exist, that will need to be implemented outside the <FilterTable>.
   */
  if (props.itemCount === 0) {
    const i18nPrefix = 'components.filter_table.table';
    return (
      <div className='filter-table--empty-state'>
        {I18n.t(`${i18nPrefix}.empty_state`)}
      </div>
    );
  }

  return (
    <div className='filter-table__table'>
      <table>
        <thead>{props.thead}</thead>
        <tbody>{props.tbody}</tbody>
      </table>
    </div>
  );
};

Table.propTypes = {
  tbody: PropTypes.node.isRequired,
  thead: PropTypes.node.isRequired,

  itemCount: PropTypes.number.isRequired
};

export default Table;
