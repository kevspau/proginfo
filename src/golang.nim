import std/[httpclient, htmlparser, strutils, xmltree, json]

#Gets the latest Go version through the homepage
proc getGoVersion(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://golang.org/dl/")), "div")
    var version: string
    for v in req:
        if v.attr("class") == "toggleVisible" and v.attr("id").startsWith("go"):
            var t = v.attr("id")
            t.removePrefix("go")
            version = t
            break
    
    return version

#Gets the top "Awesome-Go" list on GitHub
proc getGoAwesome(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=awesome+go")), "a")
    var link: string
    for l in req:
        var a = attr(l, "data-hydro-click")
        if a != "":
            let payload = parseJson(a)["payload"]
            if payload.hasKey("result"):
                let res = payload["result"]
                if res["model_name"].getStr == "Repository":
                    link = split($res["url"], "\"")[1]
                    break
    return link

#Gets the description of Go through the GitHub topic
proc getGoDesc(client: HttpClient): string = 
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=go")), "p")
    var desc: string
    for v in req:
        if "Go is a " in $v:
            desc = $(v.innerText())
            break
    return desc

proc GetGolang(): string =
    let
        client = newHttpClient()
        homepage = "https://golang.org"
        docs = homepage & "/doc"
        v = getGoVersion(client)
        d = getGoDesc(client)
        a = getGoAwesome(client)
    client.close
    return "Go - " & d & "\n|- Version " & v & "\n|- " & homepage & "\n|- " & docs & "\n|- " & a & "\n"