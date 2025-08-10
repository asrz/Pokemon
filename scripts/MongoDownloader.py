import json
import requests
import pprint
import time
from pymongo import MongoClient



def get_index(endpoint, page=1, pageSize=100):
	url = 'https://pokeapi.co/api/v2/' + endpoint
	params = {
		'limit': pageSize,
		'offset' : (page-1) * pageSize,
	}
	return make_query(url, params)

def get_object(endpoint, id):
	url = 'https://pokeapi.co/api/v2/' + endpoint + '/' + str(id)
	return make_query(url)
	
def make_query(url, params={}):
	print(url)
	time.sleep(1)
	
	resp = requests.get(url, params)
	if resp.status_code == 200:
		return json.loads(resp.content)
	elif resp.status_code == 404:
		print(url, params)
		return None
	else:
		print(resp)
		exit()
		
def pretty_print(obj):
	pprint.PrettyPrinter(indent=4).pprint(obj)
	
def download_objects(database, endpoint, collection_name, suffix=''):
	collection = database[collection_name]
	
	index = get_index(endpoint)
	if collection.count_documents({}) == index['count']:
		print('Skipping', collection_name)
		return
	
	skipName = False
	
	print('Downloading', index['count'], collection_name)
	while True:
		for entry in index['results']:
			if not skipName and 'name' not in entry:
				skipName = True
				collection.drop()
				
			if 'name' in entry and collection.count_documents({'name': entry['name']}) > 0:
				continue
			
			object = make_query(entry['url'])
			collection.insert_one(object)
		if index['next'] is not None:
			index = make_query(index['next'])
		else:
			return
		
	
	
	


client = MongoClient("mongodb://localhost:27017")
database = client['PokeAPI']


endpoint_collection_pairs = {
	#berries
	'berry': 'berries',
	'berry-firmness': 'berry_firmnesses',
	'berry-flavor': 'berry_flavors',
	
	#contests
	'contest-type': 'contest_types',
	'contest-effect': 'contest_effects',
	'super-contest-effect': 'super_contest_effects',
	
	#encounters
	'encounter-method': 'encounter_methods',
	'encounter-condition': 'encounter_conditions',
	'encounter-condition-value': 'encounter_condition_values',
	
	#evolutions
	'evolution-chain': 'evolution_chains',
	'evolution-trigger': 'evolution_triggers',
	
	#games
	'generation': 'generations',
	'pokedex': 'pokedexes',
	'version': 'versions',
	'version-group': 'version_groups',
	
	#items
	'item': 'items',
	'item-attribute': 'item_attributes',
	'item-category': 'item_categories',
	'item-fling-effect': 'item_fling_effects',
	'item-pocket': 'item_pockets',
	
	#locations
	'location': 'locations',
	'location-area': 'location_areas',
	'pal-park-area': 'pal_park_areas',
	'region': 'regions',
	
	#machines
	'machine': 'machines',
	
	#moves
	'move': 'moves',
	'move-ailment': 'move_ailments',
	'move-battle-style': 'move_battle_styles',
	'move-category': 'move_categories',
	'move-damage-class': 'move_damage_classes',
	'move-learn-method': 'move_learn_methods',
	'move-target': 'move_targets',

	#pokemon
	'ability': 'abilities',
	'characteristic': 'characteristics',
	'egg-group': 'egg_groups',
	'gender': 'genders',
	'growth-rate': 'growth_rates',
	'nature': 'natures',
	'pokeathlon-stat': 'pokeathlon_stats',
	'pokemon': 'pokemon',
	'pokemon-color': 'pokemon_colors',
	'pokemon-form': 'pokemon_forms',
	'pokemon-habitat': 'pokemon_habitats',
	'pokemon-shape': 'pokemon_shapes',
	'pokemon-species': 'pokemon_species',
	'stat': 'stats',
	'type': 'types'
}


#'pokemon': ('pokemon_location_area', 'encounters'

for pokemon in database['pokemon'].find():
	print(pokemon['name'])
	url = 'https://pokeapi.co/api/v2/pokemon/' + str(pokemon['id']) + '/encounters'
	result = make_query(url)
	print(len(result), 'encounters')
	if len(result) > 0:
		database['pokemon_location_areas'].insert_many(result)

#for endpoint, collection_name in endpoint_collection_pairs.items():
#	download_objects(database, endpoint, collection_name)
	


