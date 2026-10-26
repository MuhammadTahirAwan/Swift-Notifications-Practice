//
//  SearchViewController.swift
//  Notifications_Practice
//
//  Created by Tahir Awan on 25/10/2026.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    private var centerYAnchorConstraint: NSLayoutConstraint?
    
    
    private lazy var submitBtn: UIButton = {
        
        
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributeContainer()
        titleAttr.font = UIFont.systemFont(ofSize: 22, weight: .regular) // Set your desired size and weight
        config.attributedTitle = AttributedString("Search", attributes: titleAttr)
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
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = true
        return scroll
    }()
    
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
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
        
        
        view.addSubview(scrollView)
        
        // Add the stack view inside the scroll view
        scrollView.addSubview(buttonStackView)
        // Create and add 5 buttons to the stack
        loadRecentSearches()
        
        
        NSLayoutConstraint.activate([
            
            
            scrollView.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            scrollView.heightAnchor.constraint(equalToConstant: 44),
            
            // Stack view pinned beneath text field
            buttonStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            // 4. Lock Height to Frame (prevents vertical wobble)
            buttonStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        
    }
    
    func loadRecentSearches(){
        
        buttonStackView.arrangedSubviews.forEach { view in
            buttonStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }


        for index in 0..<SearchManager.shared.recentSearches.count {
            var config = UIButton.Configuration.filled()
            config.title = "\( SearchManager.shared.recentSearches[index])"
            config.baseBackgroundColor = .systemIndigo
            config.cornerStyle = .medium
            
            let button = UIButton(configuration: config)
            button.tag = index
            button.addTarget(self, action: #selector(stackButtonTapped(_:)), for: .touchUpInside)
            
            // Add to UIStackView arranged subviews
            buttonStackView.addArrangedSubview(button)
        }
        
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
        
    }
    
    @objc private func stackButtonTapped(_ sender: UIButton) {
        print("Button \(sender.tag) was tapped")
    }

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //        textField.isUserInteractionEnabled = true
        
        if textField == self.textBox{
            
            if let txt = textField.text{
                SearchManager.shared.recentSearches = [txt]
                loadRecentSearches()
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

