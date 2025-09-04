import SwiftUI

struct CitySelectionView: View {
  var settlements: [Components.Schemas.Settlement]
  @EnvironmentObject var navigationManager: NavigationManager
  @State private var searchText = ""
  @State private var searchIsPresented = false

  private var filteredSettlements: [Components.Schemas.Settlement] {
    if searchText.isEmpty {
      return settlements
    } else {
      return settlements.filter { settlement in
        (settlement.title ?? "").localizedCaseInsensitiveContains(searchText)
      }
    }
  }

  private func getTitle(for settlement: Components.Schemas.Settlement) -> String {
    if let title = settlement.title, title.count > 0 {
      return title
    } else {
      return "Неизвестный город"
    }
  }

  var body: some View {
    VStack {
      if filteredSettlements.isEmpty {
        Spacer()
        Text("Город не найден")
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(.ypBlack)
        Spacer()
      } else {
        ScrollView {
          LazyVStack {
            ForEach(filteredSettlements, id: \.codes?.yandex_code) { settlement in
              Button(action: {
                let stations = (settlement.stations ?? []).compactMap { $0 }
                searchIsPresented = false  // messes navigation state somehow othewise
                navigationManager.navigateTo(StationDestination(stations: stations))

              }) {
                HStack(alignment: .center) {
                  Text(getTitle(for: settlement))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                  Spacer()
                  Image(systemName: "chevron.right").foregroundColor(.ypBlack)
                }
                .frame(height: 60)
                .padding(.horizontal, 16)
              }
            }
          }
        }
      }
    }
    .navigationBarTitle("Выбор города", displayMode: .inline)
    .searchable(
      text: $searchText,
      isPresented: $searchIsPresented,
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: "Введите запрос",
    )

  }
}

#Preview {
  CitySelectionView(settlements: placeholder)
}
