//
//  XGMtBattlePrizePokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 09/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kChikoritaOffset		= 0x1C5974
let kCyndaquilOffset		= 0x1C59A0
let kTotodileOffset			= 0x1C59CC

let kMtBattlePokemonLevelOffset = 0x1c878b - kDOLtoRAMOffsetDifference

let kMtBattlePokemonSpeciesOffset	=  0x02
let kMtBattlePokemonMove1Offset		=  0x06
let kMtBattlePokemonMove2Offset		=  0x0A
let kMtBattlePokemonMove3Offset		=  0x0E
let kMtBattlePokemonMove4Offset		=  0x12

class XGMtBattlePrizePokemon: NSObject, XGGiftPokemon {
	
	var index			= 0
	
	var species			= XGPokemon.pokemon(0)
	var move1			= XGMoves.move(0)
	var move2			= XGMoves.move(0)
	var move3			= XGMoves.move(0)
	var move4			= XGMoves.move(0)
	
	var giftType		= "Mt. Battle Prize"
	
	// unused
	var shinyValue		= XGShinyValues.random
	var exp				= -1
	var level			= 5 {
		didSet {
			level = 5
		}
	}
	
	var startOffset : Int {
		get {
			switch index {
				case 0 : return kChikoritaOffset
				case 1 : return kCyndaquilOffset
				default: return kTotodileOffset
			}
		}
	}
	
	init(index: Int) {
		super.init()
		
		let dol			= XGFiles.dol.data
		self.index		= index
		
		let start = startOffset
		
		let species = dol.get2BytesAtOffset(start + kMtBattlePokemonSpeciesOffset)
		self.species = .pokemon(species)
		
		var moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove1Offset)
		move1 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove2Offset)
		move2 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove3Offset)
		move3 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kMtBattlePokemonMove4Offset)
		move4 = .move(moveIndex)
		
		
	}
	
	func save() {
		
		let dol = XGFiles.dol.data
		let start = startOffset
		
		dol.replace2BytesAtOffset(start + kMtBattlePokemonSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kMtBattlePokemonMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
   
}










