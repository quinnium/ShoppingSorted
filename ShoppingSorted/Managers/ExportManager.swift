//
//  ExportManager.swift
//  ShoppingSorted
//
//  Created by Quinn on 11/10/2023.
//

import Foundation

class ExportManager {
    
    func exportMealsToJSON(meals: [Meal]) -> URL? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(meals)
        guard let data = data else { return nil }
        let jsonString = String(data: data, encoding: .utf8)
        let documentDirectory = FileManager.default.temporaryDirectory
        let filenameWithPath = documentDirectory.appendingPathComponent("Exported_Meals", conformingTo: .json)
        do {
            try jsonString?.write(to: filenameWithPath, atomically: true, encoding: .utf8)
            return filenameWithPath
        } catch {
            print(error)
            return nil
        }
    }
    
}
