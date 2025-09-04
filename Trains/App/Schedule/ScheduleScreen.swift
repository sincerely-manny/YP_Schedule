import SwiftUI

struct ScheduleScreen: View {
  @StateObject private var viewModel = ScheduleViewModel()
  @StateObject private var navigationManager = NavigationManager()
  @State private var from: Components.Schemas.Station? = nil
  @State private var to: Components.Schemas.Station? = nil
  @State private var selectedStationBinding: Binding<Components.Schemas.Station?>?

  var body: some View {
    NavigationStack(path: $navigationManager.path) {
      VStack(spacing: 16) {
        HStack(alignment: .center, spacing: 16) {
          VStack {
            CityPicker(
              settlements: viewModel.settlements,
              placeholder: "Откуда",
              selectedStation: $from,
              selectedStationBinding: $selectedStationBinding,
              navigationManager: navigationManager
            ).disabled(viewModel.isLoading)
            CityPicker(
              settlements: viewModel.settlements,
              placeholder: "Куда",
              selectedStation: $to,
              selectedStationBinding: $selectedStationBinding,
              navigationManager: navigationManager
            ).disabled(viewModel.isLoading)
          }
          .frame(maxWidth: .infinity)
          .background(Color.ypWhiteUniversal)
          .clipShape(RoundedRectangle(cornerRadius: 20))

          Button {
            (from, to) = (to, from)
          } label: {
            Image("Сhange")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 24, height: 24)
              .tint(.ypBlue)
          }
          .frame(width: 36, height: 36)
          .background(Color.ypWhiteUniversal)
          .cornerRadius(36)
        }
        .padding(.all)
        .background(Color.ypBlue)
        .clipShape(RoundedRectangle(cornerRadius: 20))

        if let from, let to {
          Button {
            navigationManager.navigateTo(CarriersDestination(from: from, to: to))
          } label: {
            Text("Найти")
              .foregroundColor(.ypWhiteUniversal)
              .font(.system(size: 17, weight: .bold))
              .frame(width: 150, height: 60)
              .background(.ypBlue)
              .cornerRadius(16)
          }
        }

        Spacer()
      }
      .padding(.horizontal)
      .navigationDestination(for: CityDestination.self) { destination in
        CitySelectionView(settlements: destination.settlements)
          .environmentObject(navigationManager)
          .toolbarRole(.editor)
      }
      .navigationDestination(for: StationDestination.self) { destination in
        StationSelectionView(
          stations: destination.stations,
          onStationSelected: { station in
            selectedStationBinding?.wrappedValue = station
            navigationManager.goBackToRoot()
          }
        )
        .environmentObject(navigationManager)
        .toolbarRole(.editor)
      }
      .navigationDestination(for: CarriersDestination.self) { destination in
        CarriersListView(from: destination.from, to: destination.to)
          .environmentObject(navigationManager)
          .toolbarRole(.editor)
      }
    }
    .environmentObject(navigationManager)
    .onAppear {
      Task {
        await viewModel.fetchStations()
      }
    }
  }
}

struct CityPicker: View {
  var settlements: [Components.Schemas.Settlement]
  var placeholder: String
  @Binding var selectedStation: Components.Schemas.Station?
  @Binding var selectedStationBinding: Binding<Components.Schemas.Station?>?
  var navigationManager: NavigationManager

  var body: some View {
    Button(action: {
      selectedStationBinding = $selectedStation
      navigationManager.navigateTo(CityDestination(settlements: settlements))
    }) {
      HStack {
        Text(selectedStation?.title ?? placeholder)
          .foregroundColor(selectedStation == nil ? .ypGray : .ypBlackUniversal)
          .lineLimit(1)
          .frame(height: 48)
          .padding(.horizontal)
        Spacer()
      }
    }
  }
}

#Preview {
  ScheduleScreen()
}
