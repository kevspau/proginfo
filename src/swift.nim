import std/[httpclient, htmlparser, strutils, xmltree, json]

#Gets the latest Swift version through the homepage
proc getSwiVersion(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://www.swift.org/download/")), "h3")
    var version: string
    for v in req:
        if v.attr("id") != "" and v.innerText.startsWith("Swift "):
            let str = $v
            var t = str.split(" ")
            version = t[1]
            break
    
    return version

#Gets the top "Awesome-Swift" list on GitHub
proc getSwiAwesome(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=awesome+swift")), "a")
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

#Gets the description of Swift through the GitHub topic
proc getSwiDesc(client: HttpClient): string = 
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=swift")), "p")
    var desc: string
    for v in req:
        if "Swift is a " in $v:
            desc = $(v.innerText())
            break
    return desc

proc GetSwift(client: HttpClient): string =
    let
        homepage = "https://www.swift.org"
        docs = homepage & "/documentation"
        v = getSwiVersion(client)
        d = getSwiDesc(client)
        a = getSwiAwesome(client)
    return "Swift - " & d & "\n|- Version " & v & "\n|- " & homepage & "\n|- " & docs & "\n|- " & a & "\n"