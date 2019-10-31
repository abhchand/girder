import {IconCheckMark} from "components/icons";
import PropTypes from "prop-types";
import React from "react";
import mountReactComponent from "mount-react-component.jsx";

class Example extends React.Component {
  static propTypes = {
    photos: PropTypes.array.isRequired
  }

  constructor(props) {
    super(props);

    this.renderCheckMark = this.renderCheckMark.bind(this);
    this.renderPhotoElement = this.renderPhotoElement.bind(this);
  }

  renderCheckMark() {
    return <IconCheckMark fillColor="#FFFFFF" />;
  }

  renderPhotoElement(photo) {
    return (
      <li key={photo.id} data-id={photo.id}>
        {photo.id + ": " + photo.takenAt}
      </li>
    );
  }

  render() {
    let self = this;

    return (
      <ul className="page-content">
        {
          this.props.photos.map(function(photo, _photoIndex){
            return self.renderPhotoElement(photo);
          })
        }
      </ul>
    );
  }
}

export default Example;

mountReactComponent(Example, 'example');
