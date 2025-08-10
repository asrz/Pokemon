import time
import os
import requests
from pymongo import MongoClient

def get_image(url, filepath):
	print(filepath)
	if (os.path.exists(filepath)):
		print('exists')
		return 
	print('downloading')
	time.sleep(0.1)
	resp = requests.get(url, stream=True)
	if resp.status_code == 200:	
		with open(filepath, 'wb') as f:
			for chunk in resp:
				f.write(chunk)
				
client = MongoClient("mongodb://localhost:27017")
database = client['PokeAPI']
collection = database['pokemon']

#https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/2.png
#E:\EclipseDSL\Pokemon\Pokemon\src\main\resources\img\PokeAPI\sprites\master\sprites\pokemon
for pokemon in collection.find():
	url = pokemon['sprites']['front_default']
	filepath = url.replace('https://raw.githubusercontent.com', '../src/main/resources/img')

	get_image(url, filepath)