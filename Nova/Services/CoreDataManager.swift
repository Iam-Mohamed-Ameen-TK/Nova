//
//  NetworkManager.swift
//  Nova
//
//  Created by Mohamed Ameen on 13/06/25.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NovaModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func addToFavorites(movie: Movie) {
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "FavoriteMovie", into: context) as! FavoriteMovie
        favorite.id = Int64(movie.id)
        favorite.title = movie.title
        favorite.poster_path = movie.poster_path
        favorite.overview = movie.overview
        favorite.release_date = movie.release_date
        favorite.vote_average = movie.vote_average
        favorite.genre_ids = movie.genre_ids as NSObject 

        save()
    }

    func removeFromFavorites(id: Int) {
        let fetch: NSFetchRequest<FavoriteMovie> = NSFetchRequest(entityName: "FavoriteMovie")
        fetch.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetch)
            if let movieToDelete = results.first {
                context.delete(movieToDelete)
                save()
            }
        } catch {
            print("Error fetching movie to delete: \(error)")
        }
    }

    func isFavorited(id: Int) -> Bool {
        let fetch: NSFetchRequest<FavoriteMovie> = NSFetchRequest(entityName: "FavoriteMovie")
        fetch.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try context.count(for: fetch)
            return count > 0
        } catch {
            print("Error checking if favorited: \(error)")
            return false
        }
    }

    func getFavorites() -> [FavoriteMovie] {
        let fetch: NSFetchRequest<FavoriteMovie> = NSFetchRequest(entityName: "FavoriteMovie")
        
        do {
            return try context.fetch(fetch)
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }

    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving favorite: \(error)")
            }
        }
    }
}
