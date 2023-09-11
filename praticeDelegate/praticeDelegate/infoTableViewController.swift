//
//  infoTableViewController.swift
//  praticeDelegate
//
//  Created by 서민영 on 2023/09/06.
//

import Foundation
import UIKit
import RealmSwift

class infoTableViewController: UITableViewController {
    
    @IBOutlet var tableVIew: UITableView!
    let realm = try! Realm()
    var cnt = 0
    var load:[Person] = []
    override func viewDidLoad() {
         super.viewDidLoad()
        let realm = try! Realm()
        let result = realm.objects(Person.self)
        self.load = Array(result)
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return load.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoTableViewCell", for: indexPath) as? userInfoTableViewCell
        
        cell?.userNameLabel?.text = String(load[indexPath.row].name)
        cell?.phoneNumberLabel?.text =  String(load[indexPath.row].phone)
        cell?.dateLabel.text = String(load[indexPath.row].date)
        return cell!
    }
}
