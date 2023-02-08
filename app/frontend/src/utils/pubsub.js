export default class PubSub {
  constructor() {
    this.events = {};
  }

  /**
   * Either create a new event instance for passed `event` name
   * or push a new callback into the existing collection
   *
   * @param {string} event
   * @param {function} callback
   * @returns {function} A function to unsubscribe this callback
   * @memberof PubSub
   */
  subscribe(event, callback) {
    if (!Object.prototype.hasOwnProperty.call(this.events, event)) {
      this.events[event] = [];
    }

    // Capture the index of this callback to delete it later
    const idx = this.events[event].push(callback) - 1;

    /*
     * Provide a handler to unsubscribe
     *
     * `delete` will leave the Array intact and the deleted element will be
     * `<1 empty slot>`. These will automatically be skipped when iterating
     * with `forEach()` below
     */
    return { remove: () => delete this.events[event][idx] };
  }

  /**
   * If the passed event has callbacks attached to it, loop through each one
   * and call it
   *
   * @param {string} event
   * @param {object} [data={}]
   * @memberof PubSub
   */
  publish(event, data = {}) {
    if (!Object.prototype.hasOwnProperty.call(this.events, event)) {
      return;
    }

    this.events[event].forEach((callback) => callback(data));
  }
}
