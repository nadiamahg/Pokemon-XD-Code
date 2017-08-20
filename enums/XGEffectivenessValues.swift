//
//  XGEffectivenessValues.swift
//  XG Tool
//
//  Created by The Steez on 19/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGEffectivenessValues : Int, XGDictionaryRepresentable {

	case ineffective		= 0x43
	case notVeryEffective	= 0x42
	case superEffective		= 0x41
	case missed				= 0x40
	case neutral			= 0x3F
	
	
	var string : String {
		get {
			switch self {
				case .ineffective:			return "No Effect"
				case .notVeryEffective:		return "Not Very Effective"
				case .neutral:				return "Neutral Damage"
				case .superEffective:		return "Super Effective"
				case .missed:				return "missed"
			}
		}
	}
	
	func cycle() -> XGEffectivenessValues {
		
		if self.rawValue == 0x43 {
			return XGEffectivenessValues(rawValue: 0x3F)!
		}
		
		var value = self.rawValue + 1
		
		while XGEffectivenessValues(rawValue: value) == nil { value += 1 }
		
		return XGEffectivenessValues(rawValue: value)!
		
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.string as AnyObject]
		}
	}
	
}







