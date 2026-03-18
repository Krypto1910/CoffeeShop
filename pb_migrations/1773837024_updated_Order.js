/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_4289593975")

  // add field
  collection.fields.addAt(5, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_568792081",
    "hidden": false,
    "id": "relation490414719",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "paymentMethodId",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_4289593975")

  // remove field
  collection.fields.removeById("relation490414719")

  return app.save(collection)
})
