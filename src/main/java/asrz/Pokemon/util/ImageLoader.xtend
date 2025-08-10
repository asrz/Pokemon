package asrz.Pokemon.util

import java.io.BufferedInputStream
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.net.URI
import java.nio.file.Files
import java.nio.file.Paths
import javafx.scene.image.Image
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpritesDAO

class ImageLoader {
	final static String URL_BASE = "https://raw.githubusercontent.com/"
	
	def static Image loadImage(String url) {
		return loadImage(url, false)
	}
	
	private def static Image loadImage(String url, boolean localOnly) {
		if (url === null) {
			return null
		}
		
		if (url.startsWith(URL_BASE)) {
			val srcFilepathPrefix = Util.list("src", "main", "resources", "img")
			val targetFilepathPrefix = Util.list("target", "classes", "img")
			val filepathSuffix = url.substring(URL_BASE.length).split("/")
			
			val srcFilepath = (srcFilepathPrefix + filepathSuffix).join(File.separator)
			val srcFile = new File(srcFilepath)
			if (!srcFile.exists && !localOnly) {
				try (val inputStream = new BufferedInputStream(URI.create(url).toURL.openStream)) {
					Files.copy(inputStream, Paths.get(srcFilepath))
				} catch(IOException ioe) {
					throw new RuntimeException(ioe)
				}
			}
			
			val targetFilepath = (targetFilepathPrefix + filepathSuffix).join(File.separator)
			val targetFile = new File(targetFilepath)
			if (!targetFile.exists) {
				try (val inputStream = new FileInputStream(srcFile)) {
					Files.copy(inputStream, Paths.get(targetFile.path))
				} catch(IOException ioe) {
					throw new RuntimeException(ioe)
				}
			}
			
			
			return new Image(ImageLoader.getResource("/img/" + filepathSuffix.join('/')).toString)
		}
	}
	
	def static loadSilhouetteImage(PokemonSpritesDAO spritesDao) {
		val url = spritesDao.frontDefault.replace("/sprites/pokemon/", "/sprites/pokemon/silhouette/")
		return loadImage(url, true)
	}
	
}