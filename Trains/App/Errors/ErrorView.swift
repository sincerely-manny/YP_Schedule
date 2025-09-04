import SwiftUI

enum ErrorState {
  case noInternet
  case serverError

  var imageName: String {
    switch self {
    case .noInternet: return "No Internet"
    case .serverError: return "Server Error"
    }
  }

  var message: String {
    switch self {
    case .noInternet: return "Нет интернета"
    case .serverError: return "Ошибка сервера"
    }
  }
}

struct ErrorView: View {
  let state: ErrorState

  var body: some View {
    VStack(spacing: 16) {
      Image(state.imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 223, height: 223)
      Text(state.message)
        .font(.system(size: 25, weight: .bold))
        .foregroundColor(.ypBlack)
    }
  }
}
