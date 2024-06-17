//
//  caiApp.swift
//  cai
//
//  Created by Daniel Guarnizo on 11/04/24.
//

import FirebaseCore
import SwiftUI

@main
struct caiApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
