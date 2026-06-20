using Mongoose

"""
read("neocities-pimkossible\\index.html", String)

req.body # can assig to a glloal variable

assume js transcodes everything correctly. use json with name title and content

dd
"""
content = ""

router = Router()
route!(router, :post, "/", req -> begins
    global content
    content = req.body
    if content == "I'm valid"
        Response(Plain, "That works")
    else
        Response(Plain, "That don't")
    end
end)

server = Async(router) #either Server or Async
start!(server, port=8080, blocking=false) # blocking=false lets me use repl

# s() = shutdown!(server)
# i() = include("server.jl")
# si() = s();i();
