require 'socket' # Provides TCPServer and TCPSocket classes

# Initialize a TCPServer object that will listen
# on 0.0.0.0:8888 for incoming connections.
server = TCPServer.new('0.0.0.0', 8888)

# loop infinitely, processing one incoming
# connection at a time.
loop do

  # Wait until a client connects, then return a TCPSocket
  # that can be used in a similar fashion to other Ruby
  # I/O objects. (In fact, TCPSocket is a subclass of IO.)
  socket = server.accept

  # Read the first line of the request (the Request-Line)
  request = socket.gets

  # Log the request to the console for debugging
  STDERR.puts request

  response = `
  <html>
      <head>
          <link rel="stylesheet" href="https://devspace.cloud/docs/quickstart.css">
      </head>
      <body>
          <img src="https://devspace.cloud/img/congrats.gif" />
          <h1>You deployed this project with DevSpace!</h1>
          <div>
              <h2>Now it's time to start the development mode:</h2>
              <ol>
                  <li>Press CTRL+C or ENTER to terminate <code>devspace open</code></li>
                  <li>Run: <code>devspace dev</code></li>
                  <li>Edit this text in <code>index.js</code> and save the file</li>
                  <li>Check the logs to see how <code>nodemon</code> recompiles and restarts this project</li>
                  <li>Reload browser to see the changes</li>
              </ol>
          </div>
      </body>
  </html>
  `

  # We need to include the Content-Type and Content-Length headers
  # to let the client know the size and type of data
  # contained in the response. Note that HTTP is whitespace
  # sensitive, and expects each header line to end with CRLF (i.e. "\r\n")
  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"

  # Print a blank line to separate the header from the response body,
  # as required by the protocol.
  socket.print "\r\n"

  # Print the actual response body, which is just "Hello World!\n"
  socket.print response

  # Close the socket, terminating the connection
  socket.close
end