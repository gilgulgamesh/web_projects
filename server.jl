using Mongoose
using Dates

shutdown!(server)


function addpost!(nextpost_text::String)
   # get what's needed
   old_db_text = read("playground/database.txt", String) # generalise, learn how to files

   #time
   postdate = Dates.now()
   datestring = replace(string(postdate), r":" => s";")

   #back up
   backup_name = """playground\\database_before-""" * datestring * ".txt"
   backup_file = open(backup_name, "w")
   write(backup_file, old_db_text)
   close(backup_file)

   # splice
   new_db_file = open("database.txt", "w")
   write(new_db_file, nextpost_text * "\n\n" * old_db_text) # make elaborate
   close(new_db_file)
end

x = nothing
u() = println("yo")
# executes
router = Router()
route!(router, :post, "/", req -> begin
   addpost!(req.body)
   new_db = read("database.txt", String)
   println(req.body)
   Response(Plain, new_db)
end)

# route!(router, :get, "/", req -> begin
#    println(req)
#    Response(Plain, "ok")
# end)

config = Config(nworkers=8, request_timeout=15_000, max_body=5_242_880)

server = Async(router, config)
plug!(server, ratelimit(max_requests=10, window_seconds=30)) # Stricter limits
plug!(server, health())
start!(server; host="0.0.0.0", port=8080, blocking=false)

# definitions
s() = shutdown!(server)
si() = begin
   s()
   include("server.jl")
end
