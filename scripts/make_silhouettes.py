from PIL import Image, ImageFile, ImageOps
import os


path = 'E:\\EclipseDSL\\Pokemon\\Pokemon\\src\\main\\resources\\img\\PokeAPI\\sprites\\master\\sprites\\pokemon\\'
for file in [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f))]:
	if os.path.exists(os.path.join(path, 'silhouette', file)):
		continue
	try :
		image = Image.open(os.path.join(path, file))
		rgba_image = image.convert('RGBA')
		alpha = rgba_image.getchannel('A')
		
		inverted_alpha = ImageOps.invert(alpha)
		
		silhouette = Image.merge('LA', (inverted_alpha, alpha))
		
		silhouette.save(os.path.join(path, 'silhouette', file))
	except:
		print('Error with image: ' + file)
	