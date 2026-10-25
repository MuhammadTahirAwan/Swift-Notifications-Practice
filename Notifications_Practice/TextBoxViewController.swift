//
//  TextBoxViewController.swift
//  Notifications_Practice
//
//  Created by Tahir Awan on 25/10/2026.
//

import UIKit

class TextBoxViewController: UIViewController, UITextFieldDelegate {
    
    private var centerYAnchorConstraint: NSLayoutConstraint?
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
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
