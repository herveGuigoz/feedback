/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("zg6kru5caisoa39")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "bnelpfzw",
    "name": "project",
    "type": "relation",
    "required": true,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "88prl2xlpzvscup",
      "cascadeDelete": true,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("zg6kru5caisoa39")

  // remove
  collection.schema.removeField("bnelpfzw")

  return dao.saveCollection(collection)
})
