//
//  CategoryViewController.swift
//  PlanIt
//
//  Created by Harsh Dawda on 2021-05-15.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.rowHeight = 80
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Categories haven't been added yet"
        return cell
    }
    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTasks", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    // MARK: - Data Methods
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let safeCategory = textField.text {
                let newCategory = Category()
                newCategory.name = safeCategory
                self.saveItems(newCategory)
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertField) in
            alertField.placeholder = "Write your category name"
            textField = alertField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func saveItems(_ category: Category){
        //appending happens here
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func loadItems(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let deletionCategory = self.categories?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(deletionCategory)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


