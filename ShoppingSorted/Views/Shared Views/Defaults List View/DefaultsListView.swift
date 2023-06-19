//
//  DefaultsListView.swift
//  ShoppingSorted
//
//  Created by Quinn on 19/05/2023.
//

import SwiftUI

struct DefaultsListView: View {
    
    @State var editmode: EditMode = .active
    @StateObject var vm = DefaultsListViewModel()
    @Binding var isEditingTypes: Bool
    @FocusState var aisleTextFieldInFocus: Bool
    @FocusState var unitTextFieldInFocus: Bool
    
    init(isEditingTypes: Binding<Bool>) {
        self._isEditingTypes = isEditingTypes
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    Text("Editing defaults will not affect existing Ingredients / Shopping List items")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .edgesIgnoringSafeArea(.all)
                        .listRowBackground(Color(uiColor: .secondarySystemBackground))

                    Section("Aisles") {
                        ForEach($vm.aisles.indices, id: \.self) { aisleIndex in
                            TextField("Aisle", text: $vm.aisles[aisleIndex])
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .focused($aisleTextFieldInFocus)
                        }
                        .onDelete(perform: vm.deleteAisle)
                        .onMove(perform: vm.moveAisle)
                        Button("+ New") {
                            vm.addNewAisle()
                        }
                        .id(vm.addAisleID)
                    }
                    Section("Units") {
                        ForEach($vm.units.indices, id: \.self) { unitIndex in
                            TextField("Unit", text: $vm.units[unitIndex])
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .focused($unitTextFieldInFocus)
                        }
                        .onDelete(perform: vm.deleteUnit)
                        .onMove(perform: vm.moveUhits)
                        Button("+ New") {
                            vm.addNewUnit()
                        }
                        .id(vm.addUnitID)
                    }
                }
                
                .onChange(of: vm.aisles.count) { _ in proxy.scrollTo(vm.addAisleID, anchor: .bottom) }
                .onChange(of: vm.units.count) { _ in proxy.scrollTo(vm.addUnitID, anchor: .bottom) }
            }
            .environment(\.editMode, $editmode)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isEditingTypes = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        vm.saveItems()
                        isEditingTypes = false
                    }
                    .fontWeight(.bold)
                    .foregroundColor(vm.isValidToSave ? .blue : .gray)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        aisleTextFieldInFocus = false
                        unitTextFieldInFocus = false
                    } label: {
                        Label("Dismiss", systemImage: "keyboard.chevron.compact.down")
                    }
                }
            }
            .navigationTitle("Edit Defaults")
        }
    }
}

struct DefaultsListViewTwo_Previews: PreviewProvider {
    static var previews: some View {
        DefaultsListView(isEditingTypes: .constant(true))
    }
}
