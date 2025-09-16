import OpenAPIURLSession

actor NetworkClient {
  static let shared = NetworkClient()

  enum NetworkClientError: Error {
    case invalidStationCodes
    case noScheduleFound
    case noStationsFound
  }

  private let client: Client
  private let scheduleBetweenStationsService: ScheduleBetweenStationsService
  private let allStationsService: AllStationsService

  init() {
    self.client = Client(
      serverURL: try! Servers.Server1.url(),
      transport: URLSessionTransport()
    )
    self.scheduleBetweenStationsService = ScheduleBetweenStationsService(
      client: client,
      apikey: Env.API_KEY
    )
    self.allStationsService = AllStationsService(
      client: client,
      apikey: Env.API_KEY
    )
  }

  func getScheduleBetweenStationsSegments(
    from: Components.Schemas.Station,
    to: Components.Schemas.Station
  ) async throws -> [Components.Schemas.Segment] {
    guard let fromCode = from.codes?.yandex_code, let toCode = to.codes?.yandex_code else {
      throw NetworkClientError.invalidStationCodes
    }

    let schedule = try await scheduleBetweenStationsService.getScheduleBetweenStations(
      from: fromCode, to: toCode, transfers: true)

    guard let segments = schedule.segments, !segments.isEmpty else {
      throw NetworkClientError.noScheduleFound
    }
    return segments
  }

  func fetchStations() async throws -> [Components.Schemas.Settlement] {
    let all = try await allStationsService.getAllStations()

    let russia = all.countries?.first { $0.title == "Россия" }
    if let russia {
      let settlements =
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

      return settlements
    }

    throw NetworkClientError.noStationsFound
  }

}
