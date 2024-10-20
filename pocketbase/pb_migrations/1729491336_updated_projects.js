/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("88prl2xlpzvscup")

  collection.indexes = [
    "CREATE UNIQUE INDEX `idx_M0RFBoQ` ON `projects` (`url`)"
  ]

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("88prl2xlpzvscup")

  collection.indexes = []

  return dao.saveCollection(collection)
})
