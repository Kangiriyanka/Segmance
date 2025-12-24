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
                // LazyVStack causes teleporting maybe
                VStack(spacing: 24) {
                    
                    // MARK: - GENERAL
                    
                    Section {
                        
                        NavigationLink {
                            AllRoutinesView()
                        } label: {
                            navText(title: "Routines", image: "circle.fill")
                        }
                        
                        NavigationLink {
                            AllMoveTypesView()
                        } label: {
                            navText(title: "Move Types", image: "circle.fill")
                          
                        }
                        
                    } header: {
                        HStack(spacing: 3) {
                            Group {
                                Image(systemName: "book.circle")
                                Text("Browse")
                            }
                                .customHeader()
                            
                            Spacer()
                        }
                        .padding(.bottom, 4)
                    }
                    
                    
                    Divider()
           
                    
                 
                        Section {
                            
                            NavigationLink {
                                SoundSettingsView()
                            } label: {
                                navText(title: "Countdown Sound", image: "circle.fill")
                            }
                            
                            
                            Button {
                                isExporting = true
                            } label: {
                                navText(title: "Export Routines", image: "circle.fill")
                            }
                            .buttonStyle(NavButtonStyle())

                        } header: {
                            HStack(spacing: 3) {
                                Group {
                                    Image(systemName: "square.circle")
                                    Text("Options")
                                }
                                    .customHeader()
                                
                                Spacer()
                            }
                            .padding(.bottom, 4)
                        }
                    
                    Divider()
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
                        HStack(spacing: 3) {
                            Group {
                                Image(systemName: "questionmark.circle")
                                Text("Support")
                            }
                                .customHeader()
                            
                            Spacer()
                        }
                        .padding(.bottom, 4)
                    }
                        
                        
                   
                    
                    
                }
                .buttonStyle(NavButtonStyle())
                .sheet(isPresented: $isExporting) {
                    
                    ZStack {
                        noSinBackgroundGradient.ignoresSafeArea()
                        ExportView(routines: routines)
                          
                           
                            .padding()
                            .presentationDetents([.fraction(0.35)])
                    }
                       
                    
                    
                    
                }
           
            
                .padding(.horizontal)
            }
            .contentMargins(.top, 8, for: .scrollContent)
            .contentMargins(.bottom, 16, for: .scrollContent)
            .background(backgroundGradient)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
}


#Preview {
    let container = Routine.preview
    OptionsView()

}
