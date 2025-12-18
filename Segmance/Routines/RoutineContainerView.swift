//
//  RoutineContainerView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/12.
//

import SwiftUI
import SwiftData

struct RoutineContainerView: View {
    
    @Environment(\.modelContext)  var modelContext
    @State private var showingUploadRoutineSheet: Bool = false
    @State private var showingConfirmation: Bool = false
    @State private var searchText: String = ""
    @State private var routinePendingDeletion: Routine? = nil
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Routine.title) var routines: [Routine]
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("gridMode") private var gridMode: GridMode = .list

    
    var filteredRoutines: [Routine] {
        if searchText.isEmpty {
            return routines
        }
        return routines.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    enum GridMode: String, CaseIterable {
            case list, grid2, grid3
            
            var columns: [GridItem] {
                switch self {
                case .list: return []
                case .grid2: return [GridItem(.adaptive(minimum: 140), spacing: 15)]
                case .grid3: return [GridItem(.adaptive(minimum: 100), spacing: 15)]
                }
            }
            
            var icon: String {
                switch self {
                case .list: return "rectangle.grid.1x2"
                case .grid2: return "square.grid.2x2"
                case .grid3: return "square.grid.3x2"
                }
            }
            
            mutating func cycle() {
                let all = Self.allCases
                self = all[(all.firstIndex(of: self)! + 1) % all.count]
            }
        }
  
    
    var body: some View {
        
        NavigationStack {
            
            
            
            VStack {
                
                HStack(spacing: 10) {
                    Spacer()
                    CustomSearchBar(
                        text: $searchText,
                        placeholder: "Search routines"
                    )
                    
                    .contentShape(Rectangle())
                    
                    
                    
                    HStack {
                        addRoutineButton
                        viewModeButton
                    }
                    
                    Spacer()
                    
                }
               
                .frame(maxWidth: .infinity)
                .offset(y: -15)
                .sheet(isPresented: $showingUploadRoutineSheet) {
                    UploadRoutineView()
                        .background(noSinBackgroundGradient.opacity(0.9))
                }
                
                
                
                
                
                
                Group {
                    if filteredRoutines.isEmpty {
                        
                        ContentUnavailableView {
                            Label("No routines found", systemImage: "music.quarternote.3")
                        } description: {
                            Text("Add one by tapping the \(Image(systemName: "figure.dance")) button.").padding([.top], 5)
                        }
                        
                        
                        
                        
                    }
                    else {
                        
                        
                        ScrollView(showsIndicators: false) {
                            ScrollViewReader { proxy in
                                Group {
                                    switch gridMode {
                                    case .list:
                                        LazyVStack(spacing: 10) {
                                            ForEach(filteredRoutines) { routine in
                                                NavigationLink(destination: RoutineView(routine: routine)
                                                    .navigationBarBackButtonHidden(true)) {
                                                        RoutineCardView(routine: routine)
                                                }
                                                .buttonStyle(NavButtonStyle())
                                            }
                                        }
                             
                                        
                                    case .grid2, .grid3:
                                        LazyVGrid(columns: gridMode.columns, spacing: 15) {
                                            ForEach(filteredRoutines) { routine in
                                                NavigationLink(destination: RoutineView(routine: routine)
                                                    .navigationBarBackButtonHidden(true)) {
                                                        CompactRoutineCard(routine: routine, gridMode: gridMode.rawValue)
                                                }
                                                .buttonStyle(NavButtonStyle())
                                            }
                                        }
                                     
                                    }
                                }
                                .id("scrollTop")
                                .onChange(of: gridMode) { _, _ in
                                    withAnimation(Animation.smoothReorder) {
                                        proxy.scrollTo("scrollTop", anchor: .top)
                                    }
                                }
                            }
                        }
                        .animation(.smoothReorder, value: gridMode)
                        .contentMargins(.bottom, 50, for: .scrollContent)

                        
                    }
                    
                }
                .padding()


                .navigationTitle("Routines")
                .ignoresSafeArea(.keyboard)
                .navigationBarTitleDisplayMode(.inline)
                
                
                
                
                
            }
            .background(
                backgroundGradient
            )

            
            
            
            
        }
    }
        
        
        private var addRoutineButton: some View {
            Button {
                showingUploadRoutineSheet.toggle()
            } label: {
                Image(systemName: "figure.dance")
                
                
                
            }
            
            .buttonStyle(PressableButtonStyle())
            .contentShape(Rectangle())
            
            
        }
        
        
        private var viewModeButton: some View {
            Button {
                withAnimation(.smoothReorder) {
                    gridMode.cycle()
                    
                }
            } label: {
                Image(systemName: {
                    switch gridMode {
                    case .list: return "rectangle.grid.1x2"
                    case .grid2: return "square.grid.2x2"
                    case .grid3: return "square.grid.3x2"
                    }
                }())
                .frame(width: 10)
            }
            .buttonStyle(PressableButtonStyle())
            .contentShape(Rectangle())
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    struct CompactRoutineCard: View {
        let routine: Routine
        let gridMode: String
        
        var body: some View {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.accent.opacity(0.15))
                        .frame(width: gridMode == "grid2" ? 40: 30, height: gridMode == "grid2" ? 40: 30)
                    
                    Image(systemName: "music.note")
                        .foregroundStyle(.accent.opacity(0.7))
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(width: 40, height: 40)
                
                Text(routine.title)
                    .font(gridMode == "grid2" ? .subheadline : .footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.mainText)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .truncationMode(.tail)
            }
            
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: 110, alignment: .top)
            .background(routineCardBackground)
            
            .customBorderStyle()
            
        }
    }
    
    
    struct RoutineCardView: View {
        
    
        let routine: Routine
        
        var body: some View {
            
            
            
            
            HStack(spacing: 12) {
                
                ZStack {
                    Circle()
                        .fill(Color.accent.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "music.note")
                        .foregroundStyle(.accent.opacity(0.7))
                        .font(.system(size: 20, weight: .semibold))
                    
                    
                    
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(routine.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Color.mainText)
                    
                    Text(routine.routineDescription)
                        .font(.footnote)
                        .foregroundStyle(Color.mainText.opacity(0.6))
                        .lineLimit(2)
                        .offset(y: -8)
                    
                    
                }
                .frame(height: 50)
                
                Spacer()
                
                
                
                
            }
            
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(routineCardBackground)
            .customBorderStyle()
            
            
        }
    }
    
    
    
    
    #Preview {
        let container = Routine.preview
        
        RoutineContainerView()
            .modelContainer(container)
    }
    
    #Preview {
        
        RoutineContainerView()
        
        
    }
    
    







