/* eslint max-len: "off" */
/* eslint react/prefer-stateless-function: "off" */

import PropTypes from 'prop-types';
import React from 'react';

class IconArrowThickLeft extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  };

  render() {
    return (
      // Icons/arrow-thick-left.svg
      <svg
        width={this.props.size}
        height={this.props.size}
        xmlns='http://www.w3.org/2000/svg'
        viewBox='0 0 8 8'>
        <path
          d='M3 0l-3 3.03 3 2.97v-2h5v-2h-5v-2z'
          transform='translate(0 1)'
          fill={this.props.fillColor}
        />
      </svg>
    );
  }
}

class IconArrowThickRight extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  };

  render() {
    return (
      // Icons/arrow-thick-right.svg
      <svg
        width={this.props.size}
        height={this.props.size}
        xmlns='http://www.w3.org/2000/svg'
        viewBox='0 0 8 8'>
        <path
          d='M5 0v2h-5v2h5v2l3-3.03-3-2.97z'
          transform='translate(0 1)'
          fill={this.props.fillColor}
        />
      </svg>
    );
  }
}

class IconCheckMark extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  };

  render() {
    return (
      <svg
        width={this.props.size}
        height={this.props.size}
        viewBox='0 0 100 100'
        version='1.1'
        xmlns='http://www.w3.org/2000/svg'>
        <g
          id='icon-check-mark'
          stroke='none'
          strokeWidth='1'
          fill='none'
          fillRule='evenodd'>
          <path
            d='M34.515206,64.5123812 L22.8508108,52.8441027 C22.2651825,52.2582891 22.2652575,51.308671 22.8509785,50.7229501 L22.8508108,50.7227824 L29.2147718,44.3588213 C29.8005582,43.7730349 30.7503057,43.7730349 31.3360921,44.3588213 L43.0029419,56.0256711 L90.0226009,9.01169393 C90.6083976,8.42596679 91.5580965,8.42599494 92.1438584,9.01175682 L92.1439213,9.01169393 L98.5078823,15.375655 C99.0936688,15.9614414 99.0936688,16.9111889 98.5078823,17.4969753 L43,73.0048576 L34.5113646,64.5162222 Z'
            id='check-mark'
            fill={this.props.fillColor}
          />
          <path
            d='M81.8913561,11.4892946 L75.4926012,17.8867855 C68.4939276,12.3235621 59.6350936,9 50,9 C27.3563253,9 9,27.3563253 9,50 C9,72.6436747 27.3563253,91 50,91 C72.6436747,91 91,72.6436747 91,50 C91,44.2947767 89.8347014,38.8617235 87.7291338,33.92587 L94.4918898,27.163114 C98.0126877,34.0086966 100,41.7722675 100,50 C100,77.6142375 77.6142375,100 50,100 C22.3857625,100 0,77.6142375 0,50 C0,22.3857625 22.3857625,0 50,0 C62.12167,0 73.235866,4.31350886 81.8913561,11.4892946 Z'
            id='circle'
            fill={this.props.fillColor}
          />
        </g>
      </svg>
    );
  }
}

class IconRefresh extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    title: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32',
    title: 'Refresh Icon'
  };

  render() {
    return (
      <svg
        width={this.props.size}
        height={this.props.size}
        viewBox='0 0 100 100'
        version='1.1'
        xmlns='http://www.w3.org/2000/svg'>
        <title>{this.props.title}</title>
        <g
          id='icon-refresh'
          stroke='none'
          strokeWidth='1'
          fill='none'
          fillRule='evenodd'>
          <path
            d='M35.5764413,7.36126098 L38.2645075,15.04145 C23.5615994,20.1139791 13,34.0735927 13,50.5 C13,71.2106781 29.7893219,88 50.5,88 C71.2106781,88 88,71.2106781 88,50.5 C88,34.0735927 77.4384006,20.1139791 62.7354925,15.04145 L65.3144338,7.67304628 C82.6278758,13.9384955 95,30.5244156 95,50 C95,74.8528137 74.8528137,95 50,95 C25.1471863,95 5,74.8528137 5,50 C5,30.191978 17.7980998,13.3731124 35.5764413,7.36126098 Z'
            id='Combined-Shape'
            fill={this.props.fillColor}
            transform='translate(50.000000, 51.180630) rotate(19.000000) translate(-50.000000, -51.180630) '
          />
          <polygon
            id='Triangle'
            fill={this.props.fillColor}
            transform='translate(56.000000, 9.500000) rotate(90.000000) translate(-56.000000, -9.500000) '
            points='56 3.5 65 15.5 47 15.5'
          />
        </g>
      </svg>
    );
  }
}

