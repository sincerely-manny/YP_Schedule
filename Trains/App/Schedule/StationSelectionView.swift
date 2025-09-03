import SwiftUI

struct StationSelectionView: View {
  var stations: [Components.Schemas.Station]
  var onStationSelected: (Components.Schemas.Station) -> Void
  @EnvironmentObject var navigationManager: NavigationManager
  @State private var searchText = ""

  private var filteredStations: [Components.Schemas.Station] {
    if searchText.isEmpty {
      return stations
    } else {
      return stations.filter {
        ($0.title ?? "").localizedCaseInsensitiveContains(searchText)
      }
    }
  }

  private func getTitle(for station: Components.Schemas.Station) -> String {
    if let title = station.title, title.count > 0 {
      return title
    } else {
      return "Неизвестная станция"
    }
  }

  var body: some View {
    VStack {
      if filteredStations.isEmpty {
        Spacer()
        Text("Станция не найдена")
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(.ypBlack)
        Spacer()
      } else {
        ScrollView {
          LazyVStack {
            ForEach(filteredStations, id: \.codes?.yandex_code) { station in
              Button(action: {
                onStationSelected(station)
              }) {
                HStack(alignment: .center) {
                  Text(getTitle(for: station))
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
    .navigationBarTitle("Выбор станции", displayMode: .inline)
    .searchable(
      text: $searchText,
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: "Введите запрос"
    )
  }
}
