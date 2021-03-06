//
//  GoDCollisionViewController.swift
//  GoDToolCL
//
//  Created by The Steez on 28/05/2018.
//

import Cocoa

class GoDCollisionViewController: GoDTableViewController {
	
	
	@IBOutlet var openglView: GoDOpenGLView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.table.tableView.intercellSpacing = NSSize(width: 0, height: 1)
		self.table.reloadData()
	}
	
	var cols : [XGFiles] {
		return XGFolders.Col.files.filter({ (file) -> Bool in
			return file.fileName.contains(".col")
		}).sorted(by: { (f1, f2) -> Bool in
			return f1.fileName < f2.fileName
		})
	}
	
	override func numberOfRows(in tableView: NSTableView) -> Int {
		return cols.count == 0 ? 1 : cols.count
	}
	
	override func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: GoDTableView, didSelectRow row: Int) {
		if cols.count > 0 {
			if self.cols[row].exists {
				self.openglView.file = self.cols[row]
				self.openglView.render()
			}
			self.table.reloadData()
		} else {
			self.table.reloadData()
		}
	}
	
	override func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cell = (tableView.make(withIdentifier: "cell", owner: self) ?? GoDTableCellView(title: "", colour: GoDDesign.colourBlack(), showsImage: true, image: nil, background: nil, fontSize: 12, width: self.table.width)) as! GoDTableCellView
		
		cell.identifier = "cell"
		cell.titleField.maximumNumberOfLines = 2
		
		if cols.count == 0 {
			
			cell.setBackgroundColour(GoDDesign.colourWhite())
			cell.setTitle("No .col files found in collision data folder.\nExtract ISO and try again.")
			
			return cell
		}
		
		let str = cols[row].fileName
		let index2 = str.index(str.startIndex, offsetBy: 2)
		let prefix = str.substring(to: index2)
		
		let map = XGMaps(rawValue: prefix)
		
		if map == nil {
			cell.setBackgroundColour(GoDDesign.colourWhite())
			cell.setTitle(cols[row].fileName)
		} else {
			var colour = GoDDesign.colourWhite()
			
			switch map! {
			case .AgateVillage:
				colour = GoDDesign.colourGreen()
			case .CipherKeyLair:
				colour = GoDDesign.colourLightPurple()
			case .CitadarkIsle:
				colour = GoDDesign.colourPurple()
			case .GateonPort:
				colour = GoDDesign.colourBlue()
			case .KaminkosHouse:
				colour = GoDDesign.colourLightGrey()
			case .MtBattle:
				colour = GoDDesign.colourRed()
			case .OrreColosseum:
				colour = GoDDesign.colourBrown()
			case .OutskirtStand:
				colour = GoDDesign.colourOrange()
			case .PhenacCity:
				colour = GoDDesign.colourLightBlue()
			case .PokemonHQ:
				colour = GoDDesign.colourNavy()
			case .PyriteTown:
				colour = GoDDesign.colourRed()
			case .RealgamTower:
				colour = GoDDesign.colourLightGreen()
			case .ShadowLab:
				colour = GoDDesign.colourBabyPink()
			case .SnagemHideout:
				colour = GoDDesign.colourRed()
			case .SSLibra:
				colour = GoDDesign.colourLightOrange()
			case .Pokespot:
				colour = GoDDesign.colourYellow()
			case .Unknown:
				colour = GoDDesign.colourWhite()
			}
			
			cell.setBackgroundColour(colour)
			
			cell.setTitle(cols[row].fileName + "\n" + map!.name)
			
			if self.table.selectedRow == row {
				cell.setBackgroundColour(GoDDesign.colourOrange())
			}
		}
		
		
		return cell
	}
	
	override func keyDown(with event: NSEvent) {
		if let view = self.openglView {
			printg("pressed key:", event.keyCode)
			if let keyName = KeyCodeName(rawValue: event.keyCode) {
				if view.dictionaryOfKeys[keyName] != true {
					view.dictionaryOfKeys[keyName] = true
				}
			}
		} else { super.keyDown(with: event) }
	}
	
	override func keyUp(with event: NSEvent) {
		if let view = self.openglView {
			if let keyName = KeyCodeName(rawValue: event.keyCode) {
				view.dictionaryOfKeys[keyName] = false
			}
		} else { super.keyUp(with: event) }
	}
	
	override func mouseDragged(with event: NSEvent) {
		if let view = self.openglView {
			view.mouseEvent(deltaX: Float(event.deltaX), deltaY: Float(event.deltaY))
		}
	}
	
}

















