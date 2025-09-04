import SwiftUI

enum TabItem: String, CaseIterable, Identifiable {
  case schedule = "Schedule"
  case settings = "Settings"

  var id: String { rawValue }

  @ViewBuilder
  var view: some View {
    switch self {
    case .schedule:
      ScheduleScreen()
    case .settings:
      Text("SettingsView()")
    }
  }

  var icon: Image {
    Image(rawValue)
  }
}

struct MainTabView: View {
  init() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.shadowColor = UIColor.ypBlackUniversal.withAlphaComponent(0.3)
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }

  var body: some View {
    TabView {
      ForEach(TabItem.allCases, id: \.id) { tab in
        tab.view.tabItem {
          tab.icon
            .frame(width: 75, height: 50)
        }
      }
    }.tint(.ypBlack).shadow(radius: 2)
  }
}

#Preview {
  MainTabView()
}
