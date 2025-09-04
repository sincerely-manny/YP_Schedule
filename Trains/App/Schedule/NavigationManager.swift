import SwiftUI

class NavigationManager: ObservableObject {
  @Published var path = NavigationPath()

  func navigateTo<T: Hashable>(_ destination: T) {
    path.append(destination)
  }

  func goBack() {
    if !path.isEmpty {
      path.removeLast()
    }
  }

  func goBackToRoot() {
    path = NavigationPath()
  }
}

struct CityDestination: Hashable {
  let settlements: [Components.Schemas.Settlement]

  static func == (lhs: CityDestination, rhs: CityDestination) -> Bool {
    return lhs.settlements.map { $0.codes?.yandex_code }
      == rhs.settlements.map { $0.codes?.yandex_code }
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(settlements.map { $0.codes?.yandex_code })
  }
}

struct StationDestination: Hashable {
  let stations: [Components.Schemas.Station]

  static func == (lhs: StationDestination, rhs: StationDestination) -> Bool {
    return lhs.stations.map { $0.codes?.yandex_code } == rhs.stations.map { $0.codes?.yandex_code }
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(stations.map { $0.codes?.yandex_code })
  }
}

struct CarriersDestination: Hashable {
  let from: Components.Schemas.Station
  let to: Components.Schemas.Station

  static func == (lhs: CarriersDestination, rhs: CarriersDestination) -> Bool {
    return lhs.from.codes?.yandex_code == rhs.from.codes?.yandex_code
      && lhs.to.codes?.yandex_code == rhs.to.codes?.yandex_code
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(from.codes?.yandex_code)
    hasher.combine(to.codes?.yandex_code)
  }
}
