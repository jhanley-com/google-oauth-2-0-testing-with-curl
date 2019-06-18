"""
This program implements a webserver for receiving the OAuth 2.0 code

This is a single shot web server. Only one request is processed and then the
web server exits.
"""

import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qsl

# The listening port can be anything but must be available
web_port: int = 9000

class ProcessRequests(BaseHTTPRequestHandler):
	"""
	Web server callback function to process GET, POST, etc.
	"""

	def log_message(self, format, *args):
		"""
		This function noops the log message for requests received.
		"""
		return

	def do_GET(self):
		"""
		Process the web server GET request.
		"""

		rcvd_code = None

		#
		# process the query parameters. We are looking for a "code".
		#

		# sys.stderr.write('Query: {}\n'.format(urlparse(self.path).query))

		items = parse_qsl(urlparse(self.path).query)

		for item in items:
			if 'code' in item:
				# system.stderr.write('Found item: {} = {}\n'.format(item[0], item[1]))
				sys.stdout.write(item[1])
				rcvd_code = item[1]

			if 'error' in item:
				# system.stderr.write('Found item: {} = {}\n'.format(item[0], item[1]))
				sys.stderr.write(item[1] + '\n')

		if rcvd_code is None:
			sys.stderr.write('Error: Invalid request: {}\n'.format(self.path))
			sys.stderr.write('Error: Request does not include query param "code=value"')
			self.send_response(500)
			self.send_header('Content-type', 'text/html')
			self.end_headers()
			return

		# Notice that this url is 'https' which must be specified for the redirect
		# FIX
		self.send_response(200)
		self.send_header('Content-type', 'text/html')
		self.end_headers()

		html = b"""
"<html><head><meta http-equiv='refresh' content='10;url=https://google.com'></head>
<body>Please return to the app.</body></html>")
		"""
		self.wfile.write(html)

def run_local_webserver(server_class=HTTPServer, handler_class=ProcessRequests, port=web_port):
	"""
	This function implements a web server. Once the web browser calls this server
	with a 'code', the server prints the code and exits.
	"""

	server_address = ('', port)

	try:
		httpd = server_class(server_address, handler_class)
	except:
		e_type = sys.exc_info()[0]
		e_msg = sys.exc_info()[1]
		sys.stderr.write('\n')
		sys.stderr.write('****************************************\n')
		sys.stderr.write('Error: Cannot start local web server on port {}\n'. format(web_port))
		sys.stderr.write('Error: %s\n', e_type)
		sys.stderr.write('Error: %s\n', e_msg)
		exit(1)

	# sys.stderr.write('Starting httpd...\n')

	sys.stderr.write('Listening on port {} ...\n'.format(web_port))
	httpd.handle_request()

	# All done.

if __name__ == "__main__":
	run_local_webserver()

	exit(0)
