//
//  ImportManager.swift
//  ShoppingSorted
//
//  Created by Quinn on 13/10/2023.
//

import Foundation

class ImportManager {
    
    func importMeals(from url: URL, completion: @escaping (Int) -> Void) {
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                do {
                    let meals = try decoder.decode([Meal].self, from: data)
                    let databaseManager = DatabaseManager()
                    databaseManager.addNewMeals(meals: meals)
                    completion(meals.count)
                }
                catch let error {
                    print(error)
                    completion(0)
                }
            }
        }
        dataTask.resume()
    }
}
