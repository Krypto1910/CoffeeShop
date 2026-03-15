/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_4289593975")

  // update field
  collection.fields.addAt(5, new Field({
    "hidden": false,
    "id": "select2223302008",
    "maxSelect": 2,
    "name": "paymentMethod",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "select",
    "values": [
      "cash",
      "card",
      "ewallet"
    ]
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_4289593975")

  // update field
  collection.fields.addAt(5, new Field({
    "hidden": false,
    "id": "select2223302008",
    "maxSelect": 2,
    "name": "paymentMethod",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "select",
    "values": [
      "Cash",
      "Credit / Debit card",
      "E-wallet"
    ]
  }))

  return app.save(collection)
})
