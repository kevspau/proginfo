import std/[httpclient, htmlparser, strutils, xmltree, json]

#Gets the latest Kotlin version through the homepage
proc getKotVersion(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://github.com/JetBrains/kotlin")), "span")
    var version: string
    for v in req:
        
        if v.attr("class") == "css-truncate css-truncate-target text-bold mr-2":
            var s = split(innerText(v), " ")
            version = s[len(s)-1]
            break
    
    return version

#Gets the top "Awesome-Kotlin" list on GitHub
proc getKotAwesome(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=awesome+kotlin")), "a")
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

#Gets the description of Kotlin through the GitHub topic
proc getKotDesc(client: HttpClient): string = 
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=kotlin")), "p")
    var desc: string
    for v in req:
        if "Kotlin is a " in $v:
            desc = $(v.innerText())
            break
    return desc

proc GetKotlin(): string =
    let
        client = newHttpClient()
        homepage = "https://kotlinlang.org"
        docs = homepage & "/docs/home.html"
        v = getKotVersion(client)
        d = getKotDesc(client)
        a = getKotAwesome(client)
    client.close
    return "Kotlin - " & d & "\n|- Version " & v & "\n|- " & homepage & "\n|- " & docs & "\n|- " & a & "\n"