//
//  XGMaps.swift
//  XG Tool
//
//  Created by StarsMmd on 01/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kStartOfMapData = 0xa7b8 // in common_rel
let kSizeOfMapEntry = 0x18

enum XGMaps : String, XGDictionaryRepresentable {
	
	case ShadowLab		= "D1"
	case MtBattle		= "D2"
	case SSLibra		= "D3"
	case RealgamTower	= "D4"
	case CipherKeyLair	= "D5"
	case CitadarkIsle	= "D6"
	case OrreColosseum	= "D7"
	case PhenacCity		= "M1"
	case PyriteTown		= "M2"
	case AgateVillage	= "M3"
	case PokemonHQ		= "M5"
	case GateonPort		= "M6"
	case OutskirtStand	= "S1"
	case SnagemHideout	= "S2"
	case KaminkosHouse	= "S3"
	case Pokespot		= "es"
	case Unknown		= "Unknown"
	
	var code : String {
		return self.rawValue
	}
	
	var name : String {
		switch self {
			
		case .ShadowLab		: return "Shadow Pokemon Lab"
		case .MtBattle		: return "Mt. Battle"
		case .SSLibra		: return "S.S. Libra"
		case .RealgamTower	: return "Realgam Tower"
		case .CipherKeyLair	: return "Cipher Key Lair"
		case .CitadarkIsle	: return "Citadark Isle"
		case .OrreColosseum	: return "Orre Colosseum"
		case .PhenacCity	: return "Phenac City"
		case .PyriteTown	: return "Pyrite Town"
		case .AgateVillage	: return "Agate Village"
		case .PokemonHQ		: return "Pokemon HQ Lab"
		case .GateonPort	: return "Gateon Port"
		case .OutskirtStand	: return "Outskirt Stand"
		case .SnagemHideout	: return "Team Snagem's Hideout"
		case .KaminkosHouse	: return "Kaminko's House"
		case .Pokespot		: return "Pokespot"
		case .Unknown		: return "Unknown"
			
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.name as AnyObject]
		}
	}
	
}


enum XGRooms {
	case room(Int)
	
	var dataStart : Int {
		return CommonIndexes.Rooms.startOffset
	}
}



