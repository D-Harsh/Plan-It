//
//  ViewController.swift
//  PlanIt
//
//  Created by Harsh Dawda on 2021-05-14.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    var selectedCategory: CategoryCakes? {
        didSet {
            loadItems()
        }
    }
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
    
    // MARK: - Data Management Section
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let safeTask = textField.text {
                
                let newItem = Item(context: self.context)
                newItem.task = safeTask
                newItem.isDone = false
                newItem.parentCategory = self.selectedCategory
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
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func loadItems(from request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        //Specification of entity is required
        let catPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate ,predicate ?? catPredicate])
        
        request.predicate = compoundPredicate
        do {
            // Save entries in an item array
            items = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func delete(row: Int) {
        context.delete(items[row])
        items.remove(at: row)
        self.saveItems()
    }
    
}

// MARK: - Search Bar Delegate Methods

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "task CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [ NSSortDescriptor(key: "task", ascending: true)]
        loadItems(from: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
