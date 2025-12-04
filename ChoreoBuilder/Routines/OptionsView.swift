//
//  ExportView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/04/15.
//

import SwiftUI
import SwiftData


struct OptionsView: View {
    
    @Query(sort: \Routine.title) var routines: [Routine]
    @State private var isExporting: Bool = false
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    
                    // MARK: - GENERAL
                    
                    Section {
                        
                        NavigationLink {
                            AllRoutinesView()
                        } label: {
                            navText(title: "Choreographies", image: "circle.fill")
                        }
                        
                        NavigationLink {
                            AllMoveTypesView()
                        } label: {
                            navText(title: "Move Types", image: "circle.fill")
                          
                        }
                        
                    } header: {
                        HStack {
                            Text("Library")
                                .customHeader()
                            
                            Spacer()
                        }
                        .padding(.bottom, 4)
                    }
                    
                    
                    Divider()
                    // MARK: - ABOUT
                    
                    Section {
                        
                        NavigationLink {
                            UsageGuideView()
                        } label: {
                            navText(title: "Usage Guide", image: "circle.fill")
                        }
                        
                        
                        
                        NavigationLink {
                            AboutView()
                        } label: {
                            navText(title: "About", image: "circle.fill")
                        }
                        
                    } header: {
                        HStack {
                            Text("Support")
                                .customHeader()
                            
                            Spacer()
                        }
                        .padding(.bottom, 4)
                    }
                    
                    Divider()
                    
                    // MARK: - EXPORT
                    
                 
                        Section {
                            
                            NavigationLink {
                                SoundSettingsView()
                            } label: {
                                navText(title: "Sound Settings", image: "circle.fill")
                            }
                            
                            
                            Button {
                                isExporting = true
                            } label: {
                                navText(title: "Export", image: "circle.fill")
                            }
                            .buttonStyle(NavButtonStyle())

                        } header: {
                            HStack {
                                Text("Extras")
                                    .customHeader()
                                Spacer()
                            }
                            .padding(.bottom, 4)
                        }
                        
                        
                   
                    
                    
                }
                .buttonStyle(NavButtonStyle())
                .sheet(isPresented: $isExporting) {
                    
                    ZStack {
                        backgroundGradient.ignoresSafeArea()
                        ExportView(routines: routines)
                          
                            .background(shadowOutline)
                            .padding()
                            .presentationDetents([.fraction(0.25)])
                    }
                       
                    
                    
                    
                }
           
            
                .padding(.horizontal)
            }
            .contentMargins(.top, 8, for: .scrollContent)
            .contentMargins(.bottom, 16, for: .scrollContent)
            .scrollContentBackground(.hidden)
            .background(backgroundGradient)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
}


#Preview {
    let container = Routine.preview
    OptionsView()
//        .modelContainer(container)
}
