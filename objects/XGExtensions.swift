//
//  XGExtensions.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 04/03/2017.
//  Copyright © 2017 StarsMmd. All rights reserved.
//

import Foundation


extension Sequence where Iterator.Element == Int {
	var byteString : String {
		var s = ""
		for i in self {
			s += String(format: "%02x ", i)
		}
		return s
	}
	
	var hexStream : String {
		var s = ""
		for i in self {
			s += String(format: "%02x ", i)
		}
		return s
	}
}

extension Array where Element == Int {
	
	mutating func addUnique(_ new: Int) {
		if !self.contains(new) {
			self.append(new)
		}
	}
	
}

extension Array where Element == String {
	
	mutating func addUnique(_ new: String) {
		if !self.contains(new) {
			self.append(new)
		}
	}
	
}


extension NSObject {
	func println() {
		printg(self)
	}
}

extension String {
	
	func println() {
		printg(self)
	}
	
	func spaceToLength(_ length: Int) -> String {
		
		var spaces = ""
		let wordLength = self.characters.count
		for i in 1 ... length {
			if i > wordLength {
				spaces += " "
			}
		}
		
		return self + spaces
	}
	
	func spaceLeftToLength(_ length: Int) -> String {
		
		var spaces = ""
		let wordLength = self.characters.count
		for i in 1 ... length {
			if i > wordLength {
				spaces += " "
			}
		}
		
		return spaces + self
	}
	
	func removeFileExtensions() -> String {
		let extensionIndex = self.characters.index(of: ".") ?? self.endIndex
		
		return self.substring(to: extensionIndex)
	}
	
	var fileExtensions : String {
		let extensionIndex = self.characters.index(of: ".") ?? self.endIndex
		
		return self.substring(from: extensionIndex)
	}
	
	var cppEnum : String {
		// convention used in PkmGCTools by Tux
		return self.replacingOccurrences(of: "-", with: " ").capitalized.replacingOccurrences(of: " ", with: "")
		
	}
}

extension Bool {
	var string : String {
		return self ? "Yes" : "No"
	}
}

extension Int {
	
	var boolean : Bool {
		return self != 0
	}
	
	var string : String {
		return String(self)
	}
	
	func println() {
		printg(self)
	}
	
	func hex() -> String {
		return String(format: "%x", self).uppercased()
	}
	
	func hexString() -> String {
		return "0x" + hex()
	}
	
	var byteArray : [Int] {
		var val = self
		var array = [0,0,0,0]
		for j in [3,2,1,0] {
			array[j] = Int(val % 0x100)
			val = val >> 8
		}
		return array
	}
	
	var charArray : [UInt8] {
		return byteArray.map({ (i) -> UInt8 in
			return UInt8(i)
		})
	}
	
}

extension UInt32 {
	
	func println() {
		printg(self)
	}
	
	func hexToSignedFloat() -> Float {
		var toInt = Int32(bitPattern: self)
		var float : Float32 = 0
		memcpy(&float, &toInt, MemoryLayout.size(ofValue: float))
		return float
	}
	
	var byteArray : [Int] {
		var val = self
		var array = [0,0,0,0]
		for j in [3,2,1,0] {
			array[j] = Int(val % 0x100)
			val = val >> 8
		}
		return array
	}
	
	var charArray : [UInt8] {
		return byteArray.map({ (i) -> UInt8 in
			return UInt8(i)
		})
	}
	
	var int : Int {
		return Int(self)
	}
	
	var int16 : Int {
		var value = (self & 0xFFFF).int
		value = value > 0x8000 ? value - 0x10000 : value
		return value
	}
	
	var int32 : Int {
		var value = (self & 0xFFFFFFFF).int
		value = value > 0x80000000 ? value - 0x100000000 : value
		return value
	}
	
	func hex() -> String {
		return String(format: "%08x", self).uppercased()
	}
	
	func hexString() -> String {
		return "0x" + hex()
	}
	
}

extension Float {
	
	func println() {
		printg(self)
	}
	
	var string : String {
		return String(describing: self)
	}
	
	func raisedToPower(_ pow: Int) -> Float {
		var result : Float = 1.0
		for _ in 0 ..< pow {
			result *= self
		}
		return result
	}
	
}

extension String {
	var simplified : String {
		get {
			var s = self.replacingOccurrences(of: " ", with: "")
			s = s.replacingOccurrences(of: "-", with: "")
			s = s.replacingOccurrences(of: "é", with: "e")
			return s.lowercased()
		}
	}
	
	var length : Int {
		return self.characters.count
	}
	
	func substring(from: Int, to: Int) -> String {
		
		if to <= from {
			return ""
		}
		if from > self.characters.count {
			return ""
		}
		if to <= 0 {
			return ""
		}
		
		let f = from < 0 ? 0 : from
		let t = to > self.characters.count ? self.characters.count : to
		
		let start = self.characters.index(self.startIndex, offsetBy: f)
		let subStart = self.substring(from: start)
		return subStart.substring(to: self.characters.index(self.startIndex, offsetBy: t - f))
		
	}
}




