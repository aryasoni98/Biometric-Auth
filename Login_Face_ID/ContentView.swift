//
//  Login.swift
//  Login_Face_ID
//
//  Created by Arya Soni on 21/11/20.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @AppStorage("status") var logged = false
    var body: some View {

        NavigationView{
            
            if logged{
                
                Home()
                    .navigationTitle("Home")
                    .navigationBarHidden(false)
                    .preferredColorScheme(.light)
            }
            else{
                
                Login()
                    .preferredColorScheme(.dark)
                    .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
