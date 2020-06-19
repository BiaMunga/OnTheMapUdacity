//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Henry Mungalsingh on 11/06/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let pinNewSegue = "pinFromList"
     
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapPin: UIBarButtonItem!
    
    var selectedIndex = 0
    var studentLocations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentLocations()
}

    @IBAction func pinTapped(_ sender: UIBarButtonItem) {
               
            self.performSegue(withIdentifier: self.pinNewSegue, sender: self)
          }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadStudentLocations()
    }
    
    func loadStudentLocations() {
    OnTheMapClient.getStudentLocation(completion: { (students, error) in
    StudentLocationsModel.studentLocations = students
    if let error = error {
        print(error)
        }
        else {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print(students.count)
        }
        }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationsModel.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInfoCell")!
        let students = StudentLocationsModel.studentLocations[indexPath.row]
        
        cell.textLabel?.text = students.firstName + " " + students.lastName
        cell.detailTextLabel?.text = students.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        let students = StudentLocationsModel.studentLocations[indexPath.row].mediaURL
        let url = URL(string: students)
        if url != nil {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
