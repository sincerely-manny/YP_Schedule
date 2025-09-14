import SwiftUI

struct StoryDetail: View {
  let allStories: [StoryData]
  @Binding var selectedStory: StoryData?
  @Binding var showModal: Bool
  @Binding var unseenStories: Set<UUID>

  @State private var progress: CGFloat = 0
  @State private var timer: Timer?
  @State private var animationID = UUID()

  private var currentIndex: Int {
    allStories.firstIndex(of: selectedStory!) ?? 0
  }

  var body: some View {
    if let story = selectedStory {
      GeometryReader { geo in
        ZStack {
          Image(story.image)
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .clipped()

          VStack(alignment: .leading, spacing: 16) {
            ProgressBar(currentIndex: currentIndex, allStories: allStories, progress: progress)
              .id(animationID)
            HStack {
              Spacer()
              Button(action: {
                showModal = false
              }) {
                Image(.close)
              }
            }
            Spacer()
            Text(story.title ?? "")
              .font(.system(size: 34, weight: .bold))
              .lineLimit(2)
              .multilineTextAlignment(.leading)
            Text(story.description ?? "")
              .font(.system(size: 20, weight: .regular))
              .lineLimit(3)
              .multilineTextAlignment(.leading)
          }
          .padding(.horizontal)
          .padding(.bottom, 40)
          .padding(.top, 28)
          .foregroundColor(.ypWhiteUniversal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ypBlackUniversal)
        .onAppear {
          startTimer()
        }
        .onDisappear {
          timer?.invalidate()
        }
        .onChange(of: selectedStory) { _, newStory in
          animationID = UUID()
          startTimer()
        }
        .gesture(
          TapGesture().onEnded {
            goToNextStory()
          })
      }
    }
  }

  private func startTimer() {
    timer?.invalidate()
    progress = 0

    if let story = selectedStory {
      unseenStories.remove(story.id)
    }

    withAnimation(.linear(duration: selectedStory?.duration ?? 0)) {
      progress = 1
    }

    timer = Timer.scheduledTimer(withTimeInterval: selectedStory?.duration ?? 0, repeats: false) {
      _ in
      goToNextStory()
    }
  }

  private func goToNextStory() {
    timer?.invalidate()
    progress = 1
    if let nextIndex = sampleStories.indices.first(where: { $0 > currentIndex }) {
      selectedStory = sampleStories[nextIndex]
    } else {
      showModal = false
    }
  }
}
