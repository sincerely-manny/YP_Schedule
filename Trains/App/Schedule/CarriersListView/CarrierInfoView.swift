import SwiftUI

struct CarrierInfoView: View {
  let carrier: Components.Schemas.Carrier?

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      if let carrier {
        if let urlString = carrier.logo, let url = URL(string: urlString) {
          AsyncImage(url: url) { image in
            image.resizable().aspectRatio(contentMode: .fit)
          } placeholder: {
            ProgressView()
          }
          .frame(height: 104, alignment: .center)
          .clipShape(.rect(cornerRadius: 12))
        }
        Text(carrier.title ?? "")
          .font(.system(size: 24, weight: .bold))
        VStack(alignment: .leading) {
          if let email = carrier.email, let mailto = URL(string: "mailto:\(email)") {
            VStack(alignment: .leading) {
              Text("E-mail")
              Link(destination: mailto) {
                Text(email).foregroundColor(.ypBlue).font(.system(size: 12))
              }
            }.frame(height: 60)
          }
          if let phone = carrier.phone, let phoneURL = URL(string: "tel:\(phone)") {
            VStack(alignment: .leading) {
              Text("Телефон")
              Link(destination: phoneURL) {
                Text(phone).foregroundColor(.ypBlue).font(.system(size: 12))
              }
            }.frame(height: 60)
          }
        }
      } else {
        Text("Ну удалось найти информацию о перевозчике")
          .font(.system(size: 24, weight: .bold))
      }
      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .foregroundColor(.ypBlack)
    .padding()
  }
}
