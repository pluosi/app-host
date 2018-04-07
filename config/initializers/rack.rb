#fix issues,large pkg file upload slow
#https://github.com/rack/rack/issues/1075
Rack::Multipart::Parser.const_set('BUFSIZE', 10_000_000)
