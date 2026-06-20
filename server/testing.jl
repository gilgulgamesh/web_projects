using HTTP

server = HTTP.serve!("127.0.0.1", 0; listenany = true) do req
    payload = "handled " * req.target
    return HTTP.Response(
        200;
        headers = ["X-Handler" => "request"],
        body = payload,
    )
end

base_url = "http://127.0.0.1:$(HTTP.port(server))"
resp = HTTP.get(base_url * "/health"; proxy = HTTP.ProxyConfig())
HTTP.forceclose(server)
(status = resp.status, header = HTTP.header(resp, "X-Handler"), body = String(resp.body))
