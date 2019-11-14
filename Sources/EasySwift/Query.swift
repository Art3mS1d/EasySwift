//
//  Query.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import CoreData


public enum Query<T: NSManagedObject> {
        
    public static func fetchRequest(
        _ filter: NSPredicate? = nil,
        by sort: [NSSortDescriptor]? = nil,
        limit: Int = 0
    ) -> NSFetchRequest<T> {
        let entityName = String(describing: T.self)
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = filter
        request.sortDescriptors = sort
        request.fetchLimit = limit
        return request
    }

    public static func any(
        predicate: NSPredicate? = nil,
        sort: [NSSortDescriptor]? = nil,
        in context: NSManagedObjectContext
    ) -> T? {
        all(predicate: predicate, sort: sort, limit: 1, in: context).first
    }

    public static func all(
        predicate: NSPredicate? = nil,
        sort: [NSSortDescriptor]? = nil,
        limit: Int = 0,
        in context: NSManagedObjectContext
    ) -> [T] {
        try! context.fetch(fetchRequest(predicate, by: sort, limit: limit))
    }

    public static func all(request: NSFetchRequest<T>, in context: NSManagedObjectContext) -> [T] {
        try! context.fetch(request)
     }

    public static func count(predicate: NSPredicate? = nil, in context: NSManagedObjectContext) -> Int {
        try! context.count(for: fetchRequest(predicate))
    }

    public static func delete(predicate: NSPredicate? = nil, in context: NSManagedObjectContext) -> [T] {
        let request = fetchRequest(predicate)
        request.includesPropertyValues = false
        let objects = all(request: request, in: context)
        objects.forEach(context.delete)
        return objects
    }

    // MARK: Typed predicate
    
    public static func any<P: TypedPredicate>(
        _ filter: P,
        by sort: [NSSortDescriptor]? = nil,
        in context: NSManagedObjectContext
    ) -> T? where P.Root == T {
        any(predicate: filter, sort: sort, in: context)
    }
    
    public static func any<P: TypedPredicate, V>(
        _ filter: P,
        by sort: KeyPath<T, V>,
        desc: Bool = false,
        in context: NSManagedObjectContext
    ) -> T? where P.Root == T {
        any(predicate: filter, sort: [NSSortDescriptor(keyPath: sort, ascending: !desc)], in: context)
    }
    
    public static func any<V>(
        by sort: KeyPath<T, V>,
        desc: Bool = false,
        in context: NSManagedObjectContext
    ) -> T? {
        all(sort: [NSSortDescriptor(keyPath: sort, ascending: !desc)], limit: 1, in: context).first
    }

    public static func all<P: TypedPredicate>(
        _ filter: P,
        by sort: [NSSortDescriptor]? = nil,
        limit: Int = 0,
        in context: NSManagedObjectContext
    ) -> [T] where P.Root == T {
        all(predicate: filter, sort: sort, limit: limit, in: context)
    }

    public static func all<P: TypedPredicate, V>(
        _ filter: P,
        by sort: KeyPath<T, V>,
        desc: Bool = false,
        limit: Int = 0,
        in context: NSManagedObjectContext
    ) -> [T] where P.Root == T  {
        all(predicate: filter, sort: [NSSortDescriptor(keyPath: sort, ascending: !desc)], limit: limit, in: context)
    }
    
    public static func all<V>(
        by sort: KeyPath<T, V>,
        desc: Bool = false,
        limit: Int = 0,
        in context: NSManagedObjectContext
    ) -> [T] {
        all(sort: [NSSortDescriptor(keyPath: sort, ascending: !desc)], limit: limit, in: context)
    }
    
    public static func count<P: TypedPredicate>(
        _ filter: P,
        in context: NSManagedObjectContext
    ) -> Int where P.Root == T {
        count(predicate: filter, in: context)
    }
    
    public static func delete<P: TypedPredicate>(
        _ filter: P,
        in context: NSManagedObjectContext
    ) -> [T] where P.Root == T {
        delete(predicate: filter, in: context)
    }
}

