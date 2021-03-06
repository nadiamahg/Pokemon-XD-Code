//
//  XGCharacter.swift
//  GoD Tool
//
//  Created by The Steez on 30/10/2017.
//
//

import Cocoa

let kMovementOffset = 0x1
let kCharacterAngleOffset = 0x4
let kModelOffset = 0x6
let kCharacterIDOffset = 0x8
let kHasPassiveScriptOffset = 0x10
let kPassiveScriptIndexOffset = 0x12 // script in .scd file which continuously runs (similar to hero main always running)
let kHasScriptOffset = 0x14
let kScriptIndexOffset = 0x16 // script in .scd file which runs when character is interacted with
let kXOffset = 0x18
let kYOffset = 0x1C
let kZOffset = 0x20

let kSizeOfCharacter = 0x24
class XGCharacter : NSObject {
	
	var model : XGCharacterModels!
	var movementType : XGCharacterMovements!
	var characterID = 0
	
	var nameID : Int {
		let start = CommonIndexes.PeopleIDs.startOffset + (self.characterID * 8)
		return XGFiles.common_rel.data.get4BytesAtOffset(start + 4).int
	}
	
	var name : String {
		return XGFiles.common_rel.stringTable.stringSafelyWithID(self.nameID).string
	}
	
	override var description: String {
		get {
			return "\(self.characterID) - name: \(self.name) model: \(self.model.name)\n" + "coordinates: <\(self.xCoordinate),\(self.yCoordinate),\(self.zCoordinate)> angle: \(self.angle)\n" + "script: \(self.scriptName) (\(self.scriptIndex))\n"
		}
	}
	
	var xCoordinate : Float = 0
	var yCoordinate : Float = 0
	var zCoordinate : Float = 0
	var angle = 0
	
	var hasScript = false
	var scriptIndex = 0
	var hasPassiveScript = false
	var passiveScriptIndex = 0
	var scriptName = "-"
	var characterIndex = 0
	var startOffset = 0
	
	var file : XGFiles!
	var rawData : [Int] {
		return file.data.getByteStreamFromOffset(startOffset, length: kSizeOfCharacter)
	}
	
	init(file: XGFiles, index: Int, startOffset: Int) {
		super.init()
		
		self.characterIndex = index
		self.startOffset = startOffset
		self.file = file
		
		let data = file.data
		let m = data.get2BytesAtOffset(startOffset + kModelOffset)
		self.model = XGCharacterModels(index: m)
		self.characterID = data.get2BytesAtOffset(startOffset + kCharacterIDOffset)
		self.hasScript = data.getByteAtOffset(startOffset + kHasScriptOffset) == 1
		self.scriptIndex = data.get2BytesAtOffset(startOffset + kScriptIndexOffset)
		self.hasPassiveScript = data.getByteAtOffset(startOffset + kHasPassiveScriptOffset) == 1
		self.passiveScriptIndex = data.get2BytesAtOffset(startOffset + kPassiveScriptIndexOffset)
		self.movementType = .index(data.getByteAtOffset(startOffset + kMovementOffset))
		
		self.xCoordinate = data.get4BytesAtOffset(startOffset + kXOffset).hexToSignedFloat()
		self.yCoordinate = data.get4BytesAtOffset(startOffset + kYOffset).hexToSignedFloat()
		self.zCoordinate = data.get4BytesAtOffset(startOffset + kZOffset).hexToSignedFloat()
		self.angle = data.get2BytesAtOffset(startOffset + kCharacterAngleOffset)
	}
	
	func save() {
		let data = file.data
		
		data.replace2BytesAtOffset(startOffset + kModelOffset, withBytes: self.model.index)
		data.replace2BytesAtOffset(startOffset + kCharacterIDOffset, withBytes: self.characterID)
		data.replaceByteAtOffset(startOffset + kHasScriptOffset, withByte: self.hasScript ? 1 : 0)
		data.replace2BytesAtOffset(startOffset + kPassiveScriptIndexOffset, withBytes: self.passiveScriptIndex)
		data.replaceByteAtOffset(startOffset + kHasPassiveScriptOffset, withByte: self.hasPassiveScript ? 1 : 0)
		data.replace2BytesAtOffset(startOffset + kScriptIndexOffset, withBytes: self.scriptIndex)
		data.replaceByteAtOffset(startOffset + kMovementOffset, withByte: self.movementType.index)
		
		data.replace4BytesAtOffset(startOffset + kXOffset, withBytes: self.xCoordinate.bitPattern)
		data.replace4BytesAtOffset(startOffset + kYOffset, withBytes: self.yCoordinate.bitPattern)
		data.replace4BytesAtOffset(startOffset + kZOffset, withBytes: self.zCoordinate.bitPattern)
		data.replace2BytesAtOffset(startOffset + kCharacterAngleOffset, withBytes: self.angle)
		
		data.save()
	}
}
