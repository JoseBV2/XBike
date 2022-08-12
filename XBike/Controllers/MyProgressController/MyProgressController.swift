//
//  MyProgressController.swift
//  XBike
//
//  Created by Jóse Bustamante on 11/08/22.
//

import UIKit

class MyProgressController: UIViewController {
    
    let backgroundView = UIView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigurations()
        tableViewConfiguration()
        tableViewConstraints()
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .systemOrange, tintColor: .white, title: "My Progress", preferredLargeTitle: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func viewConfigurations() {
        backgroundView.backgroundColor = .systemOrange
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        viewConstraints()
    }
    
    func viewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func tableViewConfiguration() {
        tableView.register(MyProgressControllerCell.self, forCellReuseIdentifier: "MyProgressControllerCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        backgroundView.addSubview(tableView)
    }
    
    func tableViewConstraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:backgroundView.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
        cell.selectionStyle = .none
        return cell
    }
}
