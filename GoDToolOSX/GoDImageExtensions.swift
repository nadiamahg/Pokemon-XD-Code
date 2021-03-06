//
//  XGFiles + image.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Cocoa

extension XGFiles {
	var image : NSImage {
		get {
			return NSImage(contentsOfFile: self.path)!
		}
	}
}

extension XGTrainerModels {
	var image : NSImage {
		
		return XGFiles.trainerFace(self.rawValue).image
		
	}
}

extension XGPokemon {
	var face : NSImage {
		get {
			return XGFiles.pokeFace(self.index).image
		}
	}
	
	var body : NSImage {
		get {
			return XGFiles.pokeBody(self.index).image
		}
	}
}

extension XGMoveTypes {
	var image : NSImage {
		get {
			return XGFiles.typeImage(self.rawValue).image
		}
	}
	
	static var shadowImage : NSImage {
		return XGFiles.nameAndFolder("type_shadow.png", .Types).image
	}
}

extension XGResources {
	var image : NSImage {
		get {
			return NSImage(contentsOfFile: self.path) ?? NSImage()
		}
	}
}
