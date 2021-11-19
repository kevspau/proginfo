import std/[httpclient, htmlparser, strutils, xmltree]

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

#Gets the top "Awesome-Nim" on GitHub
proc getNimAwesome(client: HttpClient): string =
    var req = findAll(parseHtml(client.getContent("https://github.com/search?q=awesome+nim")), "a")
    var link: string
    for l in req:
        if "class=\"v-align-middle\"" in $l:
            echo l.attr("href")
            link = "https://github.com" & l.attr("href")
            break
    return link

