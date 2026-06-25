using Mongoose
using Dates
include("parser.jl")

getdate() =  replace(string(Dates.now()), "T" => " at ")


restarted = false

if @isdefined(server)
    shutdown!(server)
    restarted = true
    close(LOG)
end

const LOG = open("output.txt", "a")

if restarted
    println("\nRebooted on $(getdate())")
    write(LOG, "\nRebooted on $(getdate())")
else
    println("\nTurned on $(getdate())")
    write(LOG, "\nTurned on $(getdate())")
end


function wraplog!(req)
   a = "\n   $(req.method) -> $(req.uri)"
   b = "\n   ------"
   c = "\n   === $(string(req.body))"
   d = "\n   ------"
   e = "\n   $(string(req))"
   f = "\n   $(getdate()) \n   "

   out = *(a, b, c, d, e, f)
   write(LOG, out)

   print(out)
   Response(Plain, "404 Not Found"; status=404)
end






# # executes
router = Router()

route!(router, :post, "/", req-> begin
    wraplog!(req)

    if match(r"&Title=(.+)&User=(.+)&Content=(.+)", req.body) === nothing
        return Response(Plain, "Bad HTTP formatting"; status=400)
    end

    addpost!(req.body)

end)





function logall()
    route!(router, :get, "/", req -> wraplog!(req))
    route!(router, :put, "/", req -> wraplog!(req))
    route!(router, :delete, "/", req -> wraplog!(req))
    route!(router, :patch, "/", req -> wraplog!(req))
    route!(router, :head, "/", req -> wraplog!(req))
    route!(router, :options, "/", req -> wraplog!(req))
    route!(router, :get, "*", req -> wraplog!(req))
    route!(router, :put, "*", req -> wraplog!(req))
    route!(router, :patch, "*", req -> wraplog!(req))
    route!(router, :delete, "*", req -> wraplog!(req))
    route!(router, :head, "*", req -> wraplog!(req))
    route!(router, :options, "*", req -> wraplog!(req))
    route!(router, :post, "*", req -> wraplog!(req))
end

logall()

config = Config(max_body=5_242_880)
server = Server(router, config)

plug!(server, ratelimit(max_requests=10, window_seconds=30))
plug!(server, logger(output=LOG))
plug!(server, logger())
start!(server; host="0.0.0.0", port=8080, blocking=false)
