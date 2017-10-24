//
//  ViewController.swift
//  coredatademo
//
//  Created by Paige Plander on 10/23/17.
//  Copyright © 2017 Paige Plander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myNameTableView: UITableView!
    
    var dogs: [CoreDataDog] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myNameTableView.dataSource = self
        fetchNamesFromCoreData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addDog(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add name",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                let name = textField.text else {
                    return
            }
            guard let textField2 = alert.textFields?[1],
                let age = textField2.text else {
                    return
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            /// TODO: create a dog from the fields
            let newDog = CoreDataDog(context: context)
            newDog.name = name
            newDog.age = Int16(age)!
            
            appDelegate.saveContext()
            self.fetchNamesFromCoreData()
            self.myNameTableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func fetchNamesFromCoreData() {
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            dogs = try context.fetch(CoreDataDog.fetchRequest())
        }
        catch {
            print("fetched failed")
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dogCell") as? DogTableViewCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = dogs[indexPath.row].name
        cell.ageLabel.text = "Age: \(dogs[indexPath.row].age)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let dogToDelete = dogs[indexPath.row]
            context.delete(dogToDelete)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            fetchNamesFromCoreData()
            myNameTableView.reloadData()
        }
    }
}

