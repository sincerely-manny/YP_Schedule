import OpenAPIRuntime
import OpenAPIURLSession

typealias StationSchedule = Components.Schemas.ScheduleResponse

protocol StationScheduleServiceProtocol {
  func getStationSchedule(
    station: String,
    lang: String?,
    format: String?,
    date: String?,
    transportTypes: String?,
    event: String?,
    direction: String?,
    system: String?,
    resultTimezone: String?
  ) async throws -> StationSchedule
}

final class StationScheduleService: StationScheduleServiceProtocol {
  private let client: Client
  private let apikey: String

  init(client: Client, apikey: String) {
    self.client = client
    self.apikey = apikey
  }

  func getStationSchedule(
    station: String,
    lang: String? = nil,
    format: String? = "json",
    date: String? = nil,
    transportTypes: String? = nil,
    event: String? = nil,
    direction: String? = nil,
    system: String? = nil,
    resultTimezone: String? = nil
  ) async throws -> StationSchedule {
    let response = try await client.getStationSchedule(
      query: .init(
        apikey: apikey,
        station: station,
        lang: lang,
        format: format,
        date: date,
        transport_types: transportTypes,
        event: event,
        direction: direction,
        system: system,
        result_timezone: resultTimezone
      ))

    return try response.ok.body.json
  }
}
