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
    return lhs.settlements.count == rhs.settlements.count
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(settlements.count)
  }
}

struct StationDestination: Hashable {
  let stations: [Components.Schemas.Station]

  static func == (lhs: StationDestination, rhs: StationDestination) -> Bool {
    return lhs.stations.count == rhs.stations.count
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(stations.count)
  }
}
