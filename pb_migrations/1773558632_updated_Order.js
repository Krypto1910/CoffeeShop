/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_4289593975")

  // update collection data
  unmarshal({
    "createRule": "@request.auth.id = userID",
    "deleteRule": "@request.auth.id = userID",
    "listRule": "@request.auth.id = userID",
    "updateRule": "@request.auth.id = userID",
    "viewRule": "@request.auth.id = userID"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_4289593975")

  // update collection data
  unmarshal({
    "createRule": null,
    "deleteRule": null,
    "listRule": null,
    "updateRule": null,
    "viewRule": null
  }, collection)

  return app.save(collection)
})
