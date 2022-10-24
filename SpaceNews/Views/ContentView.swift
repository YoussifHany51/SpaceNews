//
//  ContentView.swift
//  SpaceNews
//
//  Created by Youssif Hany on 23/10/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var data = SpaceAPI()
    @State private var opacity = 0.0
    
    var body: some View {
        NavigationStack {
            VStack{ 
                NewsView()
                    .opacity(opacity)
            }
            .navigationTitle("Space News")
            .environmentObject(data)
            .onAppear{
                data.getData()
                withAnimation(.easeIn(duration: 2)) {
                    opacity = 1.0
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
