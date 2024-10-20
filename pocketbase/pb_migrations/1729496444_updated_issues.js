/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("zg6kru5caisoa39")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "ynos0lg7",
    "name": "url",
    "type": "url",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "exceptDomains": null,
      "onlyDomains": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("zg6kru5caisoa39")

  // remove
  collection.schema.removeField("ynos0lg7")

  return dao.saveCollection(collection)
})
