import BaseModel from './framework/base-model';

/**
 * Models a single `User` record
 */
class User extends BaseModel {
  constructor(id) {
    super('user', id);

    // Function Bindings
    this.name = this.name.bind(this);
  }

  /**
   * Helpers
   */

  name() {
    return `${this.firstName} ${this.lastName}`;
  }
}

export default User;
