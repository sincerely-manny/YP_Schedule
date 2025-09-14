import SwiftUI

struct ProgressBar: View {
  var currentIndex: Int
  var allStories: [StoryData]
  var progress: CGFloat

  var body: some View {
    HStack(spacing: 6) {
      ForEach(Array(allStories.enumerated()), id: \.element.id) { index, story in
        GeometryReader { geometry in
          ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3)
              .fill(.ypWhiteUniversal)
            RoundedRectangle(cornerRadius: 3)
              .fill(.ypBlue)
              .frame(width: getBarLength(for: index, geometry: geometry))
          }
        }
        .frame(height: 6)
      }
    }
  }

  private func getBarLength(for index: Int, geometry: GeometryProxy) -> CGFloat {
    var width: CGFloat
    if index < currentIndex {
      width = geometry.size.width
    } else if index == currentIndex {
      width = progress * geometry.size.width
    } else {
      width = 0
    }
    return width
  }
}
