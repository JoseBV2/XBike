//
//  MyProgressControllerCell.swift
//  XBike
//
//  Created by Jóse Bustamante on 12/08/22.
//

import UIKit

class MyProgressControllerCell: UITableViewCell {
    
    var distance = UILabel()
    var time = UILabel()
    var firstLocation = UILabel()
    var lastLocation = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(distance: String, time: String, fLocation: String, lLocation: String) {
        self.distance.text = distance
        self.time.text = time
        self.firstLocation.text = fLocation
        self.lastLocation.text = lLocation
    }
    
    private func setupView() {
        distance.font = distance.font.withSize(22)
        distance.textColor = .black
        self.contentView.addSubview(distance)
        time.font = time.font.withSize(28)
        time.textColor = .black
        self.contentView.addSubview(time)
        firstLocation.font = firstLocation.font.withSize(14)
        firstLocation.textColor = .black
        self.contentView.addSubview(firstLocation)
        lastLocation.font = lastLocation.font.withSize(14)
        lastLocation.textColor = .black
        self.contentView.addSubview(lastLocation)
    }
    
    func constraints() {
        distance.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        firstLocation.translatesAutoresizingMaskIntoConstraints = false
        lastLocation.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            time.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            time.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            firstLocation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            firstLocation.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 8),

            lastLocation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            lastLocation.topAnchor.constraint(equalTo: firstLocation.bottomAnchor, constant: 8),

            distance.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            distance.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}

