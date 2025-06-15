//
//  PersistenceController.swift
//  Nova
//
//  Created by Mohamed Ameen on 14/06/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NovaModel") // Match your .xcdatamodeld name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data store: \(error)")
            }
        }
    }
}
