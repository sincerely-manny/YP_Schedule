import OpenAPIURLSession
import SwiftUI

final class CarriersListViewModel: ObservableObject {
  @Published var schedule: ScheduleBetweenStations? = nil
  @Published var appliedTimeFilters = Set<TimeFilter>()
  @Published var appliedTransferFilter = TransferFilter.no
  @Published var state: CarriersListState = .loading

  enum CarriersListState: Equatable {
    case loading
    case empty
    case loaded([Components.Schemas.Segment])
    case error(String)
  }

  private let client: Client
  private let service: ScheduleBetweenStationsService

  let isoFormatter: DateFormatter = {
    let isoFormatter = DateFormatter()
    isoFormatter.dateFormat = "yyyy-MM-dd"
    return isoFormatter
  }()

  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM"
    return dateFormatter
  }()

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
    state = .loading
    do {
      schedule = try await service.getScheduleBetweenStations(
        from: fromCode, to: toCode, transfers: true)
    } catch {
      state = .error(error.localizedDescription)
    }
    if let segments = schedule?.segments, !segments.isEmpty {
      state = .loaded(segments)
    } else {
      state = .empty
    }
  }

  func getFilteredSegments()
    -> [Components.Schemas.Segment]
  {
    guard var segments = schedule?.segments else { return [] }
    if appliedTimeFilters.count != 0 {
      segments = segments.filter { segment in
        guard let departure = segment.departure else { return false }
        for timeFilter in appliedTimeFilters {
          if timeFilter.matches(departure) {
            return true
          }
        }
        return false
      }
    }
    if !appliedTransferFilter.boolean {
      segments = segments.filter { !($0.has_transfers ?? false) }
    }
    return segments
  }

}
