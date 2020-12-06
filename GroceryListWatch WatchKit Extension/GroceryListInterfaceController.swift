//
//  HomeInterfaceController.swift
//  GroceryListWatch WatchKit Extension
//
//  Created by fhasni on 12/5/20.
//

import WatchKit
import Foundation


class GroceryListInterfaceController: WKInterfaceController {

    @IBOutlet weak var addItemBtn: WKInterfaceButton!
    
    @IBOutlet weak var groceryTable: WKInterfaceTable!
    
    @IBOutlet weak var emptyListLabel: WKInterfaceLabel!

    private var items : [String] = []
    
    private var initialSuggestions : [String] = ["Bread", "Milk", "Eggs", "Cheese"]
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        loadTable()
    }
    
    @IBAction func addItemTapped() {
        presentTextInputController(withSuggestions: suggestions(), allowedInputMode: .plain) { [weak self] result in
            guard let result = result else { return }
            guard let newItem = result[0] as? String else { return }
            OperationQueue.main.addOperation {
                self?.addItem(newItem)
            }
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        // this methode is called when a table row is selected
        print("DEBUG: Item selected: \(items[rowIndex])")
        
        presentAlert(withTitle: nil, message: "Are you sure you want to delete \"\(items[rowIndex])\"", preferredStyle: .actionSheet, actions: [WKAlertAction(title: "Confirm", style: .destructive, handler: { [weak self] in
            self?.deleteItem(at: rowIndex)
            print("DEBUG: delete item at index: \(rowIndex)")
        })])
    }
    
    
    func loadTable() {
        
        groceryTable.setHidden(items.count == 0)
        
        emptyListLabel.setHidden(items.count > 0)
        
        if (items.count > 0 ) {
            groceryTable.setNumberOfRows(items.count, withRowType: GroceryRow.identifier)
            for (index, item) in items.enumerated() {
                let groceryRow = groceryTable.rowController(at: index) as? GroceryRow
                groceryRow?.label.setText(item)
            }
        }
        
    }
    
    func addItem(_ item: String) {
        print("DEBUG: adding item: \(item)")

        items.append(item)
        loadTable()
    }
    
    func deleteItem(at index: Int) {
        print("DEBUG: deleting item at index: \(index)")
        items.remove(at: index)
        loadTable()
    }
    
    func suggestions() -> [String] {
        return initialSuggestions.filter {
            !items.contains($0)
        }
    }
    
}
