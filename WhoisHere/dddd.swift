//
//  WelcomeView.swift
//  FirebaseLogin
//
//  Created by Mavis II on 9/2/19.
//  Copyright © 2019 Bala. All rights reserved.
//


import SwiftUI
import Firebase

//
//struct SignOutButton: View {
//    @Binding var MainviewState: CGSize
//    @Binding var viewState: CGSize
//
//    var body: some View {
//
//        NavigationView {
//            VStack {
//                CreateStudentView()
//            }
//          //      .navigationBarTitle("Welcome")*/
//                .navigationBarItems(trailing:
//                    Button(action: {
//                        let firebaseAuth = Auth.auth()
//                        do {
//                            try firebaseAuth.signOut()
//                            ObservableModel.shared.connected = false
//                        } catch let signOutError as NSError {
//                            print ("Error signing out: %@", signOutError)
//                        }
//
//                        self.MainviewState = CGSize(width: screenWidth, height: 0)
//                        self.viewState = CGSize(width: 0, height: 0)
//
//                    }, label: {
//                        Text("Sign Out")
//                            .foregroundColor(Color.white)
//                            .padding()
//                    })
//                    .background(Color.green)
//                    .cornerRadius(5)
//                )
//        }
//
//    }
//}
//
//
//struct DefaultImageView: View {
//    var body: some View {
//    }
//}
//
//struct UserImageView: View {
//    @Binding image: Image
//    var body: some View {
//
//    }
//}
//
//struct CreateStudentView: View {
//    @State var studentName: String = ""
//    @State var studentLogin: String = ""
//    @State var image: Image? = nil
//    @State var imageDefaut: Image? = Image(systemName: "person")
//
//
//    @State var uiImage: UIImage? = nil
//    @State var showCaptureImageView: Bool = false
//
//    var body: some View {
//        VStack {
//            VStack {
//                Button(action: {
//                    self.showCaptureImageView.toggle()
//                }) {
//                    HStack{
//                        VStack{
//                            imageDefaut?
//                                .resizable()
//                            .frame(width: 250, height: 200)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.black, lineWidth: 4))
//                            .shadow(radius: 10)
//                            .accentColor(.black)
//                             .padding(10)
//
//                            Text("Choose photos")
//                        }
//
//
//
//                   }
//            //    VStack {
////                    if (image == nil) {
////                        VStack{
////                            imageDefaut?
////                                .resizable()
////                            .frame(width: 250, height: 200)
////                            .clipShape(Circle())
////                            .overlay(Circle().stroke(Color.black, lineWidth: 4))
////                            .shadow(radius: 10)
////                            .accentColor(.black)
////                             .padding(10)
////
////                            Text("Choose photos")
////                        }
////                    } else {
////                        VStack{
////
////                        image!.resizable()
////                            .frame(width: 250, height: 200)
////                            .clipShape(Circle())
////                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
////                            .shadow(radius: 10)
////                        }
////                    }
//          //      }
//                image?.resizable()
//                    .frame(width: 250, height: 200)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                    .shadow(radius: 10)
//            }
//            if (showCaptureImageView) {
//
//                CaptureImageView(
//                    isShown: $showCaptureImageView,
//                    image: $image,
//                    uiImage: $uiImage
//                )
//
//            }
//            VStack {
//                TextField("Student name", text: $studentName)
//                TextField("user@domain.com", text: $studentLogin)
//            }
//            .padding(10)
//            Button(action: {
//                guard let uiImage = self.uiImage else { return }
//
//                print("\(self.studentName)")
//                print("\(self.studentLogin)")
//                WhoisHere.createdStudent(
//                    name: self.studentName,
//                    login: self.studentLogin,
//                    image: uiImage
//                )
//
//            }, label: {
//                Text("Create Student")
//                    .foregroundColor(Color.white)
//                    .padding()
//            })
//                .background(Color.green)
//                .cornerRadius(5)
//        }
//        }
//    }
//}
//
//
//struct AuthenticatedView: View {
//    @Binding var MainviewState: CGSize
//    @Binding var viewState: CGSize
//
//    @ObservedObject var model = ObservableModel.shared
//
//    var body: some View {
//        VStack{
//            AppTitleView(Title: "Home")
//            Spacer()
//            Text("Hello World!")
//            Spacer()
//
//            List(model.students) { (student) in
//                HStack {
//                    Image(uiImage: student.image)
//                        .resizable()
//                        .frame(width: 40.0, height: 40.0)
//                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
//
//                    Text(student.name)
//                }
//            }
//
//        }
//        .edgesIgnoringSafeArea(.top).background(Color.white)
//        .offset(x: self.MainviewState.width).animation(.spring())
//    }
//}
//
//
//struct SigningView: View {
//    @Binding var MainviewState: CGSize
//    @Binding var viewState: CGSize
//
//    @State var signUpIsPresent: Bool = false
//    @State var signInIsPresent: Bool = false
//
//    var body: some View {
//
//        VStack {
//            AppTitleView(Title: "Welcome")
//            Spacer()
//            VStack(spacing:20) {
//
//                Button(action: {self.signUpIsPresent = true}){
//                    Text("Sign Up")
//                }.sheet(isPresented: self.$signUpIsPresent){
//                    SignUpView()
//                }
//
//                Button(action: {self.signInIsPresent = true}){
//                    Text("Sign In")
//                }.sheet(isPresented: $signInIsPresent) {
//
//                SignInView(onDismiss:{
//                    self.viewState = CGSize(width: screenWidth, height: 0)
//                    self.MainviewState = CGSize(width: 0, height: 0)
//                })}}
//
//                Spacer()
//
//        }
//        .edgesIgnoringSafeArea(.top).edgesIgnoringSafeArea(.bottom)
//        .offset(x:self.viewState.width).animation(.spring())
//    }
//}
//
//
//struct WelcomeView: View {
//    @Binding var connected: Bool
//
//    @State var viewState = CGSize.zero
//    @State var MainviewState =  CGSize.zero
//
//    var body: some View {
//        ZStack{
//            if (connected) {
//                VStack {
//                    SignOutButton(MainviewState: $MainviewState, viewState: $viewState)
//                 //   CreateStudentView()
//
//                }
//            } else {
//                SigningView(MainviewState: $MainviewState, viewState: $viewState)
//            }
//        }
//        .tabItem {
//            VStack {
//                Image(systemName: "gear")
//                Text("Settings")
//            }
//        }
//        .tag(1)
//    }
//}
//
//
//
////struct WelcomeView_Previews: PreviewProvider {
////    static var previews: some View {
////        WelcomeView(connected: true)
////    }
////}
