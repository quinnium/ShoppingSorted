//
//  ExportView.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/10/2023.
//

import SwiftUI

struct ExportView: View {
    
    @StateObject var vm: ExportViewModel
    @Binding var isShowingExportView: Bool
    
    init(reminderStrings: [String], isShowingExportView: Binding<Bool>) {
        _vm = StateObject(wrappedValue: ExportViewModel(reminderStrings: reminderStrings))
        _isShowingExportView = isShowingExportView
    }
    
    var body: some View {
        
        VStack {
                VStack {
                    Text("Select Reminders list to export to")
                        .bold()
                        
                    Rectangle()
                        .foregroundStyle(Color.dynamicBlack)
                        .frame(height: 1)
                    if let reminders = vm.reminderLists {
                        List {
                            ForEach(reminders, id: \.self) { reminder in
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.dynamicBlack, lineWidth: 1)
                                            .foregroundColor(.clear)
                                            .frame(width: 22)
                                        if reminder == vm.selectedReminderList {
                                            Circle()
                                                .foregroundStyle(Color.dynamicBlack)
                                                .frame(width: 14)
                                        }
                                    }
                                    Button {
                                        vm.selectedReminderList = reminder
                                    } label: {
                                        Text(reminder)
                                            .italic(reminder == vm.newReminderListName ? true : false)
                                            .foregroundStyle(reminder == vm.newReminderListName ? .blue : .dynamicBlack)
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                    } else {
                        // TODO: Add popup to shortcutnto settings if failed
                        VStack {
                            Text("Trying to fetch reminders...")
                                .italic()
                                .foregroundStyle(Color.gray)
                            Button("Retry") {
                                vm.fetchReminderListsNames()
                            }
                            Spacer()
                                .frame(height: 20)
                            Text("If problem persists, check Privacy Settings to ensure this app has access to Reminders")
                                .foregroundStyle(.gray)
                                .italic()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding()
                .background(Color.systemBackground)
                .frame(height: 400)
                .frame(maxWidth: .infinity)
                .ssRoundedRectangle(color: .blue, width: 1, cornerRadius: 10)
            
            
            
            HStack {
                Button {
                    isShowingExportView = false
                    vm.selectedReminderList = nil
                } label: {
                    Text("Cancel")
                        .bold()
                        .foregroundStyle(Color.systemBackground)
                        .frame(width: 130, height: 40)
                        .background(Color.gray)
                        .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 10)
                }
                Spacer()
                Button {
                    // TODO: show export acompletion alert
                    vm.exportToReminders()
                    isShowingExportView = false
                } label: {
                    Text("Export")
                        .bold()
                        .foregroundStyle(vm.exportButtonActive ? Color.systemBackground : Color.gray)
                        .frame(width: 130, height: 40)
                        .background(vm.exportButtonActive ? Color.green : Color.systemBackground)
                        .ssRoundedRectangle(color: vm.exportButtonActive ? .green : .gray, width: 2, cornerRadius: 10)
                }
                .disabled(!vm.exportButtonActive)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                vm.fetchReminderListsNames()
            }
            
        }
        .frame(width: 300, alignment: .center)
    }
}

#Preview {
    ExportView(reminderStrings: ["ReminderOne", "ReminderTwo"], isShowingExportView: .constant(true))
}
