//
//  ContentView.swift
//  WhoisHere
//
//  Created by carolyne on 07/02/2020.
//  Copyright © 2020 carolyne. All rights reserved.

import SwiftUI
import Firebase

struct ContentView: View {
    @State var selection = (Auth.auth().currentUser == nil) ? 1 : 0
    @ObservedObject var model = ObservableModel.shared
 
    var body: some View {
        TabView(selection: $selection){
            StudentsView(connected: $model.connected)
            WelcomeView(connected: $model.connected)
        }
    }
}


struct StudentsView: View {
    @Binding var connected: Bool
    
    @State var viewState = CGSize.zero
    @State var MainviewState =  CGSize.zero

    var body: some View {
        ZStack {
//            Color.blue.edgesIgnoringSafeArea(.all)
            if (connected) {
                AuthenticatedView(
                    MainviewState: $MainviewState,
                    viewState: $viewState
                )
            } else {
                Text("Please sign in")
            }
        }
        .tabItem {
            VStack {
                Image(systemName: "person.3")
                Text("Students")
            }
        }
        .tag(0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
