//
//  EditUnitsAndAislesView.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/09/2023.
//

import SwiftUI

struct EditUnitsAndAislesView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = EditUnitsAndAislesViewModel()
    @State var editmode: EditMode = .active
    @FocusState var aisleTextFieldInFocus: Bool
    @FocusState var unitTextFieldInFocus: Bool
    
    var body: some View {
        
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    Text("Editing will not affect Aisles or Units of existing Ingredients / Shopping List items")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .edgesIgnoringSafeArea(.all)
                        .listRowBackground(Color(uiColor: .secondarySystemBackground))
                    
                    Section("Aisles") {
                        ForEach(0..<vm.aisles.count, id: \.self) { i in
                            TextField("Aisle", text: $vm.aisles[i])
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .focused($aisleTextFieldInFocus)
                        }
                        .onDelete(perform: vm.deleteAisle)
                        .onMove(perform: vm.moveAisle)
                        Button("+New") {
                            vm.addNewAisle()
                        }
                    }
                    Section("Units") {
                        ForEach(0..<vm.units.count, id: \.self) { i in
                            TextField("Units", text: $vm.units[i])
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .focused($unitTextFieldInFocus)
                        }
                        .onDelete(perform: vm.deleteUnit)
                        .onMove(perform: vm.moveUhits)
                        Button("+New") {
                            vm.addNewUnit()
                        }
                    }
                }
                .onChange(of: vm.aisles.count) { proxy.scrollTo(vm.bottomOfAislesViewID, anchor: .bottom) }
                .onChange(of: vm.units.count) { proxy.scrollTo(vm.bottomOfUnitsViewID, anchor: .bottom) }
            }
            .environment(\.editMode, $editmode)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        vm.saveUnitsAndAisles()
                        dismiss()
                    }
                    .bold()
                    .disabled(!vm.isValidToSave)
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
            .navigationTitle("Edit Aisles / Units")
        }
    }
}

struct EditUnitsAndAisles_Previews: PreviewProvider {
    static var previews: some View {
        EditUnitsAndAislesView()
    }
}
