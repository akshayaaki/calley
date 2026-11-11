import socket, ssl

hostname = 'mock-api.calleyacd.com'
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

with socket.create_connection((hostname, 443)) as sock:
    with ctx.wrap_socket(sock, server_hostname=hostname) as ssock:
        cert = ssock.getpeercert(binary_form=True)
        # also print subject from x509
        import ssl
        print("Cipher:", ssock.cipher())
        peercert = ssock.getpeercert()
        print("Peer cert:", peercert)

