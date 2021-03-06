//
//  Move.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 26/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
// 

import Foundation

let kNumberOfMoves				= 0x0177
let kSizeOfMoveData				= 0x0038
//let kFirstMoveOffset			= 0xA2710

let kPriorityOffset				= 0x00
let kPPOffset					= 0x01
let kMoveTypeOffset				= 0x02
let kTargetsOffset				= 0x03
let kAccuracyOffset				= 0x04
let kEffectAccuracyOffset		= 0x05

let kContactFlagOffset			= 0x06
let kProtectFlagOffset			= 0x07
let kMagicCoatFlagOffset		= 0x08
let kSnatchFlagOffset			= 0x09
let kMirrorMoveFlagOffset		= 0x0A
let kKingsRockFlagOffset		= 0x0B
let kSoundBasedFlagOffset		= 0x10
let kHMFlagOffset				= 0x12

let kMoveCategoryOffset			= 0x13
let kBasePowerOffset			= 0x19
let kEffectOffset				= 0x1D

let kMoveNameIDOffset			= 0x22
let kMoveDescriptionIDOffset	= 0x2E
let kAnimationIndexOffset		= 0x1E
let kAnimation2IndexOffset		= 0x32

let kMoveEffectTypeOffset		= 0x34 // used by AI

let kMoveDisplaysTypeMatchupInSummaryScreenFlagOffset = 0x15

class XGMove: NSObject, XGDictionaryRepresentable {
	
	var startOffset		= 0x0
	var moveIndex		= 0x0
	
	var nameID			= 0x0
	var descriptionID   = 0x0
	var animationID     = 0x0
	var animation2ID	= 0x0
	
	var priority		= 0x0
	var pp				= 0x0
	var effect			= 0x0
	var effectAccuracy	= 0x0
	var basePower		= 0x0
	var accuracy		= 0x0
	var type			= XGMoveTypes.normal
	var target			= XGMoveTargets.selectedTarget
	var category		= XGMoveCategories.none
	
	var effectType		= XGMoveEffectTypes.none
	
	var contactFlag		= false
	var protectFlag		= false
	var magicCoatFlag	= false
	var snatchFlag		= false
	var mirrorMoveFlag	= false
	var kingsRockFlag	= false
	var soundBasedFlag	= false
	var HMFlag			= false
	
	var displayTypeMatchupFlag = 0
	
	
	var name : XGString {
		get {
			return XGFiles.common_rel.stringTable.stringSafelyWithID(nameID)
		}
	}
	
	var mdescription : XGString {
		get {
			return XGFiles.dol.stringTable.stringSafelyWithID(descriptionID)
		}
	}
	
	var isShadowMove	: Bool {
		get {
			return XGMoves.move(self.moveIndex).isShadowMove
		}
	}
	
