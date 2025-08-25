import OpenAPIRuntime
import OpenAPIURLSession

typealias RouteStations = Components.Schemas.ThreadStationsResponse

protocol RouteStationsServiceProtocol {
  func getRouteStations(
    uid: String,
    from: String?,
    to: String?,
    format: String?,
    lang: String?,
    date: String?,
    showSystems: String?
  ) async throws -> RouteStations
}

final class RouteStationsService: RouteStationsServiceProtocol {
  private let client: Client
  private let apikey: String

  init(client: Client, apikey: String) {
    self.client = client
    self.apikey = apikey
  }

  func getRouteStations(
    uid: String,
    from: String? = nil,
    to: String? = nil,
    format: String? = "json",
    lang: String? = nil,
    date: String? = nil,
    showSystems: String? = nil
  ) async throws -> RouteStations {
    let response = try await client.getRouteStations(
      query: .init(
        apikey: apikey,
        uid: uid,
        from: from,
        to: to,
        format: format,
        lang: lang,
        date: date,
        show_systems: showSystems
      ))

    return try response.ok.body.json
  }
}
