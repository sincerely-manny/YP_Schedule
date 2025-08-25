import OpenAPIRuntime
import OpenAPIURLSession

class ServiceExamples {
  private let client: Client

  init(
    client: Client = Client(
      serverURL: try! Servers.Server1.url(), transport: URLSessionTransport())
  ) {
    self.client = client
  }

  func nearestStationsExample() async throws {
    let service = NearestStationsService(
      client: client,
      apikey: Env.API_KEY
    )

    let stations = try await service.getNearestStations(
      lat: 59.864177,
      lng: 30.319163,
      distance: 50
    )

    print("Successfully fetched stations: \(stations)")
  }

  func copyrightExample() async throws {
    let service = CopyrightService(
      client: client,
      apikey: Env.API_KEY
    )

    let copyright = try await service.getCopyright(format: "json")

    print("Successfully fetched copyright: \(copyright)")
  }

  func scheduleBetweenStationsExample() async throws {
    let service = ScheduleBetweenStationsService(
      client: client,
      apikey: Env.API_KEY
    )

    let schedule = try await service.getScheduleBetweenStations(
      from: "c213",
      to: "c2",
      date: "2024-01-15"
    )

    print("Successfully fetched schedule: \(schedule)")
  }

  func stationScheduleExample() async throws {
    let service = StationScheduleService(
      client: client,
      apikey: Env.API_KEY
    )

    let schedule = try await service.getStationSchedule(
      station: "s9600213",
      date: "2024-01-15"
    )

    print("Successfully fetched station schedule: \(schedule)")
  }

  func routeStationsExample() async throws {
    let service = RouteStationsService(
      client: client,
      apikey: Env.API_KEY
    )

    let route = try await service.getRouteStations(
      uid: "SU-1440_2_2"
    )

    print("Successfully fetched route stations: \(route)")
  }

  func nearestCityExample() async throws {
    let service = NearestCityService(
      client: client,
      apikey: Env.API_KEY
    )

    let city = try await service.getNearestCity(
      lat: 59.864177,
      lng: 30.319163,
      distance: 50
    )

    print("Successfully fetched nearest city: \(city)")
  }

  func carrierInfoExample() async throws {
    let service = CarrierInfoService(
      client: client,
      apikey: Env.API_KEY
    )

    let carrier = try await service.getCarrierInfo(
      code: "SU",
      system: "iata"
    )

    print("Successfully fetched carrier info: \(carrier)")
  }

  func allStationsExample() async throws {
    let service = AllStationsService(
      client: client,
      apikey: Env.API_KEY
    )

    let stations = try await service.getAllStations(
      lang: "ru_RU"
    )

    print("Successfully fetched all stations: \(stations)")
  }
}
