//
//  SettingsViewController.swift
//  MailTask
//
//  Created by Ума Мирзоева on 08.11.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    var isImageHidden: Bool = false
    weak var delegate: SwitcherDelegate?
    
    private let imageHideSwitch = UISwitch()
    private let labelImageSwitch: UILabel = {
        let label = UILabel()
        label.text = "Скрыть изображения"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func switchTapped(){
        delegate?.switched(value: imageHideSwitch.isOn)
    }
    
    private func setupUI() {
        title = "Настройки"
        view.backgroundColor = .white
        imageHideSwitch.isOn = isImageHidden
        
        imageHideSwitch.translatesAutoresizingMaskIntoConstraints = false
        labelImageSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        imageHideSwitch.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        
        view.addSubview(imageHideSwitch)
        view.addSubview(labelImageSwitch)
        
        NSLayoutConstraint.activate([
            imageHideSwitch.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            imageHideSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            labelImageSwitch.centerYAnchor.constraint(equalTo: imageHideSwitch.centerYAnchor),
            labelImageSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelImageSwitch.trailingAnchor.constraint(equalTo: imageHideSwitch.leadingAnchor, constant: 10),
        ])
    }
    
}
