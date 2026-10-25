//
//  ThemeManager.swift
//  Notifications_Practice
//
//  Created by Tahir Awan on 25/10/2026.
//

import Foundation
import UIKit

enum AppTheme: String{
    
    case light
    case dark
    case system
    
    var userInterfaceStyle: UIUserInterfaceStyle{
        
        switch self{
            case .light: return UIUserInterfaceStyle.light
            case .dark: return UIUserInterfaceStyle.dark
            case .system: return UIUserInterfaceStyle.unspecified
        }
        
    }
}


final class ThemeManager{
    
    static let shared = ThemeManager()
    private let themeKey = "selected_app_theme"
    
    public init() {}
    
    var currentTheme: AppTheme{
        
        get {
            
            guard let raw = UserDefaults.standard.string(forKey: themeKey),
                  let theme = AppTheme(rawValue: raw) else{
                      
                    return .system
                  }
            return theme
        }
        
        set{
            
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            apply(theme: newValue)
        }
    }
    
    
    
    func apply(theme: AppTheme){
        
        let style = theme.userInterfaceStyle
        
        DispatchQueue.main.async{
            
            guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive}) as? UIWindowScene else{
                
                    UIApplication.shared.windows.forEach{ $0.overrideUserInterfaceStyle = style }
                    return
                    
                }
            
            windowScene.windows.forEach{
                
                $0.overrideUserInterfaceStyle = style
            }
                  
            
        }
        
    }
}
