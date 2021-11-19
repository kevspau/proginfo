from std/httpclient import newHttpClient

include nimlang

#   nim c -d:ssl main.nim
#   lang template: "language - description\n    source url\n    version\n    awesome list\n    homepage\n    docs\n
let client = newHttpClient()

echo ".................................................."
echo getNimVersion(client)
echo ".................................................."
echo getNimAwesome(client)
discard readLine(stdin)