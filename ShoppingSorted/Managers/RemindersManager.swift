//
//  RemindersManager.swift
//  ShoppingSorted
//
//  Created by Quinn on 21/10/2023.
//

import Foundation
import EventKit

protocol RemindersManagerProtocol {
    func accessGranted()
}

class RemindersManager {
    
    private let store = EKEventStore()
    var accessGranted: Bool?
    var delegate: RemindersManagerProtocol?
    
    enum RemindersError: Error {
        case accessDenied
        case failedToSaveCalendar
    }
    
    init() {
        requestAccess()
    }
    
    func requestAccess() {
        store.requestFullAccessToReminders { granted, error in
            guard error == nil else { return }
            if granted {
                DispatchQueue.main.async { [weak self] in
                    if let self = self {
                        self.accessGranted = true
                        self.delegate?.accessGranted()

                    }                    
                }
            }
        }
    }
    
    func getReminderListNams() throws -> [String] {
        guard accessGranted == true else {
            print("access denied")
            throw RemindersError.accessDenied
        }
        let calendars = store.calendars(for: .reminder)
        let names = calendars.map { $0.title }
        return names
    }
    
    func createNewRemindersList(name: String) throws {
        guard accessGranted == true else {
            print("access denied")
            throw RemindersError.accessDenied
        }
        let newCal = EKCalendar(for: .reminder, eventStore: store)
        newCal.title = name
        
        if let source = store.sources.first(where: { $0.sourceType == .local }) {
            newCal.source = source
            print("newCal source has been set to local")
        } else {
            newCal.source = store.sources.first
            print("newCal source has been set to any first source")
        }
        do {
            try store.saveCalendar(newCal, commit: true)
        } catch {
            throw RemindersError.failedToSaveCalendar
        }
    }
    
    func exportItemsToRemindersList(reminderTitles: [String], listName: String) throws {
        guard accessGranted == true else { throw RemindersError.accessDenied }
        let calendars = store.calendars(for: .reminder)
        let selectedCal = calendars.first { $0.title == listName }
        for title in reminderTitles {
            let newReminder = EKReminder(eventStore: store)
            newReminder.calendar = selectedCal
            newReminder.title = title
            try store.save(newReminder, commit: true)
        }
    }
}
