//
//  XGFsysImporterViewController.swift
//  XG Tool
//
//  Created by The Steez on 30/07/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import UIKit

class XGFsysImporterViewController: XGViewController {
	
	var folder		= XGFolders.Documents
	
	var fsysPicker  = XGPopoverButton()
	var lzssPicker  = XGPopoverButton()
	
	var importButton = XGButton()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.setUpUI()
		
    }
	
	func setUpUI() {
		
		importButton = XGButton(title: "Import Files", colour: UIColor.blue, textColour: UIColor.white, action: {self.importFsys()})
		self.addSubview(importButton, name: "i")
		self.addConstraintAlignCenters(view1: importButton, view2: self.contentView)
		
	}
	
	override func popoverDidDismiss() {
	
	
	
	}
	
	func importFsys() {
		
		self.showActivityView { (Bool) -> Void in
			
			XGFsys.fsys(.fsys("common.fsys")).replaceFileWithIndex(0, withFile: .lzss("common_rel.lzss"))
			XGFsys.fsys(.fsys("common.fsys")).replaceFileWithIndex(2, withFile: .lzss("DeckData_DarkPokemon.lzss"))
			XGFsys.fsys(.fsys("common.fsys")).replaceFileWithIndex(4, withFile: .lzss("DeckData_DarkPokemon.lzss"))
			XGFsys.fsys(.fsys("common_dvdeth.fsys")).replaceFileWithIndex(0, withFile: .lzss("tableres2.lzss"))
			XGFsys.fsys(.fsys("deck_archive.fsys")).replaceFileWithIndex(4, withFile: .lzss("DeckData_DarkPokemon.lzss"))
			XGFsys.fsys(.fsys("deck_archive.fsys")).replaceFileWithIndex(5, withFile: .lzss("DeckData_DarkPokemon.lzss"))
			XGFsys.fsys(.fsys("deck_archive.fsys")).replaceFileWithIndex(12, withFile: .lzss("DeckData_Story.lzss"))
			XGFsys.fsys(.fsys("deck_archive.fsys")).replaceFileWithIndex(13, withFile: .lzss("DeckData_Story.lzss"))
			XGFsys.fsys(.fsys("deck_archive.fsys")).replaceFileWithIndex(14, withFile: .lzss("DeckData_Virtual.lzss"))
			XGFsys.fsys(.fsys("deck_archive.fsys")).replaceFileWithIndex(15, withFile: .lzss("DeckData_Virtual.lzss"))
			XGFsys.fsys(.fsys("field_common.fsys")).replaceFileWithIndex(8, withFile: .lzss("uv_icn_type_big_00.lzss"))
			XGFsys.fsys(.fsys("field_common.fsys")).replaceFileWithIndex(9, withFile: .lzss("uv_icn_type_small_00.lzss"))
			XGFsys.fsys(.fsys("fight_common.fsys")).replaceFileWithIndex(15, withFile: .lzss("uv_icn_type_big_00.lzss"))
			XGFsys.fsys(.fsys("fight_common.fsys")).replaceFileWithIndex(16, withFile: .lzss("uv_icn_type_small_00.lzss"))
			XGFsys.fsys(.fsys("title.fsys")).replaceFileWithIndex(12, withFile: .lzss("title_start_00.lzss"))
			
			
			self.hideActivityView()
		}
	}
	
	
	

}



















