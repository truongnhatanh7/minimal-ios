//
//  TaskViewController.swift
//  minimal
//
//  Created by Truong Nhat Anh on 01/06/2022.
//

import UIKit
import SwipeCellKit
import CoreData


class TaskViewController: UITableViewController, UITextFieldDelegate, SwipeTableViewCellDelegate {
    var selectedGroup: Group?
    var tasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        super.viewDidLoad()
        taskTextField.delegate = self
        tableView.separatorColor = .clear
        loadTasks()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! TableViewCell
        cell.taskLabel.text = tasks[indexPath.row].content
        cell.delegate = self
        return cell
    }

    //MARK: - Swipe delete handling
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //self.handleDeleteGroup(indexPath: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    //MARK: - Add new task handler

    @IBOutlet weak var taskTextField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let newTask = Task(context: context)
        newTask.content = taskTextField.text!
        newTask.dayCreated = Date()
        newTask.parentGroup = selectedGroup!
        tasks.append(newTask)
        saveTasks()
        textField.endEditing(true)
        textField.text = ""
        return true
    }
    
    //MARK: - Task Handling
    func saveTasks() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
           print(error)
        }
    }
    
    func loadTasks() {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: "parentGroup.name MATCHES %@", selectedGroup!.name!)
        request.predicate = predicate
        do {
            try tasks = context.fetch(request)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }

    @IBAction func goBackSwiped(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            print("swipte")
            performSegue(withIdentifier: "goBackToGroup", sender: self)
        }
    }
}
