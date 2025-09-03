import SwiftUI

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
