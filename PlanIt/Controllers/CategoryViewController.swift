//
//  CategoryViewController.swift
//  PlanIt
//
//  Created by Harsh Dawda on 2021-05-15.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [CategoryCakes]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel!.text = category.name
        return cell
    }
    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTasks", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    // MARK: - Data Methods
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let safeCategory = textField.text {
                let newCategory = CategoryCakes(context: self.context)
                newCategory.name = safeCategory
                self.categories.append(newCategory)
                self.saveItems()
                
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
    

    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func loadItems(from request: NSFetchRequest<CategoryCakes> = CategoryCakes.fetchRequest()){
        //Specification of entity is required
        do {
            // Save entries in an item array
            categories = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func delete(row: Int) {
        context.delete(categories[row])
        categories.remove(at: row)
        self.saveItems()
    }
}
