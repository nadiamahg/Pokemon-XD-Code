//
//  XGItem.swift
//  XG Tool
//
//  Created by StarsMmd on 31/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

//let kNumberOfItems				= 0x1BC
//let kFirstItemOffset			= 0x1FEE4
let kSizeOfItemData				= 0x28
let kNumberOfFriendshipEffects	= 0x03

let kBagSlotOffset				 = 0x00
let kItemCantBeHeldOffset		 = 0x01 // also can't be thrown away?
let kInBattleUseItemIDOffset	 = 0x04 // Items that can be used on your pokemon in battle
let kItemPriceOffset			 = 0x06
let kItemCouponCostOffset		 = 0x08
let kItemBattleHoldItemIDOffset  = 0x0B
let kItemNameIDOffset			 = 0x12
let kItemDescriptionIDOffset	 = 0x16
let kItemParameterOffset		 = 0x1B
let kFirstFriendshipEffectOffset = 0x24 // Signed Int

let kItemFunctionInRAMPointerOffset = 0x20 // value is only filled in RAM at runtime and is empty in common_rel

class XGItem: NSObject, XGDictionaryRepresentable {

	var startOffset : Int {
		get{
			return CommonIndexes.Items.startOffset + (index * kSizeOfItemData)
		}
	}
	
	var index				= 0x0
	
	var bagSlot				= XGBagSlots.items
	var inBattleUseID		= 0x0
	var price				= 0x0
	var couponPrice			= 0x0
	var holdItemID			= 0x0
	var nameID				= 0x0
	var descriptionID		= 0x0
	var parameter			= 0x0
	var friendshipEffects	= [Int](repeating: 0x0, count: kNumberOfFriendshipEffects)
	var canBeHeld = false
	
	var name : XGString {
		get {
			return XGItems.item(index).name
		}
	}
	
	var descriptionString : XGString {
		get {
			return XGItems.item(index).descriptionString
		}
	}
	
	
	init(index: Int) {
		super.init()
		
		self.index = index
		
		let start = startOffset
		let data  = XGFiles.common_rel.data
		
		let bSlot			= data.getByteAtOffset(start + kBagSlotOffset)
		bagSlot				= XGBagSlots(rawValue: bSlot) ?? XGBagSlots.items
		inBattleUseID		= data.getByteAtOffset(start + kInBattleUseItemIDOffset)
		price				= data.get2BytesAtOffset(start + kItemPriceOffset)
		couponPrice			= data.get2BytesAtOffset(start + kItemCouponCostOffset)
		holdItemID			= data.getByteAtOffset(start + kItemBattleHoldItemIDOffset)
		nameID				= data.get2BytesAtOffset(start + kItemNameIDOffset)
		descriptionID		= data.get2BytesAtOffset(start + kItemDescriptionIDOffset)
		parameter			= data.getByteAtOffset(start + kItemParameterOffset)
		canBeHeld			= data.getByteAtOffset(start + kItemCantBeHeldOffset) == 0
		friendshipEffects	= data.getByteStreamFromOffset(start + kFirstFriendshipEffectOffset, length: kNumberOfFriendshipEffects)
		
		
	}
	
	func save() {
		
		let data = XGFiles.common_rel.data
		let start = self.startOffset
		
		data.replaceByteAtOffset(start + kBagSlotOffset, withByte: bagSlot.rawValue)
		data.replaceByteAtOffset(start + kInBattleUseItemIDOffset, withByte: inBattleUseID)
		data.replace2BytesAtOffset(start + kItemPriceOffset, withBytes: price)
		data.replace2BytesAtOffset(start + kItemCouponCostOffset, withBytes: couponPrice)
		data.replaceByteAtOffset(start + kItemBattleHoldItemIDOffset, withByte: holdItemID)
		data.replace2BytesAtOffset(start + kItemNameIDOffset, withBytes: nameID)
		data.replace2BytesAtOffset(start + kItemDescriptionIDOffset, withBytes: descriptionID)
		data.replaceByteAtOffset(start + kItemParameterOffset, withByte: parameter)
		data.replaceByteAtOffset(start + kItemCantBeHeldOffset, withByte: canBeHeld ? 0 : 1)
		data.replaceBytesFromOffset(start + kFirstFriendshipEffectOffset, withByteStream: friendshipEffects)
		
		data.save()
		
	}
	
	
	var dictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["name"] = self.name.string as AnyObject?
			dictRep["description"] = self.descriptionString.string as AnyObject?
			dictRep["inBattleUseID"] = self.inBattleUseID as AnyObject?
			dictRep["price"] = self.price as AnyObject?
			dictRep["couponPrice"] = self.couponPrice as AnyObject?
			dictRep["holdItemID"] = self.holdItemID as AnyObject?
			dictRep["parameter"] = self.parameter as AnyObject?
			dictRep["canBeHeld"] = self.canBeHeld as AnyObject?
			
			dictRep["bagSlot"] = self.bagSlot.dictionaryRepresentation as AnyObject?
			
			var friendshipEffectsArray = [AnyObject]()
			for a in friendshipEffects {
				friendshipEffectsArray.append(a as AnyObject)
			}
			dictRep["friendshipEffects"] = friendshipEffectsArray as AnyObject?
			
			return dictRep
		}
	}
	
	var readableDictionaryRepresentation : [String : AnyObject] {
		get {
			var dictRep = [String : AnyObject]()
			dictRep["description"] = self.descriptionString.string as AnyObject?
			dictRep["inBattleUseID"] = self.inBattleUseID as AnyObject?
			dictRep["price"] = self.price as AnyObject?
			dictRep["couponPrice"] = self.couponPrice as AnyObject?
			dictRep["holdItemID"] = self.holdItemID as AnyObject?
			dictRep["parameter"] = self.parameter as AnyObject?
			dictRep["canBeHeld"] = self.canBeHeld as AnyObject?
			
			dictRep["bagSlot"] = self.bagSlot.name as AnyObject?
			
			dictRep["friendshipEffects"] = friendshipEffects as AnyObject?
			
			return ["\(self.index) " + self.name.string : dictRep as AnyObject]
		}
	}
	
}

















