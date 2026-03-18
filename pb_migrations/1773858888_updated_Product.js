/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1108966215")

  // remove field
  collection.fields.removeById("text3202870680")

  // add field
  collection.fields.addAt(6, new Field({
    "hidden": false,
    "id": "file3202870680",
    "maxSelect": 1,
    "maxSize": 0,
    "mimeTypes": [],
    "name": "imagePath",
    "presentable": false,
    "protected": false,
    "required": false,
    "system": false,
    "thumbs": [],
    "type": "file"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1108966215")

  // add field
  collection.fields.addAt(6, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3202870680",
    "max": 0,
    "min": 0,
    "name": "imagePath",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // remove field
  collection.fields.removeById("file3202870680")

  return app.save(collection)
})
