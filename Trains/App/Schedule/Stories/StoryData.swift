import SwiftUI

struct StoryData: Identifiable, Equatable {
  let id = UUID()
  let title: String?
  let description: String?
  let image: ImageResource
  let duration: TimeInterval = 5
}

let sampleStories: [StoryData] = [
  StoryData(
    title: "Text Text Text Text Text Text Text Text Text Text",
    description:
      "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
    image: .story1),
  StoryData(
    title: "Text Text Text Text Text Text Text Text Text Text",
    description:
      "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
    image: .story2),
  StoryData(
    title: "Text Text Text Text Text Text Text Text Text Text",
    description:
      "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
    image: .story3),
  StoryData(
    title: "Text Text Text Text Text Text Text Text Text Text",
    description:
      "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
    image: .story4),
]
