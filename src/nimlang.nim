import std/[httpclient, htmlparser, strutils, xmltree, json]

#Gets the latest Nim version through the homepage
proc getNimVersion(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://nim-lang.org/")), "a")
    var version: string
    for v in req:
        if "class=\"pure-button pure-button-primary\"" in $v:
            var s = split(innerText(v), " ")
            version = s[len(s)-1]
            break
    
    return version

#Gets the top "Awesome-Nim" list on GitHub
proc getNimAwesome(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=awesome+nim")), "a")
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

#Gets the description of Nim through the GitHub topic
proc getNimDesc(client: HttpClient): string = 
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=nim")), "p")
    var desc: string
    for v in req:
        if "Nim is a " in $v:
            desc = $(v.innerText())
            break
    return desc

proc GetNim(): string =
    let
        client = newHttpClient()
        homepage = "https://nim-lang.org"
        docs = homepage & "/documentation.html"
        v = getNimVersion(client)
        d = getNimDesc(client)
        a = getNimAwesome(client)
    client.close
    return "Nim - " & d & "\n|- Version " & v & "\n|- " & homepage & "\n|- " & docs & "\n|- " & a & "\n"