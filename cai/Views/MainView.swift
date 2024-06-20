//
//  ContentView.swift
//  cai
//
//  Created by Daniel Guarnizo on 11/04/24.
//

import SwiftUI


struct MainView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @State private var showWorkoutDetail = false
    @State private var showWorkoutName: String = ""
    
    
    // Gestures Properties
    @State var offset: CGFloat = 0
    @State var lastoffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    let defaults: UserDefaults = UserDefaults.standard
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                ZStack{
                    GeometryReader{proxy in
                        let height = proxy.frame(in: .global).height
                            
                        // Calculate opacity based on the offset value
                        let darkOpacity = min(max(1 - (offset / (height - 100)), 0), 1)
                         
                        
                        TabView {
                            HomeView()
                                .tabItem {
                                    Label("Home", systemImage: "house.fill")
                                }
                            HistoryWorkoutsView(user_id:defaults.integer(forKey: "user_id"))
                                .tabItem {
                                    Label("History", systemImage: "clock.fill")
                                }
                            StartWorkoutView(showWorkoutDetail: $showWorkoutDetail, showWorkoutName: $showWorkoutName)
                                .tabItem{
                                    Label("Start Workout", systemImage: "plus")
                                }
                                
                            
                            ListTemplateExercisesView()
                                .tabItem {
                                    Label("Exercises", systemImage: "dumbbell.fill")
                                }
                            
                            ProfileView()
                                .tabItem {
                                    Label("Profile", systemImage: "person.fill")
                                }
                                .environmentObject(viewModel)
                        }
                        .onAppear() {
                            UITabBar.appearance().backgroundColor = .white
                        }
                        
                        // Dark overlay with dynamic opacity
                        if showWorkoutDetail {
                                    Color.black
                                        .opacity(darkOpacity/2)
                                        .ignoresSafeArea()
                                }
                    }
                  
                    // Blur burron sheet
                    if showWorkoutDetail {
                        
                        GeometryReader {proxy -> AnyView in
                            
                            let height = proxy.frame(in: .global).height
                            // self.gestureOffset = -height + 150
                            let opacity = min(max((offset / (height - 100)), 0), 1)
                    
                            
                            return AnyView(
                                ZStack {
                                    VStack{                                        WorkoutDetailView(showWorkoutDetail: $showWorkoutDetail, showWorkoutName: $showWorkoutName)
                                            .clipShape(CustomCorner(corners:[.topLeft, .topRight], radius:30))
                                            .frame(maxHeight: .infinity, alignment: .top)
                                            //.padding(.top, 50)
                                    }
                                    //.padding(.top, 30)
                                    
                                }
                                    .offset(y: 0) //: (height - 100) this offset is to change the intial height of the view
                                    .offset(y: offset < 0 ? 0 : offset) // y: -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0
                                    .gesture(DragGesture().updating($gestureOffset, body: {
                                        value, out, _ in
                                        out = value.translation.height
                                        onChange()
                                    }).onEnded({ value in
                                        let maxHeight = height
                                        withAnimation{
                                            // logic condition for moving States Up, Down or Mid
                                            if offset > maxHeight/3{
                                                offset = height - 100
                                            } else {
                                                offset = 0
                                            }
                                            
                                            // Storing lastt Offset
                                            // so that the gesture can continue from the last possion..
                                            lastoffset = offset
                                        }
                                    }))
                                    .shadow(color: Color.black.opacity(opacity), radius: 10) // Apply shadow with dynamic opacity
                                    
                            )
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                        .zIndex(1)
                        
                        
                    }
                }
                
                
            } else {
                LoginView()
                    .environmentObject(viewModel)
            }
        
        }
        .onAppear {
            // Optionally, you can add some logic to check authentication status
            // For example, checking if a token exists in UserDefaults
            let defaults = UserDefaults.standard
            if let _ = defaults.string(forKey: "tokenName") {
                viewModel.isAuthenticated = true
            }
        }
    }
    
    func onChange(){
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastoffset
        }
    }
}
#Preview {
    MainView()
}



