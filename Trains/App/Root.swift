import SwiftUI

struct Root: View {
  let tabs: [(name: String, component: AnyView)] = [
    (name: "Schedule", component: AnyView(ScheduleScreen())),
    (name: "Settings", component: AnyView(Text("SettingsView()"))),
  ]
  init() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.shadowColor = UIColor.ypBlackUniversal.withAlphaComponent(0.3)
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }

  var body: some View {
    TabView {
      ForEach(tabs, id: \.name) { tab in
        tab.component.tabItem {
          Image(tab.name)
            .frame(width: 75, height: 50)
        }
      }
    }.tint(.ypBlack).shadow(radius: 2)
  }
}

#Preview {
  Root()
}
