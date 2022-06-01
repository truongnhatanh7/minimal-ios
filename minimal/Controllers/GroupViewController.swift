//
//  GroupViewController.swift
//  minimal
//
//  Created by Truong Nhat Anh on 31/05/2022.
//

import UIKit
import CoreData
import SwipeCellKit

class GroupViewController: UITableViewController, UITextFieldDelegate, SwipeTableViewCellDelegate {
    var groups = [Group]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var newGroupTextfield: UITextField!
    
    @IBOutlet var swipeRecognizer: UISwipeGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        tableView.separatorColor = .clear
        loadGroups()
        newGroupTextfield.delegate = self
        newGroupTextfield.placeholder = "Enter new group name"
    }
    
    //MARK: - Swipe handling
    @IBAction func swipeAdd(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            newGroupTextfield.becomeFirstResponder()
        }
    }
    
    //MARK: - Handle create new group
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let newGroup = Group(context: self.context)
        newGroup.name = textField.text
        groups.append(newGroup)
        saveGroups()
        newGroupTextfield.endEditing(true)
        newGroupTextfield.text = ""
        return true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! TableViewCell
//        let upCell = cell as UITableViewCell
        cell.taskLabel.text = groups[indexPath.row].name
        cell.delegate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.handleDeleteGroup(indexPath: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    func handleDeleteGroup(indexPath: IndexPath) {
        context.delete(groups[indexPath.row])
        groups.remove(at: indexPath.row)
        let ip = IndexPath(item: indexPath.row, section: 0)
        tableView.deleteRows(at: [ip], with: .fade)
        saveGroups()
    }
    
    func loadGroups() {
        let request: NSFetchRequest<Group> = Group.fetchRequest()
        
        do {
            groups = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func saveGroups() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
   
    //MARK: - Handle group pressed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TaskViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedGroup = groups[indexPath.row]
        }
    }
}




