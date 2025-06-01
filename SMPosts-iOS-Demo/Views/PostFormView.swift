//
//  PostFormView.swift
//  SMPosts-iOS-Demo
//
//  Created by Salah Eddine KAHACK on 30/05/2025.
//

import SwiftUI


struct PostFormView: View {
    
    // MARK: - Properties
    
    var onSubmit: (String, String) -> Void
    
    @State private var title: String = ""
    @State private var content: String = ""
    @FocusState private var isFirstTextFieldFocused: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - UI

    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text(Constants.Texts.PostForm.titleLabelText)) {
                    TextField(
                        Constants.Texts.PostForm.titlePlaceholderText,
                        text: $title
                    )
                    .focused($isFirstTextFieldFocused)
                }
                
                Section(header: Text(Constants.Texts.PostForm.contentLabelText)) {
                    TextEditor(text: $content)
                    .frame(height: Constants.Sizes.PostForm.contentTextViewHeight)
                }
            }
            .navigationTitle(Constants.Texts.PostForm.title)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Constants.Texts.PostForm.cancelButtonTitle) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Constants.Texts.PostForm.submitButtonTitle) {
                        onSubmit(title, content)
                    }
                }
            }
        }
        .onAppear {
            isFirstTextFieldFocused = true
        }
    }
}

// MARK: - Preview

#Preview {
    PostFormView(
        onSubmit: { postTitle , postContent in
            Logger.log(
                "Preview PostFormView onSubmit called. \nTitle: \(postTitle)\nContent: \(postContent)",
                level: .debug
            )
        }
    )
}
