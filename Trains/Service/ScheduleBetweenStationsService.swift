import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStations = Components.Schemas.Segments

protocol ScheduleBetweenStationsServiceProtocol {
  func getScheduleBetweenStations(
    from: String,
    to: String,
    format: String?,
    lang: String?,
    date: String?,
    transportTypes: String?,
    offset: Int?,
    limit: Int?,
    resultTimezone: String?,
    transfers: Bool?
  ) async throws -> ScheduleBetweenStations
}

final class ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
  private let client: Client
  private let apikey: String

  init(client: Client, apikey: String) {
    self.client = client
    self.apikey = apikey
  }

  func getScheduleBetweenStations(
    from: String,
    to: String,
    format: String? = "json",
    lang: String? = nil,
    date: String? = nil,
    transportTypes: String? = nil,
    offset: Int? = nil,
    limit: Int? = nil,
    resultTimezone: String? = nil,
    transfers: Bool? = nil
  ) async throws -> ScheduleBetweenStations {
    let response = try await client.getScheduleBetweenStations(
      query: .init(
        apikey: apikey,
        from: from,
        to: to,
        format: format,
        lang: lang,
        date: date,
        transport_types: transportTypes,
        offset: offset,
        limit: limit,
        result_timezone: resultTimezone,
        transfers: transfers
      ))

    return try response.ok.body.json
  }
}
