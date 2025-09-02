import SwiftUI

struct ScheduleScreen: View {
  @StateObject private var viewModel = ScheduleViewModel()
  @StateObject private var navigationManager = NavigationManager()
  @State private var from: Components.Schemas.Station? = nil
  @State private var to: Components.Schemas.Station? = nil
  @State private var selectedStationBinding: Binding<Components.Schemas.Station?>?

  var body: some View {
    NavigationStack(path: $navigationManager.path) {
      VStack(spacing: 20) {
        HStack(alignment: .center, spacing: 16) {
          VStack {
            CityPicker(
              settlements: viewModel.settlements,
              placeholder: "Откуда",
              selectedStation: $from,
              selectedStationBinding: $selectedStationBinding
            )
            CityPicker(
              settlements: viewModel.settlements,
              placeholder: "Куда",
              selectedStation: $to,
              selectedStationBinding: $selectedStationBinding
            )
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

        if viewModel.isLoading {
          ProgressView("Загрузка городов...")
        }

        if let error = viewModel.error {
          Text("Ошибка: \(error.localizedDescription)")
            .foregroundColor(.red)
        }

        Spacer()
      }
      .padding(.horizontal)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationDestination(for: CityDestination.self) { destination in
        CitySelectionView(settlements: destination.settlements)
          .environment(\.navigation, navigationManager)
      }
      .navigationDestination(for: StationDestination.self) { destination in
        StationSelectionView(
          stations: destination.stations,
          onStationSelected: { station in
            selectedStationBinding?.wrappedValue = station
            navigationManager.goBackToRoot()
          }
        )
        .environment(\.navigation, navigationManager)
      }
    }
    .environment(\.navigation, navigationManager)
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
  @Environment(\.navigation) private var navigation

  var body: some View {
    Button(action: {
      selectedStationBinding = $selectedStation
      navigation.navigateTo(CityDestination(settlements: settlements))
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
