import json

with open('calley_collection.json', 'r', encoding='utf-8') as f:
    col = json.load(f)

print("Variables in collection:")
for v in col.get('variable', []):
    print(v)

print("\nAll Requests:")
for folder in col.get('item', []):
    print(f"\nFolder: {folder.get('name')}")
    for it in folder.get('item', []):
        req = it.get('request', {})
        print(f"  Name: {it.get('name')}")
        print(f"  Method: {req.get('method')}")
        print(f"  URL: {req.get('url')}")
        print(f"  Headers: {req.get('header')}")
        print(f"  Body: {req.get('body')}")
        for res in it.get('response', []):
            print(f"    Res status: {res.get('code')} {res.get('status')}")

