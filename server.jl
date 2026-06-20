using Mongoose

"""
# s() = shutdown!(server)
# i() = include("server.jl")
# si() = s();i();

# if  req.body ==
# else
#     Response(Plain, "That don't")
# end



 js transcodes everything correctly. use json with name title and content
 -- the whole html section.

minimal version
 -- just splices the htmls. i back up.
 -- ok it saves each post too, and a copy of main

 full version
  -- json or xml? html?
  -- git back up changes
  -- database

println(read(req.body, String))


   """
post = ""

router = Router()
route!(router, :post, "/", req -> begin
    global post
    post = req.body

    println(read(req.body, String))

    Response(Plain, "That works")
end)

server = Async(router) #either Server or Async
start!(server, port=8080, blocking=false) # blocking=false lets me use repl
