//
//  LoginViewController.swift
//  Notifications_Practice
//
//  Created by Tahir Awan on 25/10/2026.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    private var centerYAnchorConstraint: NSLayoutConstraint?
    private lazy var emailTextBox: UITextField = {
        
        let txtBox: UITextField = UITextField()
        
        txtBox.translatesAutoresizingMaskIntoConstraints = false
        txtBox.placeholder = "Enter Email"
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
        emailTextBox.delegate = self
        view.addSubview(emailTextBox)
        
        let centerY = emailTextBox.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        self.centerYAnchorConstraint = centerY
        
        NSLayoutConstraint.activate([
            emailTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerY,
            emailTextBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextBox.heightAnchor.constraint(equalToConstant: 48)
            
            
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //        textField.isUserInteractionEnabled = true
        
        let isvalid = self.validateEmail(enteredEmail: textField.text ?? "")
        
        if isvalid{
            
            SessionManager.shared.currentStatus = .loggedIn
            if let email = textField.text{
                SessionManager.shared.logIn(email: email)
            }
                
            
        }else{
            self.emailTextBox.layer.borderColor = UIColor.systemRed.cgColor
            self.emailTextBox.layer.borderWidth = 1.5
            SessionManager.shared.currentStatus = .loggedOut
            SessionManager.shared.logOut()
            
            
        }
        
        
//        self.showToastForEmail(message: "\(isvalid ?  "Email is valid"  : "Email not valid")")
        
        
         
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
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
        
        emailTextBox.isSecureTextEntry = true
    }
    
    @objc func appDidBecomeActive(notification: Notification) {
        print("App became active")
        emailTextBox.isSecureTextEntry = false
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
