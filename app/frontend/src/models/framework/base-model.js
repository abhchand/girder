/**
 * @class BaseModel
 *
 * Original implementation taken from:
 * https://github.com/beauby/jsonapi-datastore/blob/master/src/jsonapi-datastore.js
 * (Original class name: `JsonApiDataStoreModel`)
 */
class BaseModel {
  /**
   * @method constructor
   * @param {string} type The type of the model.
   * @param {string} id The id of the model.
   */
  constructor(type, id) {
    this.id = id;
    this._type = type;
    this._attributes = [];
    this._relationships = [];
  }

  eq(model) {
    return model.id === this.id && model._type === this._type;
  }

  /**
   * Serialize a collection of models into a JSONAPI object
   */
  static toJsonApi(collection) {
    return {
      data: collection.map((c) => c.serialize()),
      included: null,
      links: {},
      meta: {
        totalCount: collection.length
      }
    };
  }

  /**
   * Serialize a single model into a JSONAPI object
   */
  toJsonApi() {
    return {
      data: this.serialize(),
      included: null,
      links: {},
      meta: {
        totalCount: 1
      }
    };
  }

  /**
   * Serialize a model into a JSONAPI *data* object.
   *
   * That is, this specifically represents the `data` key that would be in a
   * JSONAPI object
   *
   *  {
   *    "type": "articles",
   *    "id": "1",
   *    "attributes": {
   *      "title": "JSON:API paints my bikeshed!"
   *    }
   *  }
   *
   * @param {object} opts The options for serialization.
   *  - `attributes` The list of attributes to be serialized (default: all attributes)
   *  - `relationships` The list of relationships to be serialized (default: all relationships)
   * @return {object} JSONAPI-compliant object
   */
  serialize(opts) {
    const res = { type: this._type },
      self = this;

    // eslint-disable-next-line no-param-reassign
    opts = opts || {};
    opts.attributes = opts.attributes || this._attributes;
    opts.relationships = opts.relationships || this._relationships;

    // eslint-disable-next-line no-undefined
    if (this.id !== undefined) {
      res.id = this.id;
    }
    if (opts.attributes.length !== 0) {
      res.attributes = {};
    }
    if (opts.relationships.length !== 0) {
      res.relationships = {};
    }

    opts.attributes.forEach((key) => {
      res.attributes[key] = self[key];
    });

    opts.relationships.forEach((key) => {
      function relationshipIdentifier(model) {
        return { type: model._type, id: model.id };
      }
      if (!self[key]) {
        res.relationships[key] = { data: null };
      } else if (self[key].constructor === Array) {
        res.relationships[key] = {
          data: self[key].map(relationshipIdentifier)
        };
      } else {
        res.relationships[key] = {
          data: relationshipIdentifier(self[key])
        };
      }
    });

    return res;
  }

  /**
   * Set/add an attribute to a model.
   * @method setAttribute
   * @param {string} attrName The name of the attribute.
   * @param {object} value The value of the attribute.
   */
  setAttribute(attrName, value) {
    if (this._attributes.indexOf(attrName) === -1) {
      this._attributes.push(attrName);
    }
    this[attrName] = value;
  }

  /**
   * Set a relationships to a model.
   * @method setRelationship
   * @param {string} relName The name of the relationship.
   * @param {object} modelOrCollection The linked model(s).
   */
  setRelationship(relName, modelOrCollection) {
    if (this._relationships.indexOf(relName) === -1) {
      this._relationships.push(relName);
    }
    this[relName] = modelOrCollection;
  }

  /**
   * Add a relationships to a model.
   * @method addToRelationship
   * @param {string} relName The name of the relationship.
   * @param {object} model The linked models.
   */
  addToRelationship(relName, model) {
    const curModels = this[relName] || [];

    // Only operate on collections, not single relationships
    if (!Array.isArray(curModels)) {
      return;
    }

    /*
     * Don't add the model if it's already present
     *
     * Search by `id` since any instance of a model could
     * be specified. This doesn't protect against
     * models of a different `type`, but we expect whatever
     * calls this method to ensure that's correct
     */
    const idx = curModels.findIndex((i) => i.id === model.id);
    if (idx > -1) {
      return;
    }

    this.setRelationship(relName, curModels.concat([model]));
  }

  /**
   * Remove relationships from a model.
   * @method removeFromRelationship
   * @param {string} relName The name of the relationship.
   * @param {object} model The linked models.
   */
  removeFromRelationship(relName, model) {
    const curModels = this[relName] || [];

    // Only operate on collections, not single relationships
    if (!Array.isArray(curModels)) {
      return;
    }

    /*
     * Validate that the model exists before we remove it
     * from the relationship
     *
     * Search by `id` since any instance of a model could
     * be specified. This doesn't protect against
     * models of a different `type`, but we expect whatever
     * calls this method to ensure that's correct
     */
    const idx = curModels.findIndex((i) => i.id === model.id);
    if (idx === -1) {
      return;
    }

    curModels.splice(idx, 1);
    this.setRelationship(relName, curModels);
  }
}

export default BaseModel;