	init(index: Int) {
		super.init()
		
		let rel   = XGFiles.common_rel.data
//		var table = XGFiles.common_rel.stringTable
		
		self.moveIndex       = index
		self.startOffset     = CommonIndexes.Moves.startOffset + (index * kSizeOfMoveData)
		
		self.contactFlag	 = rel.getByteAtOffset(startOffset + kContactFlagOffset)    == 1
		self.protectFlag	 = rel.getByteAtOffset(startOffset + kProtectFlagOffset)    == 1
		self.magicCoatFlag	 = rel.getByteAtOffset(startOffset + kMagicCoatFlagOffset)  == 1
		self.snatchFlag		 = rel.getByteAtOffset(startOffset + kSnatchFlagOffset)	   == 1
		self.mirrorMoveFlag	 = rel.getByteAtOffset(startOffset + kMirrorMoveFlagOffset) == 1
		self.kingsRockFlag	 = rel.getByteAtOffset(startOffset + kKingsRockFlagOffset)  == 1
		self.soundBasedFlag	 = rel.getByteAtOffset(startOffset + kSoundBasedFlagOffset) == 1
		self.HMFlag			 = rel.getByteAtOffset(startOffset + kHMFlagOffset)		   == 1
		
		self.type			 = XGMoveTypes(rawValue: rel.getByteAtOffset(startOffset + kMoveTypeOffset)) ?? .normal
		self.target			 = XGMoveTargets(rawValue: rel.getByteAtOffset(startOffset + kTargetsOffset)) ?? .selectedTarget
		self.category		 = XGMoveCategories(rawValue: rel.getByteAtOffset(startOffset + kMoveCategoryOffset)) ?? .none
		
		self.effect			 = rel.getByteAtOffset(startOffset + kEffectOffset)
		self.effectAccuracy	 = rel.getByteAtOffset(startOffset + kEffectAccuracyOffset)
		self.basePower		 = rel.getByteAtOffset(startOffset + kBasePowerOffset)
		self.accuracy		 = rel.getByteAtOffset(startOffset + kAccuracyOffset)
		self.pp				 = rel.getByteAtOffset(startOffset + kPPOffset)
		
		self.nameID		   = rel.get2BytesAtOffset(startOffset + kMoveNameIDOffset)
		self.descriptionID = rel.get2BytesAtOffset(startOffset + kMoveDescriptionIDOffset)
		self.animationID   = rel.get2BytesAtOffset(startOffset + kAnimationIndexOffset)
		self.animation2ID  = rel.get2BytesAtOffset(startOffset + kAnimation2IndexOffset)
		
		self.displayTypeMatchupFlag = rel.getByteAtOffset(startOffset + kMoveDisplaysTypeMatchupInSummaryScreenFlagOffset)
		
		let p			   = rel.getByteAtOffset(startOffset + kPriorityOffset)
		self.priority	   = p > 128 ? p - 256 : p
		
		self.effectType	   = XGMoveEffectTypes(rawValue: rel.getByteAtOffset(startOffset + kMoveEffectTypeOffset)) ?? .unknown
		
	}

	func save() {
		
		let newContact	= contactFlag	 ? 1 : 0
		let newProtect	= protectFlag	 ? 1 : 0
		let newMagic	= magicCoatFlag	 ? 1 : 0
		let newSnatch	= snatchFlag	 ? 1 : 0
		let newMirror	= mirrorMoveFlag ? 1 : 0
		let newKings	= kingsRockFlag	 ? 1 : 0
		let newSound	= soundBasedFlag ? 1 : 0
		let newHM		= HMFlag		 ? 1 : 0
		
		let newTarget   = target.rawValue
		let newType		= type.rawValue
		let newCategory = category.rawValue
		
		let rel = XGFiles.common_rel.data
		
		rel.replaceByteAtOffset(startOffset + kContactFlagOffset, withByte: newContact)
		rel.replaceByteAtOffset(startOffset + kProtectFlagOffset, withByte: newProtect)
		rel.replaceByteAtOffset(startOffset + kMagicCoatFlagOffset, withByte: newMagic)
		rel.replaceByteAtOffset(startOffset + kSnatchFlagOffset, withByte: newSnatch)
		rel.replaceByteAtOffset(startOffset + kMirrorMoveFlagOffset, withByte: newMirror)
		rel.replaceByteAtOffset(startOffset + kKingsRockFlagOffset, withByte: newKings)
		rel.replaceByteAtOffset(startOffset + kSoundBasedFlagOffset, withByte: newSound)
		rel.replaceByteAtOffset(startOffset + kHMFlagOffset, withByte: newHM)
		
		rel.replaceByteAtOffset(startOffset + kTargetsOffset, withByte: newTarget)
		rel.replaceByteAtOffset(startOffset + kMoveTypeOffset, withByte: newType)
		rel.replaceByteAtOffset(startOffset + kMoveCategoryOffset, withByte: newCategory)
		
		rel.replaceByteAtOffset(startOffset + kEffectOffset, withByte: self.effect)
		rel.replaceByteAtOffset(startOffset + kBasePowerOffset, withByte: self.basePower)
		rel.replaceByteAtOffset(startOffset + kAccuracyOffset, withByte: self.accuracy)
		rel.replaceByteAtOffset(startOffset + kPPOffset, withByte: self.pp)
		rel.replaceByteAtOffset(startOffset + kEffectAccuracyOffset, withByte: self.effectAccuracy)
		rel.replaceByteAtOffset(startOffset + kPriorityOffset, withByte: self.priority < 0 ? 256 + self.priority : self.priority)
		
		rel.replace2BytesAtOffset(startOffset + kMoveNameIDOffset, withBytes: self.nameID)
		rel.replace2BytesAtOffset(startOffset + kMoveDescriptionIDOffset, withBytes: self.descriptionID)
		rel.replace2BytesAtOffset(startOffset + kAnimationIndexOffset , withBytes: self.animationID)
		rel.replace2BytesAtOffset(startOffset + kAnimation2IndexOffset, withBytes: self.animation2ID)
		
		rel.replaceByteAtOffset(startOffset + kMoveDisplaysTypeMatchupInSummaryScreenFlagOffset, withByte: self.displayTypeMatchupFlag)
		
		rel.replaceByteAtOffset(startOffset + kMoveEffectTypeOffset, withByte: self.effectType.rawValue)
		
		rel.save()
		
	}
	
