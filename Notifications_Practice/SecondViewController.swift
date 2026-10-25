//
//  SecondViewController.swift
//  Notifications_Practice
//
//  Created by Tahir Awan on 25/10/2026.
//

import UIKit

class SecondViewController: UIViewController {

    
    private let customNotificationName = Notification.Name("userDidTapSubmitNotification")
    
    
    private lazy var submitBtn: UIButton = {
        
        
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributeContainer()
        titleAttr.font = UIFont.systemFont(ofSize: 22, weight: .regular) // Set your desired size and weight
        config.attributedTitle = AttributedString("Submit", attributes: titleAttr)
        config.image = UIImage(systemName: "paperplane.fill")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 28, bottom: 14, trailing: 28)
        
        // Built-in glass properties on UIBackgroundConfiguration
        config.background.visualEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        //        config.background.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        config.background.strokeColor = UIColor.white.withAlphaComponent(0.4)
        config.background.strokeWidth = 1
        
        let submitButton = UIButton(configuration: config)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        
        
        
        return submitButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(submitBtn)
        NSLayoutConstraint.activate([
            submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func handleSubmit() {
        print("Submit tapped")
        let payload: [String: Any] = [
            "message": "Submission received from Second Controller! 🎉"
        ]
        
        NotificationCenter.default.post(
            name: customNotificationName,
            object: nil,
            userInfo: payload
        )
        
        // 2. Dismiss back to the first view controller
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
