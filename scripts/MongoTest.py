import json
import requests
import pprint
import time
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017")
database = client['PokeAPI']
collection = database['item_categories']

for item_category in collection.find():
	print('%s("%s", %s),' % (item_category['name'].replace('-', '_').upper(), item_category['name'], item_category['pocket']['name'].upper()))
