require 'socket'
require 'json'

def launch_server
	server = TCPServer.open('localhost', 2000)

	loop {
		Thread.start(server.accept) do |client|
			request = client.read_nonblock(256)
			client.puts "Accepted"
			puts "Request: #{request}"
			header, body = request.split("\r\n\r\n", 2)
		    method = header.split[0]
		    path = header.split[1][1..-1]  #remove the forward slash

			if File.exist?(path)
				response_header = "HTTP/1.0 200 OK\r\n\r\n"
				response_body = File.read(path)
				client.puts response_header
				if method == "GET"
					client.puts response_body
				elsif method == "POST"
					params = JSON.parse(body)
					puts params
					name = params['person']['name']
					email = params['person']['email']
					user_data = "<li>name: #{params['person']['name']}</li><li>e-mail: #{params['person']['email']}</li>"
		        	client.puts response_body.gsub('<%= yield %>', user_data)
				end
			else
				client.puts "HTTP/1.0 404 Not Found\r\n\r\n"
			end

			client.puts(Time.now.ctime)
			client.puts "Closing connection"
			client.close
		end
	}
end

