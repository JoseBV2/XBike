//
//  MyProgressController.swift
//  XBike
//
//  Created by Jóse Bustamante on 11/08/22.
//

import UIKit

class MyProgressController: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func tableViewConfiguration() {
        tableView.register(MyProgressControllerCell.self, forCellReuseIdentifier: "MyProgressControllerCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
    }
}

extension MyProgressController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MyProgressController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UserDefault.shared.userDefaults.object(forKey: "times") as! [String]).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyProgressControllerCell", for: indexPath) as? MyProgressControllerCell else { fatalError("Can't parse") }
        let distance = UserDefault.shared.userDefaults.object(forKey: "distances") as! [String]
        let time = UserDefault.shared.userDefaults.object(forKey: "times") as! [String]
        let firstLocation = UserDefault.shared.userDefaults.object(forKey: "storeFirstLocation") as! [String]
        let lastLocation = UserDefault.shared.userDefaults.object(forKey: "storeLastLocation") as! [String]
        cell.configure(distance: distance[indexPath.row], time: time[indexPath.row], fLocation: firstLocation[indexPath.row], lLocation: lastLocation[indexPath.row])
        cell.backgroundColor = .white
        return cell
    }
}
