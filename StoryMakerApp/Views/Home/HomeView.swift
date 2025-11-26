//
//  HomeView.swift
//  StoryMakerApp
//
//  Created by to hoang nam on 19/8/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeViewModel()
    @State private var selectedProject: MainModel? = nil
    @State var isShowPremium: Bool = true
    var isNewProject: Bool = false
    @ObservedObject var language = LanguageManager.shared

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack {
                        VStack {
                            //view tabbar
                            VStack(spacing: 25){
                                HStack{
                                    NavigationLink(destination: SettingView()) {
                                        Image("home_ictabbar")

                                    }
                                    Spacer()
                                    
                                    Text(language.currentLanguage == .english ? "Art story".uppercased(): "Bộ Sưu Tập Ảnh".uppercased())
                                        .font(.system(size: 18, weight: .bold, design: .default))
                                    Spacer()
                                    
                                    Button(action: {
                                        isShowPremium = true
                                    }, label: {
                                        Image("home_premium")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30, height: 30)
                                            .padding(.trailing,18)
                                    })
                                    
                                }
                                .padding(.horizontal,20)
                                Text(language.currentLanguage == .english ? "Recent Project" : "Dự án gần đây")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.leading,25)
                            }
                            
                            // Preview grid
                            ScrollViewReader { proxy in
                                ScrollView(.vertical, showsIndicators: false) {
                                    LazyVGrid(
                                        columns: [
                                               GridItem(.flexible(), spacing: 12),
                                               GridItem(.flexible(), spacing: 12),
                                               GridItem(.flexible(), spacing: 12)
                                           ],
                                        spacing: 16
                                    ) {
                                        ForEach(homeVM.mainprojects, id: \.id) { project in
                                            if project.previewImage != nil {
                                                ZStack(alignment: .topTrailing) {
                                                    
                                                    Button(action: {
                                                        selectedProject = project
                                                    }, label: {
                                                        if let img = project.previewImage {
                                                            Image(uiImage: img)
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: UIScreen.main.bounds.width/3.5, height: UIScreen.main.bounds.width/2)
                                                                .cornerRadius(14)
                                                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                                                        } else {
                                                            Color.gray
                                                                .frame(width: 98, height: 208)
                                                                .cornerRadius(14)
                                                        }
                                                    })
                                                    .contentShape(Rectangle())

                                                    
                                                    Menu {
                                                        Button(role: .destructive) {
                                                            homeVM.deleteProject(project)
                                                        } label: {
                                                            Label(language.currentLanguage == .english ? "Delete" : "Xoá", systemImage: "trash")
                                                        }
                                                        Button {
                                                            selectedProject = project
                                                        } label: {
                                                            Label(language.currentLanguage == .english ? "Edit" : "Chỉnh sửa", systemImage: "pencil")
                                                        }
                                                    } label: {
                                                        Image(systemName: "ellipsis.circle")
                                                            .foregroundColor(.white)
                                                            .padding(6)
                                                    }
                                                    
                                                    NavigationLink(
                                                        destination: EditorView(project: selectedProject, isNewProject: false, onDismiss: {
                                                            homeVM.loadProjects()
                                                        }),
                                                        isActive: Binding(
                                                            get: { selectedProject?.id == project.id },
                                                            set: { isActive in
                                                                if !isActive { selectedProject = nil }
                                                            }
                                                        )
                                                    ) { EmptyView() }
                                                    
                                                }
                                                .id(project.id)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .onChange(of: homeVM.mainprojects.count) { _ in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        if let id = homeVM.mainprojects.first?.id {
                                            withAnimation(.spring()) {
                                                proxy.scrollTo(id, anchor: .top)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        Spacer()
                    }
                }
                .overlay(
                    VStack(spacing:15){
                        NavigationLink(destination:
                            EditorView(project : nil,
                                       isNewProject: true,
                                       onDismiss: { homeVM.loadProjects() })
                        ) {
                            Image("home_icBtn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65, height: 65)
                                .background(.black.opacity(0.85))
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                    }
                        .padding(.bottom, 25),
                        alignment: .bottom
                )
            }
            .onAppear {
                homeVM.loadProjects()
            }
            .fullScreenCover(isPresented: $isShowPremium) {
                SubcriptionView()
            }
            .navigationBarBackButtonHidden(true)
            
            
            if homeVM.isLoading {
                LoadingOverlay()
            }
        }
    }
}


struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .blur(radius: 4)

            VStack(spacing: 14) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.6)

                Text("Loading…")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(20)
            .background(.black.opacity(0.35))
            .cornerRadius(14)
            .shadow(radius: 6)
        }
        .transition(.opacity.animation(.easeInOut(duration: 0.25)))
    }
}

