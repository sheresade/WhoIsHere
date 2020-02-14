//
//  WelcomeView.swift
//  FirebaseLogin
//
//  Created by Mavis II on 9/2/19.
//  Copyright © 2019 Bala. All rights reserved.
//


import SwiftUI
import Firebase

public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
struct SignOutButton: View {
    @Binding var MainviewState: CGSize
    @Binding var viewState: CGSize

    var body: some View {
        Button(action: {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                ObservableModel.shared.connected = false
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }

            self.MainviewState = CGSize(width: screenWidth, height: 0)
            self.viewState = CGSize(width: 0, height: 0)

        }, label: {
            Text("Sign Out")
                .foregroundColor(Color.white)
                .padding()
        })
        .background(Color.green)
        .cornerRadius(5)
    }
}
/*
struct InsideButton: View {
    @Binding var MainviewState: CGSize
    @Binding var viewState: CGSize

    var body: some View {
        Button(action: {
            Student.init(name: String, login: <#T##String#>, image: <#T##UIImage#>)

        }, label: {
            Text("Je suis là")
                .foregroundColor(Color.white)
                .padding()
        })
        .background(Color.green)
        .cornerRadius(5)
    }
}*/


struct DefaultImageView: View {
    @State var imageDefault: Image = Image(systemName: "person")

    var body: some View {
        VStack {
            imageDefault.resizable()
            .frame(width: 250, height: 200)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
        }
        
    }
}

struct UserImageView: View {
    @Binding var image: Image?
       var body: some View {
           VStack {
               image?.resizable()
               .frame(width: 250, height: 200)
               .clipShape(Circle())
               .overlay(Circle().stroke(Color.white, lineWidth: 4))
               .shadow(radius: 10)
           }
           
       }
}

struct CreateStudentView: View {
    @State var studentName: String = ""
    @State var studentLogin: String = ""
    @State var image: Image? = nil
    @State var uiImage: UIImage? = nil
    @State var showCaptureImageView: Bool = false
    @ObservedObject var model = ObservableModel.shared

    var body: some View {
        VStack {
            VStack {
                AppTitleView(Title: "", Subtitle: "Create student")

                VStack{
                    if (image == nil) {
                       DefaultImageView()
                       
                   }else{
                       UserImageView(image: $image)
                   }
                   Button(action: {
                       self.showCaptureImageView.toggle()
                   }) {
                       Text("Choose photo")
                   }
                   if (showCaptureImageView) {
                       CaptureImageView(
                           isShown: $showCaptureImageView,
                           image: $image,
                           uiImage: $uiImage
                       )
                   }
                }
               
                VStack {
                    
                    TextField("Student name", text: $studentName)
                    Text(self.model.emailStudent!)
                    
                }
                .padding(10)
                Button(action: {
                    guard let uiImage = self.uiImage else { return }
                    
                    print("\(self.studentName)")
                    print("\(self.studentLogin)")
                    WhoisHere.createdStudent(
                        name: self.studentName,
                        login: self.model.emailStudent!,
                        image: uiImage
                    )
                }, label: {
                    Text("Create Student")
                        .foregroundColor(Color.white)
                        .padding()
                })
                    .background(Color.green)
                    .cornerRadius(5)
            }
        }
    }
}


struct AuthenticatedView: View {
    @Binding var MainviewState: CGSize
    @Binding var viewState: CGSize

    @ObservedObject var model = ObservableModel.shared

    var body: some View {
        VStack{
           AppTitleView(Title: "",Subtitle: "Home")
      //     Text("Hello World!")ForEach

            List(model.students) { (student) in
                HStack {
                    Image(uiImage: student.image)
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)

                    Text(student.name)
                }
            }
            Spacer()

        }
        .edgesIgnoringSafeArea(.top).background(Color.white)
        .offset(x: self.MainviewState.width).animation(.spring())
    }
}


struct SigningView: View {
    @Binding var MainviewState: CGSize
    @Binding var viewState: CGSize

    @State var signUpIsPresent: Bool = false
    @State var signInIsPresent: Bool = false

    var body: some View {

        VStack {
            AppTitleView(Title: "Welcome", Subtitle: "")
            Spacer()
            VStack(spacing:20) {

                Button(action: {self.signUpIsPresent = true}){
                    Text("Sign Up")
                }.sheet(isPresented: self.$signUpIsPresent){
                    SignUpView()
                }

                Button(action: {self.signInIsPresent = true}){
                    Text("Sign In")
                }.sheet(isPresented: $signInIsPresent) {

                SignInView(onDismiss:{
                    self.viewState = CGSize(width: screenWidth, height: 0)
                    self.MainviewState = CGSize(width: 0, height: 0)
                })}}
            
                Spacer()

        }
        .edgesIgnoringSafeArea(.top).edgesIgnoringSafeArea(.bottom)
        .offset(x:self.viewState.width).animation(.spring())
    }
}


struct WelcomeView: View {
    @Binding var connected: Bool

    @State var viewState = CGSize.zero
    @State var MainviewState =  CGSize.zero
    @ObservedObject var model = ObservableModel.shared
    
    var body: some View {
        VStack {
            if (connected) {
                VStack {

                    CreateStudentView()
                    Spacer()
                    SignOutButton(MainviewState: $MainviewState, viewState: $viewState)
                    
                }
            } else {
                SigningView(MainviewState: $MainviewState, viewState: $viewState)
            }
            Spacer()
            Button(action: {
                //self.model.inside.toggle()
                
                CloudStorage.Students.set(inside: self.model.inside, login: self.model.emailStudent!)
                
            }){
                if(self.model.inside){
                    Text("Text OutSide")
                }else{
                    Text("Test inside")

                }
            }
            
        }
        .tabItem {
            VStack {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
        .tag(1)
    }
}





//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView(connected: true)
//    }
//}
