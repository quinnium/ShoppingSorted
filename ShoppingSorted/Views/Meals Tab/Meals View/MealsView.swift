//
//  MealsView.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/08/2023.
//

import SwiftUI

struct MealsView: View {
    
    @StateObject private var vm = MealsViewModel()
    
    var body: some View {
        
        NavigationStack {
            List(selection: $vm.selectedMeals) {
                ForEach(vm.filteredMealsList, id: \.id) { meal in
                    Button {
                        if let meal = vm.getMeal(id: meal.id) {
                            vm.selectedMeal = meal
                        }
                    } label: {
                        Text(meal.name)
                            .foregroundStyle(Color(uiColor: .label))
                    }
                }
            }
            .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search")
            .listStyle(.insetGrouped)
            .environment(\.editMode, .constant(vm.isSelecting ? EditMode.active : EditMode.inactive)).animation(.spring, value: vm.isSelecting)
            .blur(radius: (vm.isAddingMeal) ? 2 : 0)
            .overlay(content: {
                if vm.isAddingMeal {
                    MealsViewAddMealView(vm: vm)
                }
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if vm.isSelecting {
                        Button("Cancel") {
                            vm.isSelecting = false
                        }
                    } else {
                        Menu {
                            Menu {
                                Button("A > Z (Alphabetically)") {
                                    print("a to z")
                                    vm.sortOrder = .alphabetical
                                }
                                Button("by Date") {
                                    print("by date")
                                    vm.sortOrder = .chronological
                                }
                            } label: {
                                Label("Sort Meals", systemImage: "")
                            }

                            Button("Export / Delete") {
                                vm.isSelecting = true
                            }
                            Button("Import") {
                                vm.isShowingImporter = true
                            }
                        } label: {
                            Label("More", systemImage: "ellipsis")
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.isAddingMeal = true
                    } label: {
                        Label("Add Meal", systemImage: "plus")
                    }
                    .disabled(vm.isSelecting)
                }
            }
            .navigationTitle("Meals")
            .navigationDestination(item: $vm.selectedMeal, destination: { meal in
                MealDetailView(meal: meal)
            })
            .navigationBarTitleDisplayMode(.automatic)
            .onAppear {
                vm.fetchMeals()
            }
        }
        .fileImporter(isPresented: $vm.isShowingImporter, allowedContentTypes: [.json], onCompletion: { result in
            switch result {
                case .success(let url):
                    self.vm.importMealsFrom(from: url)
                case .failure(_):
                    // TODO: handle failure?
                    print("Failure")
            }
        })
        .fileMover(isPresented: $vm.isShowingExporter, file: vm.urlForExportableDocument, onCompletion: { _ in self.vm.isSelecting = false })
        .overlay(alignment: .bottom) {
            if vm.isSelecting {
                MealSelectionOptionsView(vm: vm)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.linear(duration: 0.1), value: vm.isSelecting)
    }
}


struct MealsView_Previews: PreviewProvider {
    static var previews: some View {
        MealsView()
    }
}
