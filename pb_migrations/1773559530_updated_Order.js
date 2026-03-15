/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_4289593975")

  // update collection data
  unmarshal({
    "deleteRule": "@request.auth.id != \"\"",
    "listRule": "@request.auth.id != \"\"",
    "updateRule": "@request.auth.id != \"\"",
    "viewRule": "@request.auth.id != \"\""
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_4289593975")

  // update collection data
  unmarshal({
    "deleteRule": "@request.auth.id = userID",
    "listRule": "@request.auth.id = userID",
    "updateRule": "@request.auth.id = userID",
    "viewRule": "@request.auth.id = userID"
  }, collection)

  return app.save(collection)
})
