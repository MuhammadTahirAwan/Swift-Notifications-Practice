//
//  SessionManager.swift
//  Notifications_Practice
//
//  Created by Tahir Awan on 25/10/2026.
//

import Foundation


enum LoginStatus: String{
    
    case loggedIn
    case loggedOut
    
    var loginStatus: String{
        
        switch self{
            case .loggedIn: return "logged in"
            case .loggedOut: return "logged out"
        }
        
    }
}

final class SessionManager{
    
    static let shared = SessionManager()
    private let sessionKey = "login_status"
    private let emailKey = "user_email"
    
    public init() {}
    
    var currentStatus: LoginStatus{
        
        get {
            
            guard let raw = UserDefaults.standard.string(forKey: sessionKey),
                  let status = LoginStatus(rawValue: raw) else{
                
                return .loggedOut
            }
            return status
        }
        
        set{
            
            UserDefaults.standard.set(newValue.rawValue, forKey: sessionKey)
        }
    }
    
    
    
    // Explicit login action with email
    func logIn(email: String) {
        UserDefaults.standard.set(LoginStatus.loggedIn.rawValue, forKey: sessionKey)
        UserDefaults.standard.set(email, forKey: emailKey)
        print("Logged in as \(email)")
    }
    
    // Explicit logout action
    func logOut() {
        UserDefaults.standard.set(LoginStatus.loggedOut.rawValue, forKey: sessionKey)
        UserDefaults.standard.removeObject(forKey: emailKey)
        print("User logged out")
    }
}
