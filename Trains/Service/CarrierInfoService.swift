import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierInfo = Components.Schemas.CarrierResponse

protocol CarrierInfoServiceProtocol {
  func getCarrierInfo(
    code: String,
    system: String?,
    lang: String?,
    format: String?
  ) async throws -> CarrierInfo
}

final class CarrierInfoService: CarrierInfoServiceProtocol {
  private let client: Client
  private let apikey: String

  init(client: Client, apikey: String) {
    self.client = client
    self.apikey = apikey
  }

  func getCarrierInfo(
    code: String,
    system: String? = nil,
    lang: String? = nil,
    format: String? = "json"
  ) async throws -> CarrierInfo {
    let response = try await client.getCarrierInfo(
      query: .init(
        apikey: apikey,
        code: code,
        system: system,
        lang: lang,
        format: format
      ))

    return try response.ok.body.json
  }
}
