//
//  SearchManager.swift
//  Notifications_Practice
//
//  Created by Tahir Awan on 26/10/2026.
//

import Foundation

final class SearchManager{
    
    static let shared = SearchManager()
    private let search_history = "search_history"
    
    public init() {}
    
    var recentSearches: [String]{
        
        get {
            
            guard let old_searches = UserDefaults.standard.stringArray(forKey: search_history) else{
                return []
            }
            return old_searches
        }
        
        set{
            
            guard var old_searches = UserDefaults.standard.stringArray(forKey: search_history) else {
                UserDefaults.standard.set(newValue, forKey: search_history)
                return
            }
            
            if old_searches.count >= 5{
                
                old_searches.removeFirst()
                
                if let lastElement = newValue.last{
                    old_searches.append(lastElement)
                }
               
//                old_searches += newValue[0...4]
                UserDefaults.standard.set(old_searches, forKey: search_history)
                
            }else{
                
                if let lastElement = newValue.last{
                    old_searches.append(lastElement)
                }
                UserDefaults.standard.set(old_searches, forKey: search_history)
            }
        }
    }
    
    
    
    
}

