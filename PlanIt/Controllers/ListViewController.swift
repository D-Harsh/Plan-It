//
//  ViewController.swift
//  PlanIt
//
//  Created by Harsh Dawda on 2021-05-14.
//

import UIKit

class ListViewController: UITableViewController {
    
    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        cell.backgroundColor = item.isDone ? #colorLiteral(red: 0.607858181, green: 0.1098126695, blue: 0.1215828434, alpha: 1) : .white
        cell.textLabel?.textColor = item.isDone ? .white : .black
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        self.saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - New Items
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let safeTask = textField.text {
                
                let newItem = Item(context: self.context)
                newItem.task = safeTask
                newItem.isDone = false
                self.items.append(newItem)
                self.saveItems()
                
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
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
