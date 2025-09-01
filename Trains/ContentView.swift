//
//  ContentView.swift
//  Trains
//
//  Created by Кирилл Серебрянный on 25.08.2025.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
    //    .onAppear {
    //      Task {
    //        do {
    //          let example = ServiceExamples()
    //          try? await example.allStationsExample()
    //          try? await example.carrierInfoExample()
    //          try? await example.copyrightExample()
    //          try? await example.nearestCityExample()
    //          try? await example.nearestStationsExample()
    //          try? await example.routeStationsExample()
    //          try? await example.scheduleBetweenStationsExample()
    //          try? await example.stationScheduleExample()
    //        }
    //      }
    //    }
  }
}

#Preview {
  ContentView()
}


