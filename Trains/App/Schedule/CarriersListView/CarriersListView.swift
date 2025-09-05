import SwiftUI

struct CarriersListView: View {
  var from: Components.Schemas.Station
  var to: Components.Schemas.Station
  @StateObject private var viewModel: CarriersListViewModel

  private var filterIsDirty: Bool {
    viewModel.appliedTimeFilters.count != 0
      || viewModel.appliedTransferFilter != TransferFilter.no
  }

  private var filteredSegments: [Components.Schemas.Segment] {
    viewModel.getFilteredSegments()
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
      ZStack {
        if filteredSegments.isEmpty && viewModel.state != .loading {
          VStack {
            Spacer()
            Text("Вариантов нет")
              .font(.system(size: 24, weight: .bold))
              .foregroundColor(.ypBlack)
            Spacer()
          }
        } else {
          ScrollView {
            LazyVStack(spacing: 8) {
              ForEach(filteredSegments, id: \.self) { segment in
                SegmentView(
                  segment: segment, isoFormatter: viewModel.isoFormatter,
                  dateFormatter: viewModel.dateFormatter)
              }
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
          }
        }
        VStack {
          Spacer()
          NavigationLink {
            FiltersView(
              appliedTimeFilters: $viewModel.appliedTimeFilters,
              appliedTransferFilter: $viewModel.appliedTransferFilter,
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
      }.frame(maxHeight: .infinity)
    }
    .onAppear {
      Task {
        await viewModel.loadSchedule(from: from, to: to)
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
