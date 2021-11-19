import std/[httpclient, htmlparser, strutils, xmltree, json]

#Gets the latest Python version through the homepage
proc getPyVersion(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://www.python.org/downloads/")), "a")
    var version: string
    for v in req:
        
        if "class=\"button\"" in $v and startsWith(v.innerText, "Download Python "):
            var s = split(innerText(v), " ")
            version = s[len(s)-1]
            break
    
    return version

#Gets the top "Awesome-Python" list on GitHub
proc getPyAwesome(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=awesome+python")), "a")
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

#Gets the description of Python through the GitHub topic
proc getPyDesc(client: HttpClient): string = 
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=python")), "p")
    var desc: string
    for v in req:
        if "Python is a " in $v:
            desc = $(v.innerText())
            break
    return desc

proc GetPython(client: HttpClient): string =
    let
        homepage = "https://python.org"
        docs = "https://docs.python.org/"
        v = getPyVersion(client)
        d = getPyDesc(client)
        a = getPyAwesome(client)
    return "Python - " & d & "\n|- Version " & v & "\n|- " & homepage & "\n|- " & docs & "\n|- " & a & "\n"nim