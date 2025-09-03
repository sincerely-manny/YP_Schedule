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

struct NavigationManagerKey: EnvironmentKey {
  static let defaultValue = NavigationManager()
}

extension EnvironmentValues {
  var navigation: NavigationManager {
    get { self[NavigationManagerKey.self] }
    set { self[NavigationManagerKey.self] = newValue }
  }
}

struct CityDestination: Hashable {
  let settlements: [Components.Schemas.Settlement]

  static func == (lhs: CityDestination, rhs: CityDestination) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(settlements.map { $0.codes?.yandex_code })
  }
}

struct StationDestination: Hashable {
  let stations: [Components.Schemas.Station]

  static func == (lhs: StationDestination, rhs: StationDestination) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(stations.map { $0.codes?.yandex_code })
  }
}

struct CarriersDestination: Hashable {
  let from: Components.Schemas.Station
  let to: Components.Schemas.Station

  static func == (lhs: CarriersDestination, rhs: CarriersDestination) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(from.codes?.yandex_code)
    hasher.combine(to.codes?.yandex_code)
  }
}
