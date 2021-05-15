//
//  ViewController.swift
//  PlanIt
//
//  Created by Harsh Dawda on 2021-05-14.
//

import UIKit

class ListViewController: UITableViewController {
    
    var items = [Item]()
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItemsFromPlist()
        
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel!.text = item.task
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        self.saveItemsToPlist()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - New Items
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let safeTask = textField.text {
                let newItem = Item()
                newItem.task = safeTask
                self.items.append(newItem)
                
                self.saveItemsToPlist()
                
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertField) in
            alertField.placeholder = "Write your task"
            textField = alertField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItemsToPlist(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: filePath!)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func getItemsFromPlist(){
        if let data = try? Data(contentsOf: filePath!) {
            let decoder = PropertyListDecoder()
            do {
            items = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("\(error.localizedDescription)")
            }
        }
        
        
    }
}
