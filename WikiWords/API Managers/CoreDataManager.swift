//
//  CoreDataManager.swift
//  WikiWords
//
//  Created by Daniel Marks on 09/09/2019.
//  Copyright © 2019 Daniel Marks. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    var appDelegate: AppDelegate
    
    init() {
        appDelegate = AppDelegate().sharedInstance()
    }
    
    func save(keyword: Keyword, text: String) {
        
        let context = appDelegate.persistentContainer.viewContext
        
        if doesExist(text: text, title: keyword.title, context: context) {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        newEntity.setValue(text, forKey: "searchTerm")
        newEntity.setValue(keyword.title, forKey: "title")
        newEntity.setValue(keyword.summary, forKey: "summary")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    private func doesExist(text: String, title: String, context: NSManagedObjectContext) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "title = %@ && searchTerm = %@", title, text)
        
        let res = try! context.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    func update(title: String, imageData: Data) {
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        do {
            let object = try context.fetch(fetchRequest)
            
            if object.count == 1
            {
                let objectUpdate = object.first as! NSManagedObject
                objectUpdate.setValue(imageData, forKey: "image")
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func fetch(text: String) -> [Keyword] {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.predicate = NSPredicate(format: "searchTerm = %@", text)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            var keywords = [Keyword]()
            
            for data in result as! [NSManagedObject] {
                
                let keyword = Keyword(title: data.value(forKey: "title") as! String, summary: data.value(forKey: "summary") as? String, imagePath: nil, imageData: data.value(forKey: "image") as? Data)
                print(data.value(forKey: "searchTerm") as! String)
                keywords.append(keyword)
            }
            
            return keywords
            
        } catch {
            print("Failed")
        }
        
        return []
    }
}
