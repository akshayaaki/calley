import urllib.request
import ssl
import json

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

base_url = 'https://mock-api.calleyacd.com/api'

def test_endpoint(name, url, method='GET', data=None):
    try:
        req = urllib.request.Request(
            url,
            data=json.dumps(data).encode('utf-8') if data else None,
            headers={'Content-Type': 'application/json', 'User-Agent': 'Flutter/Calley'} if data else {'User-Agent': 'Flutter/Calley'},
            method=method
        )
        res = urllib.request.urlopen(req, context=ctx, timeout=10)
        body = res.read().decode('utf-8')
        print(f"[{res.status}] {name}: {body[:250]}")
        return json.loads(body)
    except urllib.error.HTTPError as e:
        body = e.read().decode('utf-8')
        print(f"[{e.code}] {name}: {body}")
        return None
    except Exception as e:
        print(f"[ERR] {name}: {e}")
        return None

print("Testing Calley REST API Endpoints with relaxed SSL...")
login_res = test_endpoint('Login', f"{base_url}/auth/login", 'POST', {"email": "testing@yopmail.com", "password": "123"})
if login_res and 'user' in login_res:
    user_id = login_res['user']['_id']
    print(f"Logged in user_id: {user_id}")
    
    # Test get list
    list_res = test_endpoint('Get List', f"{base_url}/list?userId={user_id}", 'GET')
    if list_res and '_id' in list_res:
        list_id = list_res['_id']
        print(f"List ID: {list_id}")
        details_res = test_endpoint('Get List Details', f"{base_url}/list/{list_id}", 'GET')

test_endpoint('Send OTP', f"{base_url}/auth/send-otp", 'POST', {"email": "testing@yopmail.com"})
test_endpoint('Verify OTP', f"{base_url}/auth/verify-otp", 'POST', {"email": "testing@yopmail.com", "otp": "229166"})
