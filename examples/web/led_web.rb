# Wi-Fi connection
wifi = WiFi.new
wifi.on_connected    { |ip| puts "Wi-Fi connected with IP: #{ip}" }
wifi.on_disconnected {      puts "Wi-Fi disconnected" }
wifi.connect('SSID', 'password')

# Set up the on-board LED (or other hardware).
LED_PIN = 4
board   = Denko::Board.new
led     = Denko::LED.new(board: board, pin: LED_PIN)

# Set up the TCP sever.
PORT   = 8080
server = TCPServer.new('0.0.0.0', PORT)
puts "Server is running on http://0.0.0.0:#{PORT}"

# Helpers to load templates, and render responses.
def render_template(file_path, led_state)
  template = File.read(file_path)
  template.gsub('{{LED_STATE}}', led_state.to_s)
end

def render_json_200(led_state)
  content = render_template('/storage/led.json', led_state)

  <<~RESPONSE
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    \r
    #{content}
  RESPONSE
end

def render_html_200(led_state)
  content = render_template('/storage/led.html', led_state)

  <<~HTML
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    \r
    #{content}
  HTML
end

loop do
  client  = server.accept
  request = client.gets

  puts "Received request: #{request}"
  path_and_query = request.split(" ")[1]

  if path_and_query.start_with?("/led")
    # Updating LED state. Find "state" parameter.
    if path_and_query.include?("?")
      query_string = path_and_query.split("?")[1]
      query_params = query_string.split("&").map { |param| param.split("=") }.to_h
      new_state = query_params["state"]
    else
      new_state = nil
    end

    # Change the state of the actual LED.
    if new_state
      new_state == "0" ? led.off : led.on
    end

    # JSON response
    response = render_json_200(led.state)
    client.syswrite(response)
  elsif path_and_query == "/"
    # Default page. HTML response.
    response = render_html_200(led.state)
    client.syswrite(response)
  end

  client.close
end