	var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name.string as AnyObject?
			dictRep["description"] = self.mdescription.string as AnyObject?
			dictRep["moveAnimation"] = self.animationID as AnyObject?
			dictRep["priority"] = self.priority as AnyObject?
			dictRep["pp"] = self.pp as AnyObject?
			dictRep["effect"] = self.effect as AnyObject?
			dictRep["effectAccuracy"] = self.effectAccuracy as AnyObject?
			dictRep["basePower"] = self.basePower as AnyObject?
			dictRep["accuracy"] = self.accuracy as AnyObject?
			dictRep["contactFlag"] = self.contactFlag as AnyObject?
			dictRep["protectFlag"] = self.protectFlag as AnyObject?
			dictRep["magicCoatFlag"] = self.magicCoatFlag as AnyObject?
			dictRep["snatchFlag"] = self.snatchFlag as AnyObject?
			dictRep["mirrorMoveFlag"] = self.mirrorMoveFlag as AnyObject?
			dictRep["kingsRockFlag"] = self.kingsRockFlag as AnyObject?
			dictRep["soundBasedFlag"] = self.soundBasedFlag as AnyObject?
			dictRep["HMFlag"] = self.HMFlag as AnyObject?
			dictRep["displaysTypeMatchUpInSummaryScreenFlag"] = self.displayTypeMatchupFlag as AnyObject?
			
			dictRep["type"] = self.type.dictionaryRepresentation as AnyObject?
			dictRep["target"] = self.target.dictionaryRepresentation as AnyObject?
			dictRep["category"] = self.category.dictionaryRepresentation as AnyObject?
			
			return dictRep
		}
	}
	
	var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["description"] = self.mdescription.string as AnyObject?
			dictRep["moveAnimation"] = (XGFiles.nameAndFolder("Original Moves.json", .JSON).json as! [String])[self.animationID] as AnyObject?
			dictRep["priority"] = self.priority as AnyObject?
			dictRep["pp"] = self.pp as AnyObject?
			dictRep["effect"] = self.effect as AnyObject?
			dictRep["effectAccuracy"] = self.effectAccuracy as AnyObject?
			dictRep["basePower"] = self.basePower as AnyObject?
			dictRep["accuracy"] = self.accuracy as AnyObject?
			dictRep["contactFlag"] = self.contactFlag as AnyObject?
			dictRep["protectFlag"] = self.protectFlag as AnyObject?
			dictRep["magicCoatFlag"] = self.magicCoatFlag as AnyObject?
			dictRep["snatchFlag"] = self.snatchFlag as AnyObject?
			dictRep["mirrorMoveFlag"] = self.mirrorMoveFlag as AnyObject?
			dictRep["kingsRockFlag"] = self.kingsRockFlag as AnyObject?
			dictRep["soundBasedFlag"] = self.soundBasedFlag as AnyObject?
			dictRep["HMFlag"] = self.HMFlag as AnyObject?
			dictRep["displaysTypeMatchUpInSummaryScreenFlag"] = self.displayTypeMatchupFlag as AnyObject?
			
			dictRep["type"] = self.type.name as AnyObject?
			dictRep["target"] = self.target.string as AnyObject?
			dictRep["category"] = self.category.string as AnyObject?
			
			return ["\(self.moveIndex) " + self.name.string : dictRep as AnyObject]
		}
	}
	
	
}











