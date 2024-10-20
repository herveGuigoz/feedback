/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("zg6kru5caisoa39")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "l4snahyk",
    "name": "screenshot",
    "type": "file",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "mimeTypes": [
        "image/png",
        "image/jpeg"
      ],
      "thumbs": [],
      "maxSelect": 1,
      "maxSize": 5242880,
      "protected": false
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("zg6kru5caisoa39")

  // remove
  collection.schema.removeField("l4snahyk")

  return dao.saveCollection(collection)
})
