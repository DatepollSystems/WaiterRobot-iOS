//
//  ContentView.swift
//  WaiterRobot
//
//  Created by Fabian Schedler on 22.11.22.
//

import SwiftUI
import shared

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Test")
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
