import SwiftUI

struct SettingsView: View {
  @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false
  @State private var theme = "light"

  var body: some View {
    NavigationStack {
      VStack {
        Toggle(isOn: $isDarkModeEnabled) {
          Text("Темная тема")
        }.tint(.ypBlue).frame(height: 60)
        NavigationLink {
          EULA()
            .navigationTitle("Пользовательское соглашение")
            .toolbarRole(.editor)
            .toolbar(.hidden, for: .tabBar)
        } label: {
          HStack {
            Text("Пользовательское соглашение")
            Spacer()
            Image(systemName: "chevron.right")
          }.frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .leading)
        }
        Spacer()
        VStack(spacing: 16) {
          Text("Приложение использует API «Яндекс.Расписания»")
          Text("Версия 1.0 (beta)")
        }.font(.system(size: 12))
      }
      .foregroundColor(.ypBlack)
      .padding()
      .padding(.vertical, 24)
    }
  }
}

#Preview {
  SettingsView()
}
