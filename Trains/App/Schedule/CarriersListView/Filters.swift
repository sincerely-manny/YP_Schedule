import Foundation

enum TimeFilter: String, CaseIterable {
  case morning = "Утро 06:00 - 12:00"
  case afternoon = "День 12:00 - 18:00"
  case evening = "Вечер 18:00 - 00:00"
  case night = "Ночь 00:00 - 06:00"

  func matches(_ strtime: String) -> Bool {
    guard let time = TimeFilter.timeFormatter.date(from: strtime) else { return false }
    switch self {
    case .morning:
      return time >= Date(timeIntervalSince1970: 6 * 60 * 60)
        && time <= Date(timeIntervalSince1970: 12 * 60 * 60)
    case .afternoon:
      return time >= Date(timeIntervalSince1970: 12 * 60 * 60)
        && time <= Date(timeIntervalSince1970: 18 * 60 * 60)
    case .evening:
      return time >= Date(timeIntervalSince1970: 18 * 60 * 60)
        && time <= Date(timeIntervalSince1970: 24 * 60 * 60)
    case .night:
      return time >= Date(timeIntervalSince1970: 0)
        && time <= Date(timeIntervalSince1970: 6 * 60 * 60)
    }
  }
}

extension TimeFilter {
  static let timeFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.defaultDate = Date(timeIntervalSince1970: 0)

    return formatter
  }()
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
