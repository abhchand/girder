/* eslint max-len: "off" */
/* eslint react/prefer-stateless-function: "off" */

import PropTypes from 'prop-types';
import React from 'react';

class IconCheckMark extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="icon-check-mark" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <path d="M34.515206,64.5123812 L22.8508108,52.8441027 C22.2651825,52.2582891 22.2652575,51.308671 22.8509785,50.7229501 L22.8508108,50.7227824 L29.2147718,44.3588213 C29.8005582,43.7730349 30.7503057,43.7730349 31.3360921,44.3588213 L43.0029419,56.0256711 L90.0226009,9.01169393 C90.6083976,8.42596679 91.5580965,8.42599494 92.1438584,9.01175682 L92.1439213,9.01169393 L98.5078823,15.375655 C99.0936688,15.9614414 99.0936688,16.9111889 98.5078823,17.4969753 L43,73.0048576 L34.5113646,64.5162222 Z" id="check-mark" fill={this.props.fillColor} />
          <path d="M81.8913561,11.4892946 L75.4926012,17.8867855 C68.4939276,12.3235621 59.6350936,9 50,9 C27.3563253,9 9,27.3563253 9,50 C9,72.6436747 27.3563253,91 50,91 C72.6436747,91 91,72.6436747 91,50 C91,44.2947767 89.8347014,38.8617235 87.7291338,33.92587 L94.4918898,27.163114 C98.0126877,34.0086966 100,41.7722675 100,50 C100,77.6142375 77.6142375,100 50,100 C22.3857625,100 0,77.6142375 0,50 C0,22.3857625 22.3857625,0 50,0 C62.12167,0 73.235866,4.31350886 81.8913561,11.4892946 Z" id="circle" fill={this.props.fillColor} />
        </g>
      </svg>
    );
  }

}

export {
  IconCheckMark
};
