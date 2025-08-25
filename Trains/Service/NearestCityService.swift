import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCity = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
  func getNearestCity(
    lat: Double,
    lng: Double,
    distance: Int?,
    lang: String?,
    format: String?
  ) async throws -> NearestCity
}

final class NearestCityService: NearestCityServiceProtocol {
  private let client: Client
  private let apikey: String

  init(client: Client, apikey: String) {
    self.client = client
    self.apikey = apikey
  }

  func getNearestCity(
    lat: Double,
    lng: Double,
    distance: Int? = nil,
    lang: String? = nil,
    format: String? = "json"
  ) async throws -> NearestCity {
    let response = try await client.getNearestCity(
      query: .init(
        apikey: apikey,
        lat: lat,
        lng: lng,
        distance: distance,
        lang: lang,
        format: format
      ))

    return try response.ok.body.json
  }
}
