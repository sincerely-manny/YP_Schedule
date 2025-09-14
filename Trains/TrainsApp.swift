//
//  TrainsApp.swift
//  Trains
//
//  Created by Кирилл Серебрянный on 25.08.2025.
//

import SwiftUI

@main
struct TrainsApp: App {
  @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false
  var body: some Scene {
    WindowGroup {
      MainTabView().preferredColorScheme(isDarkModeEnabled ? .dark : .light)
    }
  }
}