class IconTrash extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    title: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32',
    title: 'Trash Icon'
  };

  render() {
    return (
      <svg
        width={this.props.size}
        height={this.props.size}
        viewBox='0 0 32 32'
        version='1.1'
        xmlns='http://www.w3.org/2000/svg'>
        <title>{this.props.title}</title>
        <defs></defs>
        <g
          id='Page-1'
          stroke='none'
          strokeWidth='1'
          fill='none'
          fillRule='evenodd'
          strokeLinecap='square'>
          <g
            id='Artboard-3'
            stroke={this.props.fillColor}
            strokeWidth='1.39655172'>
            <g id='Group' transform='translate(4.500000, -2.000000)'>
              <path
                d='M8.64379085,9.54310345 L8.64379085,33.2844828'
                id='Line'></path>
              <path
                d='M2.92611111,8.76724138 L2.92611111,32.5086207'
                id='Line'></path>
              <path
                d='M2.93137255,33.2844828 L20.0686275,33.2844828'
                id='Line'></path>
              <path
                d='M14.3562092,9.54310345 L14.3562092,33.2844828'
                id='Line'></path>
              <path
                d='M20.0738889,8.76724138 L20.0738889,32.5086207'
                id='Line'></path>
              <path
                d='M0.0751633987,8.14655172 L22.9248366,8.14655172'
                id='Line'></path>
              <path
                d='M0.0766666667,6.98275862 L22.9233333,6.98275862'
                id='Line'></path>
              <path
                d='M7.21568627,5.50862069 L7.21568627,4.11206897'
                id='Line'></path>
              <path
                d='M15.7843137,5.50862069 L15.7843137,4.11206897'
                id='Line'></path>
              <path
                d='M8.64379085,2.71551724 L14.3562092,2.71551724'
                id='Line'></path>
            </g>
          </g>
        </g>
      </svg>
    );
  }
}

class IconUserWithKey extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  };

  render() {
    return (
      <svg
        width={this.props.size}
        height={this.props.size}
        viewBox='0 0 100 100'
        version='1.1'
        xmlns='http://www.w3.org/2000/svg'>
        <title>{this.props.title}</title>
        <g
          id='icon-users'
          stroke='none'
          strokeWidth='1'
          fill='none'
          fillRule='evenodd'>
          <path
            d='M7,81.3559322 C7,62.0479403 19.9975977,45.7561832 37.7736624,40.646951 C31.5804942,36.7387584 27.4705882,29.8632027 27.4705882,22.0338983 C27.4705882,9.86491229 37.3993323,0 49.6470588,0 C61.8947853,0 71.8235294,9.86491229 71.8235294,22.0338983 C71.8235294,29.8632027 67.7136234,36.7387584 61.5204552,40.646951 C79.2965199,45.7561832 92.2941176,62.0479403 92.2941176,81.3559322 L92.2941176,91.5254237 C73.3398693,97.1751412 59.124183,100 49.6470588,100 C40.1699346,100 25.9542484,97.1751412 7,91.5254237 L7,81.3559322 Z'
            id='person'
            fill={this.props.fillColor}></path>
          <circle
            id='bubble'
            stroke={this.props.fillColor}
            strokeWidth='3'
            fill='#FFFFFF'
            cx='22.5'
            cy='77.5'
            r='21'></circle>
          <g id='key' transform='translate(10.000000, 65.000000)'>
            <polygon
              id='ridges'
              fill={this.props.fillColor}
              points='13 9 0 24 0 26 6 26 6 22 11 22 11 17 16 17 19 15'></polygon>
            <circle
              id='head'
              fill={this.props.fillColor}
              cx='20'
              cy='8'
              r='8'></circle>
            <circle id='hole' fill='#FFFFFF' cx='21' cy='7' r='2'></circle>
          </g>
        </g>
      </svg>
    );
  }
}

export {
  IconArrowThickLeft,
  IconArrowThickRight,
  IconCheckMark,
  IconRefresh,
  IconTrash,
  IconUserWithKey
};
