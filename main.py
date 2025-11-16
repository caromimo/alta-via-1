import requests
import time
import json

# getting the data through web scrapping

# we know that there are 761 refugi and will call them 100 at a time
page = [1, 2, 3, 4, 5, 6, 7, 8]

for n in page:
    time.sleep(2)
    request = requests.get(
        f"https://rifugi.cai.it/api/v1/shelters?per_page=100&page={n}"
    )
    refugi = request.json()
    for refugio in refugi["data"]:
        with open(f"./data/interim/{refugio['slug']}.json", "w") as json_file:
            json.dump(refugio, json_file, indent=2)
