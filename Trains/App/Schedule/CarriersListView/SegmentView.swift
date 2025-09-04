import SwiftUI

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
    NavigationLink {
      VStack {
        Text("Carrier Details")
      }
      .navigationTitle("Информация о перевозчике")
      .toolbarRole(.editor)
    } label: {
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
}
