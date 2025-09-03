import OpenAPIURLSession
import SwiftUI

struct CarriersListView: View {
  var from: Components.Schemas.Station
  var to: Components.Schemas.Station
  @StateObject private var viewModel: CarriersListModel
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

  init(
    from: Components.Schemas.Station, to: Components.Schemas.Station,
    viewModel: CarriersListModel = CarriersListModel()
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
      ScrollView {
        LazyVStack(spacing: 8) {
          if let segments = viewModel.schedule?.segments {
            ForEach(segments, id: \.self) { segment in
              SegmentView(
                segment: segment, isoFormatter: isoFormatter, dateFormatter: dateFormatter)
            }
          }
        }.padding(.horizontal)
      }
    }
    .onAppear {
      Task {
        await viewModel.loadSchedule(from: from, to: to)
      }
    }
  }
}

struct SegmentView: View {
  let segment: Components.Schemas.Segment
  let isoFormatter: DateFormatter
  let dateFormatter: DateFormatter

  private var date: String {
    guard let dateString = segment.start_date else { return "" }
    let date = isoFormatter.date(from: dateString) ?? Date()
    return dateFormatter.string(from: date)
  }

  var body: some View {
    VStack(spacing: 18) {
      HStack(alignment: .top, spacing: 8) {
        if let urlString = segment.thread?.carrier?.logo, let url = URL(string: urlString) {
          AsyncImage(url: url) { image in
            image.resizable().aspectRatio(contentMode: .fill)
          } placeholder: {
            ProgressView()
          }
          .frame(width: 38, height: 38, alignment: .leading)
          .clipShape(.rect(cornerRadius: 12))
        } else {
          Image(systemName: "train.side.front.car")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 38, height: 38)
            .clipShape(.rect(cornerRadius: 12))
        }
        VStack(alignment: .leading, spacing: 4) {
          Text(segment.thread?.carrier?.title ?? "")
            .lineLimit(1)
          if Bool(segment.has_transfers ?? false) {
            Text("С пересадкой")
              .font(.system(size: 12))
              .foregroundColor(.ypRed)
              .lineLimit(1)
          }
        }
        Spacer()
        Text(date)
          .font(.system(size: 12))
          .lineLimit(1)
      }
      HStack(alignment: .center, spacing: 4) {
        Text("14:00")
        Rectangle()
          .frame(maxWidth: .infinity, maxHeight: 1)
          .foregroundColor(.ypGray)
        Text("20 часов")
          .font(.system(size: 12))
        Rectangle()
          .frame(maxWidth: .infinity, maxHeight: 1)
          .foregroundColor(.ypGray)
        Text("14:30")
      }
    }
    .padding(.all, 14)
    .background(.ypLightGray)
    .cornerRadius(24)
    .foregroundColor(.ypBlackUniversal)
  }
}

#Preview {
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

final class CarriersListModel: ObservableObject {
  @Published var schedule: ScheduleBetweenStations? = nil
  @Published var isLoading = false
  @Published var error: Error?

  private let client: Client
  private let service: ScheduleBetweenStationsService

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

    isLoading = true
    do {
      schedule = try await service.getScheduleBetweenStations(from: fromCode, to: toCode)
    } catch {
      self.error = error
    }
    isLoading = false
  }
}
