/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("zg6kru5caisoa39")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "opv4imsy",
    "name": "agent",
    "type": "text",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("zg6kru5caisoa39")

  // remove
  collection.schema.removeField("opv4imsy")

  return dao.saveCollection(collection)
})
