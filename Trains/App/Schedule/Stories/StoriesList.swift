import SwiftUI

struct StoriesList: View {
  @State private var showModal = false
  @State private var selectedStory: StoryData?
  private let stories = sampleStories
  @State private var unseenStories: Set<UUID> = Set(sampleStories.map(\.id))

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
              .overlay {
                if unseenStories.contains(story.id) {
                  RoundedRectangle(cornerRadius: 16)
                    .stroke(.ypBlue, lineWidth: 4)
                }
              }.overlay(alignment: .bottomLeading) {
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
              allStories: stories,
              selectedStory: $selectedStory,
              showModal: $showModal,
              unseenStories: $unseenStories
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
