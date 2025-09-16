import OpenAPIURLSession
import SwiftUI

@MainActor
final class CarriersListViewModel: ObservableObject {
  @Published var appliedTimeFilters = Set<TimeFilter>()
  @Published var appliedTransferFilter = TransferFilter.no
  @Published var state: CarriersListState = .loading

  enum CarriersListState: Equatable {
    case loading
    case empty
    case loaded([Components.Schemas.Segment])
    case error(String)
  }

  private let networkClient: NetworkClient = NetworkClient.shared

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

  func loadSchedule(from: Components.Schemas.Station, to: Components.Schemas.Station) async {
    state = .loading
    do {
      let segments = try await networkClient.getScheduleBetweenStationsSegments(from: from, to: to)
      state = .loaded(segments)
    } catch {
      switch error {
      case NetworkClient.NetworkClientError.noScheduleFound:
        state = .empty
      default:
        state = .error(error.localizedDescription)
      }
    }
  }

  func getFilteredSegments()
    -> [Components.Schemas.Segment]
  {
    var segments: [Components.Schemas.Segment] = []
    switch state {
    case .loading:
      return segments
    case .empty:
      return segments
    case .loaded(let value):
      segments = value
    case .error(_):
      return segments
    }

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
