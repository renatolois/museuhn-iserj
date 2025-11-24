# using this server, others devices must have problems with the 3d renderization accessing on LAN, i dont know why, but in my tests its ocurred.

import os
import ssl
from http.server import HTTPServer, SimpleHTTPRequestHandler

port = int(input())

context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
# i have used this to generate the keys: openssl req -x509 -newkey rsa:2048 -nodes -keyout /tmp/https_server_temporary_key.pem -out /tmp/https_server_temporary_cert.pem -days 365 -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
openssl_cmd = r'openssl req -x509 -newkey rsa:2048 -nodes -keyout .https_server_temporary_key.pem -out .https_server_temporary_cert.pem -days 365 -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"'
if not ( os.path.exists('.https_server_temporary_cert.pem') and os.path.exists('.https_server_temporary_key.pem') ):
    os.system(openssl_cmd)
context.load_cert_chain(certfile='./.https_server_temporary_cert.pem', keyfile='.https_server_temporary_key.pem')
context.check_hostname = False

with HTTPServer(("0.0.0.0", port), SimpleHTTPRequestHandler) as httpd:
    httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
    print(f"Servidor HTTPS iniciado em https://localhost:{port}")
    httpd.serve_forever()

