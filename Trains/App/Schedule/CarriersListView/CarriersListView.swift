import SwiftUI

struct CarriersListView: View {
  var from: Components.Schemas.Station
  var to: Components.Schemas.Station
  @StateObject private var viewModel: CarriersListViewModel
  @State private var appliedTimeFilters = Set<TimeFilter>()
  @State private var appliedTransferFilter = TransferFilter.no

  private let isoFormatter: DateFormatter = {
    let isoFormatter = DateFormatter()
    isoFormatter.dateFormat = "yyyy-MM-dd"
    return isoFormatter
  }()

  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM"
    return dateFormatter
  }()

  private var filterIsDirty: Bool {
    appliedTimeFilters.count != 0
      || appliedTransferFilter != TransferFilter.no
  }

  private var filteredSegments: [Components.Schemas.Segment] {
    guard var segments = viewModel.schedule?.segments else { return [] }
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

  init(
    from: Components.Schemas.Station, to: Components.Schemas.Station,
    viewModel: CarriersListViewModel = CarriersListViewModel()
  ) {
    self._viewModel = StateObject(wrappedValue: viewModel)
    self.from = from
    self.to = to
  }

  var body: some View {
    VStack {
      if let fromTitle = from.title, let toTitle = to.title {
        Text("\(fromTitle) → \(toTitle)")
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(.ypBlack)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal)
      }
      ZStack(alignment: .bottom) {
        ScrollView {
          LazyVStack(spacing: 8) {
            ForEach(filteredSegments, id: \.self) { segment in
              SegmentView(
                segment: segment, isoFormatter: isoFormatter, dateFormatter: dateFormatter)
            }
          }
          .padding(.horizontal)
          .padding(.bottom, 100)
        }
        NavigationLink {
          FiltersView(
            appliedTimeFilters: $appliedTimeFilters,
            appliedTransferFilter: $appliedTransferFilter,
          )
          .toolbarRole(.editor)
        } label: {
          HStack(alignment: .center, spacing: 8) {
            Text("Уточнить время")
              .foregroundColor(.ypWhiteUniversal)
              .font(.system(size: 17, weight: .bold))
            if filterIsDirty {
              Circle()
                .fill(.ypRed)
                .frame(width: 8, height: 8)
            }
          }
          .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
          .background(.ypBlue)
          .cornerRadius(16)
        }
        .padding(.horizontal)
        .padding(.bottom, 24)
      }
    }
    .onAppear {
      Task {
        await viewModel.loadSchedule(from: from, to: to)
      }
    }
  }
}

enum TimeFilter: String, CaseIterable {
  case morning = "Утро 06:00 - 12:00"
  case afternoon = "День 12:00 - 18:00"
  case evening = "Вечер 18:00 - 00:00"
  case night = "Ночь 00:00 - 06:00"

  private static let timeFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.defaultDate = Date(timeIntervalSince1970: 0)

    return formatter
  }()

  func matches(_ strtime: String) -> Bool {
    guard let time = TimeFilter.timeFormatter.date(from: strtime) else { return false }
    switch self {
    case .morning:
      return time >= Date(timeIntervalSince1970: 6 * 60 * 60)
        && time <= Date(timeIntervalSince1970: 12 * 60 * 60)
    case .afternoon:
      return time >= Date(timeIntervalSince1970: 12 * 60 * 60)
        && time <= Date(timeIntervalSince1970: 18 * 60 * 60)
    case .evening:
      return time >= Date(timeIntervalSince1970: 18 * 60 * 60)
        && time <= Date(timeIntervalSince1970: 24 * 60 * 60)
    case .night:
      return time >= Date(timeIntervalSince1970: 0)
        && time <= Date(timeIntervalSince1970: 6 * 60 * 60)
    }
  }
}

enum TransferFilter: String, CaseIterable {
  case yes = "Да"
  case no = "Нет"

  var boolean: Bool {
    switch self {
    case .yes:
      return true
    case .no:
      return false
    }
  }
}

#Preview {
  NavigationStack {
    CarriersListView(
      from: Components.Schemas.Station(
        title: "Санкт-Петербург (Московский вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Московское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s9602494",
          esr_code: "031812"
        )
      ),
      to: Components.Schemas.Station(
        title: "Москва (Ленинградский вокзал)",
        station_type: "train_station",
        transport_type: "train",
        direction: "Ленинградское",
        codes: Components.Schemas.Station.codesPayload(
          yandex_code: "s2006004",
          esr_code: "060073"
        )
      )
    )
  }
}
