/// <reference path="../pb_data/types.d.ts" />

routerAdd("GET", "/v2/sites/:site/collections", (c) => {
    const site = c.pathParam("site")
    const authorization = c.request().header.get("Authorization")

    const res = $http.send({
        url: `https://api.webflow.com/v2/sites/${site}/collections`,
        method: "GET",
        headers: { "Accept": "application/json", "Authorization": authorization },
        timeout: 120, // in seconds
    })

    if (res.statusCode !== 200) {
        return c.json({ error: "Failed to fetch collections from Webflow" })
    }

    return c.json(200, res.json)
})

routerAdd("GET", "/v2/collections/:collection/items", (c) => {
    const collection = c.pathParam("collection")
    const authorization = c.request().header.get("Authorization")

    const res = $http.send({
        url: `https://api.webflow.com/v2/collections/${collection}/items`,
        method: "GET",
        headers: { "Accept": "application/json", "Authorization": authorization },
        timeout: 120, // in seconds
    })

    if (res.statusCode !== 200) {
        return c.json(400, { error: "Failed to fetch items from Webflow" })
    }

    return c.json(200, res.json)
})