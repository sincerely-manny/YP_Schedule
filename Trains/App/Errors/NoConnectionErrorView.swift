import SwiftUI

struct NoConnectionErrorView: View {
  var body: some View {
    VStack(spacing: 16) {
      Image("No Internet")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 223, height: 223)
      Text("Нет интернета")
        .font(.system(size: 25, weight: .bold))
        .foregroundColor(.ypBlack)
    }
  }
}
