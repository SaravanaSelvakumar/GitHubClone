//
//  ContentView.swift
//  GithubClone
//
//  Created by Manikandan Arumugam on 16/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var alertViewModel = AlertViewModel()
    @State private var showSplash = true
    var body: some View {
        Group {
            if showSplash {
                SplashScreen()
                    .environmentObject(alertViewModel)
            } else {
                HomeView()
                    .environmentObject(alertViewModel)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
