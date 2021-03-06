//
//  GoDTextureImporter.swift
//  GoD Tool
//
//  Created by The Steez on 12/09/2017.
//
//


import Cocoa


class GoDTextureImporter: NSObject {
	
	var texture  : GoDTexture!
	var newImage = NSImage()
	
	var Palette  = XGTexturePalette()
	
	// number of pixels needed to be appended for width to be multiple of 8
	var requiredPixelsPerRow = 0
	var requiredPixelsPerCol = 0
	
	init(oldTextureData: GoDTexture, newImage: NSImage) {
		super.init()
		
		self.texture  = oldTextureData
		self.newImage = newImage
		
	}
	
	private func pixelsFromPNGImage() -> [XGPNGBlock] {
		
		let imageWidth  = texture.width
		let imageHeight = texture.height
		
		requiredPixelsPerRow = (imageWidth % texture.blockWidth) == 0 ? 0 : texture.blockWidth - (imageWidth % texture.blockWidth)
		requiredPixelsPerCol = (imageHeight % texture.blockHeight) == 0 ? 0 : texture.blockHeight - (imageHeight % texture.blockHeight)
		
		let numberOfPixels = imageWidth * imageHeight
		
		let horizontalTiles = (imageWidth + requiredPixelsPerRow) / texture.blockWidth
		
		var pixels = [UInt32](repeating: 0, count: numberOfPixels)
		
		let bytesPerPixel = 4
		let bytesPerRow = bytesPerPixel * imageWidth
		let bitsPerComponent = 8
		var rect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
		
		let colourSpace = CGColorSpaceCreateDeviceRGB()
		let info = CGBitmapInfo.byteOrder32Big.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)).rawValue
		
		let context = CGContext(data: &pixels, width: imageWidth, height: imageHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colourSpace, bitmapInfo: info)!
		
		let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
		
		let imageAsCGRef = self.newImage.cgImage(forProposedRect: &rect, context: graphicsContext, hints: nil)!
		
		context.draw(imageAsCGRef, in: rect)
		
		var pngblock = [XGPNGBlock]()
		
		var totalPixelCount = numberOfPixels + (imageHeight * requiredPixelsPerRow)
		totalPixelCount += requiredPixelsPerCol * (imageWidth + requiredPixelsPerRow)
		
		for _ in 0 ..< ( totalPixelCount  / (texture.blockWidth * texture.blockHeight)) {
			pngblock.append(XGPNGBlock())
		}
		
		for i in 0 ..< numberOfPixels {
			
			var currentColour = pixels[i]
			
			let red		  = Int(currentColour % 0x100)
			
			currentColour =  currentColour >> 8
			let green	  = Int(currentColour % 0x100)
			
			currentColour =  currentColour >> 8
			let blue	  = Int(currentColour % 0x100)
			
			// alpha value is only 1 bit so anything over 0 is considered 100% opaque.
			currentColour =  currentColour >> 8
			let alpha	  = Int(currentColour)
			
			let pixelColour = XGColour(red: red, green: green, blue: blue, alpha: alpha)
			
			let pixelColumn = i % imageWidth
			
			let row		= i / (imageWidth * texture.blockHeight)
			let column  = pixelColumn / texture.blockWidth
			
			let index = (row * horizontalTiles) + column
			
			pngblock[index].append(pixelColour)
			
			// if width isn't divisible by block size, extra transparent pixels are added
			if pixelColumn == (imageWidth - 1) {
				for _ in 0 ..< requiredPixelsPerRow {
					pngblock[index].append(XGColour.none())
				}
			}
			
		}
		
		// fills bottom rows if height not divisible by block height
		for block in pngblock {
			while block.length < (texture.blockHeight * texture.blockWidth) {
				block.append(XGColour.none())
			}
		}
		
		return pngblock
	}
	
	private func convertPNGPixelsToIndexedPixels(pixels: [XGPNGBlock]) -> [XGTextureBlock] {
		
		var textureBlock = [XGTextureBlock]()
		
		for block in pixels {
			
			let tex = XGTextureBlock()
			
			for i in 0 ..< (texture.blockWidth * texture.blockHeight) {
				
				if texture.isIndexed {
					var index = Palette.indexForColour(block[i])
					if index == nil {
						
						if Palette.length < texture.paletteCount {
							Palette.append(block[i])
							index = Palette.indexForColour(block[i])
						} else {
							index = 0
						}
					}
					
					tex.append(index!)
				} else {
					tex.append(block[i].representation(format: texture.format))
				}
				
			}
			
			textureBlock.append(tex)
		}
		
		while Palette.length < texture.paletteCount {
			Palette.append(XGColour.none())
		}
		
		return textureBlock
	}
	
	private func byteStreamFromTexturePixels(pixels: [XGTextureBlock]) -> [Int] {
		
		var bytes = [Int]()
		
		for block in pixels {
			
			for i in 0 ..< block.length {
				let byte = block[i]
				bytes.append(byte)
			}
		}
		
		return bytes
	}
	
	private func byteStreamFromPNGPixels(pixels: [XGPNGBlock]) -> [Int] {
		
		var bytes = [Int]()
		
		for block in pixels {
			
			for i in 0 ..< block.length {
				
				let raw = block[i].representation(format: texture.format)
				
				if texture.BPP == 16 {
					bytes.append(raw >> 8)
					bytes.append(raw %  0x100)
				}
			}
		}
		
		return bytes
		
	}
	
	private func replaceTextureData() {
		
		let pngPixels = self.pixelsFromPNGImage()
		var pixelBytes = [Int]()
		if texture.isIndexed {
			let texPixels = self.convertPNGPixelsToIndexedPixels(pixels: pngPixels)
			pixelBytes = byteStreamFromTexturePixels(pixels: texPixels)
			self.updatePalette()
		} else {
			pixelBytes = self.byteStreamFromPNGPixels(pixels: pngPixels)
		}
		
		texture.replaceTextureData(newBytes: pixelBytes)
	}
	
	func updatePalette() {
		
		var bytes = [Int]()
		
		for i in 0 ..< texture.paletteCount  {
			
			var colour = XGColour.none()
			
			if i < Palette.length {
				colour = Palette[i]
				
				var pFormat = GoDTextureFormats.RGB5A3
				if texture.paletteFormat == 0 {
					pFormat = .IA8
				}
				if texture.paletteFormat == 1 {
					pFormat = .RGB565
				}
				
				let raw = colour.representation(format: pFormat)
				
				bytes.append(raw >> 8)
				bytes.append(raw %  0x100)
			}
			
			
		}
		
		texture.replacePaletteData(newBytes: bytes)
		
	}
	
	class func replaceTextureData(texture: GoDTexture, withImage newImageFile: XGFiles) {
		
		if !newImageFile.exists {
			return
		}
		
		let texture  = texture
		let image = newImageFile.image
		
		let importer = GoDTextureImporter(oldTextureData: texture, newImage: image)
		importer.replaceTextureData()
		
		importer.texture.save()
	}
	
	
}














