import SwiftUI

struct CarriersListView: View {
  var from: Components.Schemas.Station
  var to: Components.Schemas.Station
  @StateObject private var viewModel: CarriersListViewModel
  @State private var appliedTimeFilters = Set<TimeFilter>()
  @State private var appliedTransferFilter = TransferFilter.no

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
            if let segments = viewModel.schedule?.segments {
              ForEach(segments, id: \.self) { segment in
                SegmentView(
                  segment: segment, isoFormatter: isoFormatter, dateFormatter: dateFormatter)
              }
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
          Text("Уточнить время")
            .foregroundColor(.ypWhiteUniversal)
            .font(.system(size: 17, weight: .bold))
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

struct SegmentView: View {
  let segment: Components.Schemas.Segment
  let isoFormatter: DateFormatter
  let dateFormatter: DateFormatter

  private var date: String {
    guard let dateString = segment.start_date else { return "" }
    let date = isoFormatter.date(from: dateString) ?? Date()
    return dateFormatter.string(from: date)
  }

  private var duration: String {
    let float = (Float(segment.duration ?? 0) / 1800.0).rounded() / 2
    return float.truncatingRemainder(dividingBy: 1) == 0
      ? String(format: "%.0f", float) : String(float)
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
        Text((segment.departure ?? "").prefix(5))
        Rectangle()
          .frame(maxWidth: .infinity, maxHeight: 1)
          .foregroundColor(.ypGray)
        Text("\(duration) часов")
          .font(.system(size: 12))
        Rectangle()
          .frame(maxWidth: .infinity, maxHeight: 1)
          .foregroundColor(.ypGray)
        Text((segment.arrival ?? "").prefix(5))
      }
    }
    .padding(.all, 14)
    .background(.ypLightGray)
    .cornerRadius(24)
    .foregroundColor(.ypBlackUniversal)
  }
}

enum TimeFilter: String, CaseIterable {
  case morning = "Утро 06:00 - 12:00"
  case afternoon = "День 12:00 - 18:00"
  case evening = "Вечер 18:00 - 00:00"
  case night = "Ночь 00:00 - 06:00"
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

struct FiltersView: View {
  @Binding var appliedTimeFilters: Set<TimeFilter>
  @Binding var appliedTransferFilter: TransferFilter
  @State private var isDirty = false
  @Environment(\.dismiss) var dismiss

  var body: some View {
    ZStack(alignment: .bottom) {

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          Text("Время отправления")
            .font(.system(size: 24, weight: .bold))
          ForEach(TimeFilter.allCases, id: \.self) { filter in
            Button {
              if appliedTimeFilters.contains(filter) {
                appliedTimeFilters.remove(filter)
              } else {
                appliedTimeFilters.insert(filter)
              }
              isDirty = true
            } label: {
              HStack {
                Text(filter.rawValue)
                Spacer()
                Image(
                  systemName: appliedTimeFilters.contains(filter)
                    ? "checkmark.square.fill" : "square"
                )
                .resizable().frame(width: 24, height: 24)
              }.frame(height: 60)
            }
          }
          Text("Показывать варианты с пересадками")
            .font(.system(size: 24, weight: .bold))
          ForEach(TransferFilter.allCases, id: \.self) { filter in
            Button {
              appliedTransferFilter = filter
              isDirty = true
            } label: {
              HStack {
                Text(filter.rawValue)
                Spacer()
                Image(
                  appliedTransferFilter == filter ? "radio.on" : "radio.off"
                )
                .resizable().frame(width: 24, height: 24)
              }.frame(height: 60)
            }
          }
          Spacer()

        }
        .foregroundColor(.ypBlack)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom, 100)
      }
      if isDirty {
        Button {
          dismiss()
        } label: {
          Text("Применить")
            .foregroundColor(.ypWhiteUniversal)
            .font(.system(size: 17, weight: .bold))
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .background(.ypBlue)
            .cornerRadius(16)
        }
        .padding(.horizontal)
        .padding(.bottom, 24)
      }
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

#Preview {
  struct PreviewWrapper: View {
    @State var appliedTimeFilters = Set<TimeFilter>()
    @State var appliedTransferFilter = TransferFilter.no

    var body: some View {
      FiltersView(
        appliedTimeFilters: $appliedTimeFilters,
        appliedTransferFilter: $appliedTransferFilter
      )
    }
  }
  return PreviewWrapper()
}
