import OpenAPIURLSession
import SwiftUI

final class CarriersListViewModel: ObservableObject {
  @Published var schedule: ScheduleBetweenStations? = nil
  @Published var isLoading = false
  @Published var error: Error?

  private let client: Client
  private let service: ScheduleBetweenStationsService

  init() {
    self.client = Client(
      serverURL: try! Servers.Server1.url(), transport: URLSessionTransport())
    self.service = ScheduleBetweenStationsService(client: client, apikey: Env.API_KEY)
  }

  @MainActor
  func loadSchedule(from: Components.Schemas.Station, to: Components.Schemas.Station) async {
    guard let fromCode = from.codes?.yandex_code, let toCode = to.codes?.yandex_code else {
      return
    }

    isLoading = true
    do {
      schedule = try await service.getScheduleBetweenStations(from: fromCode, to: toCode)
    } catch {
      self.error = error
    }
    isLoading = false
  }
}
