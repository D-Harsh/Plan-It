//
//  ViewController.swift
//  PlanIt
//
//  Created by Harsh Dawda on 2021-05-14.
//

import UIKit
import RealmSwift

class ListViewController: SwipeTableViewController {
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    var taskItems: Results<Item>?
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.rowHeight = 60
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = taskItems?[indexPath.row]
        cell.textLabel!.text = item?.task
        cell.accessoryType = item?.isDone ?? false ? .checkmark : .none
        cell.backgroundColor = item?.isDone ?? false ? #colorLiteral(red: 0.607858181, green: 0.1098126695, blue: 0.1215828434, alpha: 1) : .white
        cell.textLabel?.textColor = item?.isDone ?? false ? .white : .black
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = taskItems?[indexPath.row] {
            do {
                try realm.write{
                    item.isDone = !item.isDone
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Data Management Section
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let safeTask = textField.text, let currCategory = self.selectedCategory {
                
                let newItem = Item()
                newItem.task = safeTask
                newItem.isDone = false
                newItem.dateCreated = Date()
                do {
                    try self.realm.write{
                        currCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    print("Here:\(error.localizedDescription)")
                }
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
    
    
    
    
    func loadItems(){
        //Specification of entity is required
        taskItems = selectedCategory?.items.sorted(byKeyPath: "isDone", ascending: true)
//        tableView.reloadData()
        UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let deletionItem = self.taskItems?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(deletionItem)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - Search Bar Delegate Methods

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "task CONTAINS[cd] %@", searchBar.text!)
        taskItems = taskItems?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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
