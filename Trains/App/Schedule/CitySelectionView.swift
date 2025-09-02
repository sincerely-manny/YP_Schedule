import SwiftUI

struct CitySelectionView: View {
  var settlements: [Components.Schemas.Settlement]
  @Environment(\.navigation) private var navigation
  @State private var searchText = ""

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
                navigation.navigateTo(StationDestination(stations: settlement.stations ?? []))
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
    }.navigationBarTitle("Выбор города", displayMode: .inline)
      .searchable(
        text: $searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Введите запрос"
      )
  }
}

#Preview {
  CitySelectionView(settlements: placeholder)
    .environment(\.navigation, NavigationManager())
}
