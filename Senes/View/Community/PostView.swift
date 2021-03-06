
//  PostView.swift
//  senes
//
//  Created by Apprenant 49 on 03/12/2021.
//

import SwiftUI


struct PostView: View {
    @EnvironmentObject private var tabController: TabController
    @ObservedObject var currentUser: CurrentUser
    @ObservedObject var postsViewModel: PostViewModel
    
    @State var description: String = "Écrit un message..."
    
    @State var sendNewPost: Bool = false
    @Binding var loaderPicture: LoaderPicture
    
    var isValid : Bool {
        return description == "Écrit un message..."
    }
    
    var colorbtnIfIsValidColor: Color {
        isValid ? .greenContent : .greenAction
    }
    
    var resizer : CGFloat {
        description != "Écrit un message..." ? 3 : 6
    }
    
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                
                VStack {
                    Button {
                        tabController.open(.profil)
                    } label: {
                        Image(currentUser.profilPic)
                            .resizable()
                        .modifierForImageWithGeo(geo: geo)
                        .padding(.top)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                
                VStack{
                    TextView(textDescription: $description)
                        .modifier(ModifierForTextView(geo: geo))
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            createNewPost()
                        } label: {
                            
                            Text("Poster")
                        }
                        .reduceDynamicSize()
                        .buttonPrincipalStyle(colorBck: Color.greenAction, foregroundColor: .white)
                        
//                        .modifierForButonWithGeo(colorBck: colorbtnIfIsValidColor, foregroundColor: .white, geo: geo)
                        .disabled(isValid)
                        
                       
                        
                        Button {
                            
                            loaderPicture.sourceType = .photoLibrary
                            loaderPicture.isImagePickerShown = true
                            
                        } label: {
                            if let sImage = loaderPicture.image {
                                sImage
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                Image(systemName: "camera.fill")
                            }
                        }
                        .reduceDynamicSize()
                        .buttonPrincipalStyle(colorBck: Color.white, foregroundColor: .black)
                        
                    }
                    .padding(.trailing)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.size.height / resizer)
        .alert(isPresented: $sendNewPost) {
            Alert(
                title: Text("✅ Envoyé !"),
                message: Text("\nVotre post a bien était envoyé sur le fil")
            )
        }
    }
    
    func createNewPost() {
        var newPost = Post()
        newPost.userID = String(currentUser.id)
        newPost.postImage = "" /*loaderPicture.image*/
        newPost.description = description
        postsViewModel.addPost(newPost)
        
        sendNewPost = true
        
        description = "Écrit un message..."
        loaderPicture.image = nil
        UIApplication.shared.endEditing()
    }
    
}

struct PostView_Previews: PreviewProvider {
    static var posts: [Post] = Bundle.main.decode([Post].self, from: "posts.json", dateDecodingStrategy: .iso8601)

    static var previews: some View {
        PostView(
            currentUser: CurrentUser(), postsViewModel: PostViewModel(),
            loaderPicture: .constant(LoaderPicture(
                isImagePickerShown: false,
                sourceType: UIImagePickerController.SourceType.photoLibrary))
        )
        
    }
}
