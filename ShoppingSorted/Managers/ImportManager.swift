//
//  ImportManager.swift
//  ShoppingSorted
//
//  Created by Quinn on 13/10/2023.
//

import Foundation

class ImportManager {
    
    func importMeals(from url: URL, completion: @escaping (Int) -> Void) {
        let _ = url.startAccessingSecurityScopedResource()
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("QLog: bad data")
                return
            }
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                do {
                    let meals           = try decoder.decode([RMMeal].self, from: data)
                    let databaseManager = DatabaseManager()
                    databaseManager.addNewMeals(meals: meals)
                    print("QLog: \(meals.count) successfully imported")
                    completion(meals.count)
                }
                catch let error {
                    print("QLog: \(error)")
                    completion(0)
                }
            }
        }
        dataTask.resume()
    }
}
