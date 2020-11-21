//
//  Login.swift
//  Login_Face_ID
//
//  Created by Arya Soni on 21/11/20.
//

import SwiftUI
import LocalAuthentication

struct Login : View {
    
    @StateObject var LoginModel = LoginViewModel()
    // when first time user logged in via email store this for future biometric login....
    @AppStorage("stored_User") var Stored_User = ""
    @AppStorage("stored_Password") var Stored_Password = ""
    
    @AppStorage("status") var logged = false
    
    @State var startAnimate = false
    
    var body: some View{
        
        ZStack{
            
            VStack{
                
                Spacer(minLength: 0)
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //Dynamic Frame...
                    .padding(.horizontal,35)
                    .padding(.vertical)
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 12, content: {
                        
                        Text("Login")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Please sign in to continue")
                            .foregroundColor(Color.white.opacity(0.5))
                    })
                    
                    Spacer(minLength: 0)
                }
                .padding()
                .padding(.leading,15)
                
                HStack{
                    
                    Image(systemName: "envelope")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 35)
                    
                    TextField("EMAIL", text: $LoginModel.email)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color.white.opacity(LoginModel.email == "" ? 0 : 0.12))
                .cornerRadius(15)
                .padding(.horizontal)
                
                HStack{
                    
                    Image(systemName: "lock")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 35)
                    
                    SecureField("PASSWORD", text: $LoginModel.password)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color.white.opacity(LoginModel.password == "" ? 0 : 0.12))
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.top)
                
                HStack(spacing: 15){
                    
                    Button(action: LoginModel.verifyUser, label: {
                        Text("LOGIN")
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 150)
                            .background(Color("green"))
                            .clipShape(Capsule())
                    })
                    .opacity(LoginModel.email != "" && LoginModel.password != "" ? 1 : 0.5)
                    .disabled(LoginModel.email != "" && LoginModel.password != "" ? false : true)
                    .alert(isPresented: $LoginModel.alert, content: {
                        Alert(title: Text("Error"), message: Text(LoginModel.alertMsg), dismissButton: .destructive(Text("Ok")))
                    })
                    
                    if LoginModel.getBioMetricStatus(){
                        
                        Button(action: LoginModel.authenticateUser, label: {
                            
                            // getting biometrictype...
                            Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color("green"))
                                .clipShape(Circle())
                        })
                    }
                }
                .padding(.top)
                
                // Forget Button...
                
                Button(action: {}, label: {
                    Text("Forget password?")
                        .foregroundColor(Color("green"))
                })
                .padding(.top,8)
                .alert(isPresented: $LoginModel.store_Info, content: {
                    Alert(title: Text("Message"), message: Text("Store Information For Future Login Using BioMetric Authentication ???"), primaryButton: .default(Text("Accept"), action: {
                        
                        // storing Info For BioMetric...
                        Stored_User = LoginModel.email
                        Stored_Password = LoginModel.password
                        
                        withAnimation{self.logged = true}
                        
                    }), secondaryButton: .cancel({
                        // redirecting to Home
                        withAnimation{self.logged = true}
                    }))
                })
                
                // SignUp...
                
                Spacer(minLength: 0)
                
                HStack(spacing: 5){
                    
                    Text("Don't have an account? ")
                        .foregroundColor(Color.white.opacity(0.6))
                    
                    Button(action: {}, label: {
                        Text("Signup")
                            .fontWeight(.heavy)
                            .foregroundColor(Color("green"))
                    })
                }
                .padding(.vertical)
            }
            .background(Color("bg").ignoresSafeArea(.all, edges: .all))
            .animation(startAnimate ? .easeOut : .none)
            
            if LoginModel.isLoading{
                
                Loading_Screen()
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.startAnimate.toggle()
            }
        })
    }
}
