//
//  ViewController.swift
//  Notifications_Practice
//
//  Created by Tahir Awan on 25/10/2026.
//

import UIKit

class ViewController: UIViewController {
    
    private let customNotificationName = Notification.Name("userDidTapSubmitNotification")
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Waiting for notification..."
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let openButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Open Second Screen"
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .systemIndigo
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var notificationObserver: NotificationCenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        
        
        setupNotificationObserver()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        view.addSubview(statusLabel)
        view.addSubview(openButton)
        
        openButton.addTarget(self, action: #selector(openSecondScreenTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Status Label Centered
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            
            // Navigation Button below Status Label
            openButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 24),
            openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openButton.heightAnchor.constraint(equalToConstant: 44),
            openButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
    
    
    func setupNotificationObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCustomNotification(_:)), name: customNotificationName, object: nil)
    }
    
    
    
    @objc private func handleCustomNotification(_ notification: Notification) {
        
        
        let message = notification.userInfo?["message"] as? String ?? "Notification Received!"
        DispatchQueue.main.async { [weak self] in
            self?.statusLabel.text = message
        }
        
    }
    
    @objc private func openSecondScreenTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondVC = storyboard.instantiateViewController(
            withIdentifier: "SecondViewController"
        ) as? SecondViewController else {
            return
        }
        present(secondVC, animated: true)
    }
    
    // 4. Remove Observer on Deallocation
    deinit {
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

