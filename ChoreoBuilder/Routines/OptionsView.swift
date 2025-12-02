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
                            HStack(spacing: 10) {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(.accent).opacity(0.7)
                                    .font(.system(size: 8, weight: .semibold))
                                
                                Text("My choreographies")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(Color.mainText)
                                
                                Spacer()
                            }
                            .bubbleStyle()
                        }
                        
                        NavigationLink {
                            AllMoveTypesView()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(.accent).opacity(0.7)
                                    .font(.system(size: 8, weight: .semibold))
                                
                                Text("My move types")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(Color.mainText)
                                
                                Spacer()
                            }
                            .bubbleStyle()
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
                            HStack(spacing: 10) {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(.accent).opacity(0.7)
                                    .font(.system(size: 8, weight: .semibold))
                                
                                Text("Usage Guide")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(Color.mainText)
                                
                                Spacer()
                            }
                            .bubbleStyle()
                        }
                        
                        
                        
                        NavigationLink {
                            AboutView()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(.accent).opacity(0.7)
                                    .font(.system(size: 8, weight: .semibold))
                                
                                Text("About ChoreoBuilder")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(Color.mainText)
                                
                                Spacer()
                            }
                            .bubbleStyle()
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
                            Button {
                                isExporting = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(.accent)
                                        .opacity(0.7)
                                        .font(.system(size: 8, weight: .semibold))

                                    Text("Export")
                                        .font(.headline.weight(.semibold))
                                        .foregroundStyle(Color.mainText)

                                    Spacer()
                                }
                                .bubbleStyle()
                            }
                            .buttonStyle(NavButtonStyle())

                        } header: {
                            HStack {
                                Text("Data ")
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
        .modelContainer(container)
}
