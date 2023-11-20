//
//  ExportViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 01/11/2023.
//

import Foundation

class ExportViewModel: ObservableObject {
    
    @Published var reminderLists: [String]?
    @Published var selectedReminderList: String?
    private let titlesForExportedReminders: [String]
    private let remindersManager = RemindersManager()
    let newReminderListName = "Create New List"
    var exportButtonActive: Bool {
        selectedReminderList != nil
    }
    
    init(reminderStrings: [String]) {
        self.titlesForExportedReminders = reminderStrings
        remindersManager.delegate = self
    }
    
    func fetchReminderListsNames() {
        guard remindersManager.accessGranted == true else {
            print("access not granted")
            return
        }
        do {
            reminderLists = try remindersManager.getReminderListNams()
            reminderLists?.append(self.newReminderListName)
        } catch {
            print(error)
        }
    }
    
    func exportToReminders() {
        // TODO: add a guard to ensure ailse name is on list
        guard remindersManager.accessGranted == true else { return }
        guard selectedReminderList != nil else { return }
        do {
            if selectedReminderList == newReminderListName {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = .medium
                let newListName = "ShoppingSorted \(dateFormatter.string(from: Date())), \(timeFormatter.string(from: Date()))"
                try remindersManager.createNewRemindersList(name: newListName)
                try remindersManager.exportItemsToRemindersList(reminderTitles: titlesForExportedReminders, listName: newListName)
            } else {
                try remindersManager.exportItemsToRemindersList(reminderTitles: titlesForExportedReminders, listName: selectedReminderList!)
            }
        } catch {
            print(error)
        }
    }
    
}

extension ExportViewModel: RemindersManagerProtocol {
    func accessGranted() {
        fetchReminderListsNames()
    }
}
