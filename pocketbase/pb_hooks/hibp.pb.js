/// <reference path="../pb_data/types.d.ts" />

routerAdd("GET", "/api/v3/breachedaccount/:email", (c) => {
    const email = c.pathParam("email")
    const authorization = c.request().header.get("hibp-api-key")

    const res = $http.send({
        url: `https://haveibeenpwned.com/api/v3/breachedaccount/${email}?truncateResponse=false`,
        method: "GET",
        headers: { "Accept": "application/json", "hibp-api-key": authorization },
        timeout: 120, // in seconds
    })

    if (res.statusCode !== 200) {
        return c.json({ error: "Failed to fetch breached accounts from haveibeenpwned" })
    }

    return c.json(200, res.json)
})