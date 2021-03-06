//
//  MasterViewController.swift
//  disclosure-indicator
//
//  Created by Thomas Durand on 11/08/2016.
//  Copyright © 2016 Thomas Durand. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    /// Will return false if no split view or if split view is collapsed like on iPhone
    var isInSplitViewPresentation: Bool {
        return !(splitViewController?.isCollapsed ?? true)
    }
    
    /// Will be called each time the size of the view controller changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // We use the coordinator to keep track of the transition
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            // In the completion of the transition,
            // We loop on each cell
            self.tableView.visibleCells.forEach {
                if let cell = $0 as? DisclosableCell {
                    // And we refresh the disclosure indicator of those cells
                    cell.setDisclosureIndicator(visible: !self.isInSplitViewPresentation)
                }
            }
        })
        
        super.viewWillTransition(to: size, with: coordinator)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: AnyObject) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        
        if let cell = cell as? DisclosableCell {
            cell.setDisclosureIndicator(visible: !isInSplitViewPresentation)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

class MyCell: UITableViewCell, DisclosableCell {
    var canDisclose: Bool {
        // All of our cells can disclose
        return true
    }
}

/// Represent a cell that is disclosable
protocol DisclosableCell {
    var canDisclose: Bool { get }
    func setDisclosureIndicator(visible: Bool)
}

extension DisclosableCell where Self: UITableViewCell {
    func setDisclosureIndicator(visible: Bool) {
        accessoryType = canDisclose && visible ? .disclosureIndicator : .none
    }
}
