//
//  TextBoxViewController.swift
//  Notifications_Practice
//
//  Created by Tahir Awan on 25/10/2026.
//

import UIKit

class TextBoxViewController: UIViewController, UITextFieldDelegate {
    
    private var centerYAnchorConstraint: NSLayoutConstraint?
    
    
    private lazy var submitBtn: UIButton = {
        
        
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributeContainer()
        titleAttr.font = UIFont.systemFont(ofSize: 22, weight: .regular) // Set your desired size and weight
        config.attributedTitle = AttributedString("Logout", attributes: titleAttr)
        //config.image = UIImage(systemName: "paperplane.fill")
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
    
    private lazy var textBox: UITextField = {
        
        let txtBox: UITextField = UITextField()
        
        txtBox.translatesAutoresizingMaskIntoConstraints = false
        txtBox.placeholder = "Type your text here..."
        txtBox.font = .systemFont(ofSize: 16)
        txtBox.textColor = .label
        txtBox.backgroundColor = .secondarySystemBackground
        txtBox.borderStyle = .roundedRect
        txtBox.clearButtonMode = .whileEditing
        txtBox.returnKeyType = .done
        txtBox.autocorrectionType = .no
        
        // Starts masked or unmasked depending on My default:
        txtBox.isSecureTextEntry = false
        
        return txtBox
    }()
    
    func setupUI(){
        textBox.delegate = self
        view.addSubview(textBox)
        
        let centerY = textBox.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        self.centerYAnchorConstraint = centerY
        
        NSLayoutConstraint.activate([
            textBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerY,
            textBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            textBox.heightAnchor.constraint(equalToConstant: 48)
            
            
        ])
        
        view.addSubview(submitBtn)
        NSLayoutConstraint.activate([
            submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitBtn.centerYAnchor.constraint(equalTo: textBox.bottomAnchor, constant: 50)
        ])
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //Subscribing to respond to Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        //Subscribing to respond to App State Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        //        ThemeManager.shared.currentTheme = .light
        
    }
    
    @objc private func handleSubmit() {
        
        SessionManager.shared.currentStatus = .loggedOut
        SessionManager.shared.logOut()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //        textField.isUserInteractionEnabled = true
        
        
        
        if textField == self.textBox{
            
            
            if let txt = textField.text{
                
                switch txt {
                    case "light", "LIGHT", "Light":
                        ThemeManager.shared.currentTheme = .light
                        
                    case "dark", "DARK", "Dark":
                        ThemeManager.shared.currentTheme = .dark
                        
                    case "system", "SYSTEM", "System":
                        ThemeManager.shared.currentTheme = .system
                        
                    default:
                        print("Unrecognized input: \(txt)")
                
                }
            }
            
            
            
            
            
            
            
        }
        
    }
    
    // Dismiss keyboard when tapping anywhere outside the text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    @objc func keyboardWillShow(notification: Notification) {
        print("Keyboard is about to show")
        
        centerYAnchorConstraint?.constant = -150
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print("Keyboard is about to hide")
        
        // Reset back to center when keyboard hides:
        centerYAnchorConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    @objc func appDidEnterBackground(notification: Notification) {
        print("App entered background")
        
        textBox.isSecureTextEntry = true
    }
    
    @objc func appDidBecomeActive(notification: Notification) {
        print("App became active")
        textBox.isSecureTextEntry = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
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
