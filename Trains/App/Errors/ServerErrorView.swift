import SwiftUI

struct ServerErrorView: View {
  var body: some View {
    VStack(spacing: 16) {
      Image("Server Error")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 223, height: 223)
      Text("Ошибка сервера")
        .font(.system(size: 25, weight: .bold))
        .foregroundColor(.ypBlack)
    }
  }
}
