//
//  XGStringManager.swift
//  GoD Tool
//
//  Created by StarsMmd on 20/08/2017.
//
//

import Foundation

var allStrings = [XGString]()
var stringsLoaded = false

func loadAllStrings() {
	
	if !stringsLoaded {
		
		allStrings += XGFiles.common_rel.stringTable.allStrings()
		allStrings += XGFiles.dol.stringTable.allStrings()
		allStrings += XGFiles.tableres2.stringTable.allStrings()
		
		XGFolders.StringTables.map{ (file: XGFiles) -> Void in
			if file.fileName.contains(".msg") {
				allStrings += file.stringTable.allStrings()
			}
		}
		
		stringsLoaded = true
	}
	
}

func getStringWithID(id: Int) -> XGString? {
	loadAllStrings()
	
	for str in allStrings {
		if str.id == id {
			return str
		}
	}
	return nil
}

func getStringSafelyWithID(id: Int) -> XGString {
	loadAllStrings()
	
	if id == 0 {
		return XGString(string: "-", file: nil, sid: nil)
	}
	
	for str in allStrings {
		if str.id == id {
			return str
		}
	}
	return XGString(string: "-", file: nil, sid: nil)
}

func getStringsContaining(substring: String) -> [XGString] {
	loadAllStrings()
	
	var found = [XGString]()
	for str in allStrings where str.containsSubstring(substring) {
		found.append(str)
	}
	return found
}



