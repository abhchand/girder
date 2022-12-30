import axios from 'axios';
import Modal from 'javascript/components/modal';
import ModalError from 'javascript/components/modal/error';
import { parseJsonApiError } from 'utils/errors';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class ModalForm extends React.Component {
  static propTypes = {
    afterSubmit: PropTypes.func,
    afterSubmitError: PropTypes.func,
    beforeSubmit: PropTypes.func,
    closeButtonLabel: PropTypes.string,
    closeModal: PropTypes.func,
    formUrl: PropTypes.string.isRequired,
    heading: PropTypes.string.isRequired,
    httpMethod: PropTypes.string.isRequired,
    modalClassName: PropTypes.string,
    onClose: PropTypes.func,
    subheading: PropTypes.string,
    submitButtonEnabled: PropTypes.bool,
    submitButtonLabel: PropTypes.string,

    children: PropTypes.node.isRequired
  };

  static defaultProps = Modal.defaultProps;

  constructor(props) {
    super(props);

    this.onSubmit = this.onSubmit.bind(this);
    this.renderErrorText = this.renderErrorText.bind(this);

    this.state = {
      errorText: null
    };
  }

  onSubmit() {
    const self = this;

    const form = document.querySelector(
      '.modal-with-form__form-container form'
    );

    const config = {
      method: this.props.httpMethod,
      url: this.props.formUrl,
      data: new FormData(form),
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    this.setState({
      errorText: null
    });

    // Lifecycle methods
    const { afterSubmit, afterSubmitError, beforeSubmit } = this.props;

    // eslint-disable-next-line no-unused-expressions
    beforeSubmit && beforeSubmit(config);

    return axios(config)
      .then((response) => {
        // eslint-disable-next-line no-unused-expressions
        afterSubmit && afterSubmit(response);
      })
      .catch((error) => {
        const errorText = parseJsonApiError(error);

        // eslint-disable-next-line no-unused-expressions
        afterSubmitError && afterSubmitError(error, errorText);
        self.setState({ errorText: errorText });

        /*
         * Return a rejected value so the promise chain remains in
         * a rejected state
         */
        return Promise.reject(error);
      });
  }

  renderErrorText() {
    if (this.state.errorText !== null) {
      return <ModalError text={this.state.errorText} />;
    }

    return null;
  }

  render() {
    return (
      <Modal
        heading={this.props.heading}
        subheading={this.props.subheading}
        onSubmit={this.onSubmit}
        onClose={this.props.onClose}
        closeModal={this.props.closeModal}
        submitButtonLabel={this.props.submitButtonLabel}
        closeButtonLabel={this.props.closeButtonLabel}
        submitButtonEnabled={this.props.submitButtonEnabled}
        modalClassName={this.props.modalClassName}>
        {this.renderErrorText()}
        <div className='modal-with-form__form-container'>
          {this.props.children}
        </div>
      </Modal>
    );
  }
}

export default ModalForm;
