require 'socket'
require 'json'

def get
	path = "/index.html"
	request = "GET #{path} HTTP/1.0\r\n\r\n"
	send_request(request)
end

def post
	params = Hash.new { |hash, key| hash[key] = Hash.new }
	printf "Please enter your name: "
	params[:person][:name] = gets.chomp.downcase
	printf "Please enter your email: "
	params[:person][:email] = gets.chomp.downcase
	body = params.to_json
	request = "POST /thanks.html HTTP/1.0\r\nContent-Length: #{params.to_json.length}\r\n\r\n#{body}"
	send_request(request)
end

def send_request(request)
	socket = TCPSocket.open('localhost', 2000)
	socket.print(request)
	response = socket.read
	headers, body = response.split("\r\n\r\n", 2)
	print body
	socket.close
end

input = ""
while input != 'get' || input != 'post'
	printf "Which request do you want to submit (GET, POST)?: "
	input = gets.chomp.downcase
	case input
		when 'get' then get
		when 'post' then post
		else
			puts "Sorry, I don't know how to #{input}"
	end
end