import OpenAPIURLSession
import SwiftUI

final class ScheduleViewModel: ObservableObject {
  @Published var settlements: [Components.Schemas.Settlement] = []
  @Published var isLoading = false
  @Published var error: Error?

  private let client: Client
  private let service: AllStationsService

  init() {
    self.client = Client(
      serverURL: try! Servers.Server1.url(), transport: URLSessionTransport())
    self.service = AllStationsService(client: client, apikey: Env.API_KEY)
  }

  @MainActor
  func fetchStations() async {
    isLoading = true
    error = nil
    // Initialize settlements with placeholder data
    settlements = placeholder
    isLoading = false
    return
    // End placeholder initialization

    do {
      let all = try await service.getAllStations()

      let russia = all.countries?.first { $0.title == "Россия" }
      if let russia {
        settlements =
          russia.regions?
          .compactMap { $0.settlements }
          .flatMap { $0 }
          .filter { settlement in
            // Only settlements with non-empty titles
            guard let title = settlement.title, !title.isEmpty else { return false }

            // Only settlements that have train stations
            let hasTrainStations =
              settlement.stations?.contains { $0.station_type == "train_station" } ?? false
            return hasTrainStations
          }
          .compactMap { settlement -> Components.Schemas.Settlement? in
            // Create settlement with only train stations
            guard let allStations = settlement.stations else { return nil }
            let trainStations = allStations.filter { $0.station_type == "train_station" }

            var updatedSettlement = settlement
            updatedSettlement.stations = trainStations
            return updatedSettlement
          }
          .sorted { ($0.title ?? "") < ($1.title ?? "") } ?? []

        isLoading = false
      }

    } catch {
      self.error = error
    }

    isLoading = false
  }
}

let placeholder = [
  Components.Schemas.Settlement(
    title: "Москва",
    codes: Components.Schemas.Settlement.codesPayload(yandex_code: "c213"),
    stations: [
      Components.Schemas.Station(
        title: "Москва (Курский вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Горьковское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s2000001",
          esr_code: "191602"
        )
      ),
      Components.Schemas.Station(
        title: "Москва (Ярославский вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Ярославское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s2000002",
          esr_code: "195506"
        )
      ),
      Components.Schemas.Station(
        title: "Москва (Казанский вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Казанское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s2000003",
          esr_code: "194013"
        )
      ),
      Components.Schemas.Station(
        title: "Москва (Восточный вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Горьковское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s9879173",
          esr_code: "995"
        )
      ),
    ]
  ),

  Components.Schemas.Settlement(
    title: "Санкт-Петербург",
    codes: Components.Schemas.Settlement.codesPayload(yandex_code: "c2"),
    stations: [
      Components.Schemas.Station(
        title: "Санкт-Петербург (Московский вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Московское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s9602494",
          esr_code: "031812"
        )
      ),
      Components.Schemas.Station(
        title: "Санкт-Петербург (Витебский вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Витебское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s9602496",
          esr_code: "033061"
        )
      ),
      Components.Schemas.Station(
        title: "Санкт-Петербург (Финляндский вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Выборгское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s9602497",
          esr_code: "038205"
        )
      ),
      Components.Schemas.Station(
        title: "Санкт-Петербург (Ладожский вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Волховстроевское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s9602499",
          esr_code: "037109"
        )
      ),
    ]
  ),
]
