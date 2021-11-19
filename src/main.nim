from std/httpclient import newHttpClient

include nimlang, python

#   nim c -d:ssl main.nim
#   lang template: "language - description\n    source url\n    version\n    awesome list\n    homepage\n    docs\n
let client = newHttpClient()
echo "\n\n\n"
echo GetNim(client)
echo GetPython(client)
discard readLine(stdin)