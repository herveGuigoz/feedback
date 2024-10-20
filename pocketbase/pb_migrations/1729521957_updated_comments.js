/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7rst9and6zxcrje")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "dxyjauco",
    "name": "issue",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "zg6kru5caisoa39",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7rst9and6zxcrje")

  // remove
  collection.schema.removeField("dxyjauco")

  return dao.saveCollection(collection)
})
