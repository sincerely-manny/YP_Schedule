import SwiftUI

struct StoriesList: View {
  @State private var showModal = false
  @State private var selectedStory: StoryData?
  private let stories = sampleStories

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 20) {
        ForEach(sampleStories, id: \.id) { story in
          Button(action: {
            selectedStory = story
            showModal = true
          }) {
            Image(story.image)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 92, height: 140)
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .opacity(unseenStories.contains(story.id) ? 1 : 0.5)
              .overlay(
                RoundedRectangle(cornerRadius: 16)
                  .stroke(.ypBlue, lineWidth: unseenStories.contains(story.id) ? 4 : 0)
              ).overlay(alignment: .bottomLeading) {
                Text(story.title ?? "")
                  .font(.system(size: 12))
                  .lineLimit(3)
                  .foregroundColor(.ypWhiteUniversal)
                  .multilineTextAlignment(.leading)
                  .padding(.horizontal, 8)
                  .padding(.bottom, 12)
              }
          }
          .fullScreenCover(isPresented: $showModal) {
            StoryDetail(
              allStories: stories, selectedStory: $selectedStory, showModal: $showModal
            )
          }
        }
      }
      .frame(height: 188)
      .padding(.horizontal, 16)
    }
    .scrollIndicators(.never)
  }
}

#Preview {
  StoriesList()
}
