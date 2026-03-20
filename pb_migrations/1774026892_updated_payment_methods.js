/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_568792081")

  // update collection data
  unmarshal({
    "name": "PaymentMethod"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_568792081")

  // update collection data
  unmarshal({
    "name": "payment_methods"
  }, collection)

  return app.save(collection)
})
