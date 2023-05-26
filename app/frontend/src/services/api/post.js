/*
 * A generic POST request to a backend API
 */

import {
  registerAsyncProcess,
  unregisterAsyncProcess
} from 'utils/async-registration';

import axios from 'axios';
import { setFlash } from 'src/application/flash';

function apiPost(e, successMsg = null, resetOnSuccess = false) {
  e.preventDefault();

  const form = e.target;

  const url = form.action;
  const data = new FormData(form);
  const config = {
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json'
    }
  };

  /*
   * Not all endpoints parse format as JSON by default, so specify it
   * explicitly
   */
  data.append('format', 'json');

  registerAsyncProcess('api-post-request');

  return axios
    .post(url, data, config)
    .then((_response) => {
      unregisterAsyncProcess('api-post-request');
      setFlash('notice', successMsg || 'Success');
      // eslint-disable-next-line no-unused-expressions
      resetOnSuccess && form.reset();
    })
    .catch((error) => {
      unregisterAsyncProcess('api-post-request');
      /*
       * It is up to the server to ensure it returns an error object that
       * conforms to this expected structure (e.g. via
       * `ApplicationRecord#serialize_errors`)
       */
      setFlash('error', error.response.data.errors[0].description);
    });
}

export { apiPost };
