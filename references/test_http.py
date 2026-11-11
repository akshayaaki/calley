import urllib.request
import json

urls = [
    'http://mock-api.calleyacd.com/api/auth/login',
    'https://mock-api.calleyacd.com/api/auth/login',
    'http://mock-api.calleyacd.com/',
    'https://mock-api.calleyacd.com/'
]

for u in urls:
    try:
        req = urllib.request.Request(
            u,
            data=json.dumps({"email": "testing@yopmail.com", "password": "123"}).encode('utf-8'),
            headers={'Content-Type': 'application/json'},
            method='POST'
        )
        res = urllib.request.urlopen(req, timeout=5)
        print("Success:", u, res.status, res.read().decode('utf-8'))
    except Exception as e:
        print("Err:", u, e)

