//
//  CamaraEntity.swift
//  CamaraSwitcherAVS
//
//  Created by Omar Campos on 10/10/22.
//

import Foundation

import CoreData
import UIKit

struct camaraChannel : Codable
{
    let id : Int?
    let ultrixId : Int?
    let nombre : String?
    let robotId : Int?
    let xPoint : Float?
    let yPoint : Float?
}

class CamaraEntity
{
    public static func saveChannel(camara : camaraChannel)
    {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        // 1
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        let entity =
        NSEntityDescription.entity(forEntityName: "Camara",
                                   in: managedContext)!
        let Club = NSManagedObject(entity: entity,
                             insertInto: managedContext)
        Club.setValue(camara.id, forKey: "id")
        Club.setValue(camara.ultrixId, forKey: "ultrixId")
        Club.setValue(camara.robotId, forKey: "robotId")
        Club.setValue(camara.nombre, forKey: "nombre")
        Club.setValue(camara.xPoint, forKey: "xPoint")
        Club.setValue(camara.yPoint, forKey: "yPoint")
        
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public static func UpdateChannel(channel : camaraChannel)
    {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Camara")
        fetchRequest.predicate = NSPredicate(format: "id = %i", channel.id ?? 0)
        
        do
        {
            let array = try managedContext.fetch(fetchRequest)
            if array.count > 0
            {
                if let us = array.last
                {
                    us.setValue(channel.id, forKeyPath: "id")
                    us.setValue(channel.nombre, forKeyPath: "nombre")
                    us.setValue(channel.robotId, forKey: "robotId")
                    us.setValue(channel.ultrixId, forKey: "ultrixId")
                    us.setValue(channel.xPoint, forKey: "xPoint")
                    us.setValue(channel.yPoint, forKey: "yPoint")
                    try managedContext.save()
                }
                else
                {
                    
                }
            }
        }
        catch
        {
            debugPrint(error)
        }
    }
    public static func getChannelExistence(channel : Int) -> Bool
    {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return false
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Camara")
        fetchRequest.predicate = NSPredicate(format: "id = %i", channel)
        do
        {
            let array = try managedContext.fetch(fetchRequest)
            if array.count > 0
            {
               return true
            }
            else
            {
                return false
            }
        }
        catch
        {
            debugPrint(error)
            return false
        }
    }
    public static func getCanal(tag : Int) -> camaraChannel?
    {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Camara")
        fetchRequest.predicate = NSPredicate(format: "id = %i", tag)
        do
        {
            let array = try managedContext.fetch(fetchRequest)
            if array.count > 0
            {
                if let a = array.first
                {
                    let au = camaraChannel(id: a.value(forKey: "id") as? Int, ultrixId: a.value(forKey: "ultrixId") as? Int, nombre: a.value(forKey: "nombre") as? String, robotId: a.value(forKey: "robotId") as? Int, xPoint: a.value(forKey: "xPoint") as? Float, yPoint: a.value(forKey: "yPoint") as? Float)
                    return au
                }
                else
                {
                    return nil
                }
            }
            else
            {
                return nil
            }
        }
        catch
        {
            debugPrint(error)
            return nil
        }
    }
    public static func getCanales() -> [camaraChannel]?
    {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Camara")
        var cb = [camaraChannel]()
        do
        {
            let array = try managedContext.fetch(fetchRequest)
            
            if array.count > 0
            {
                for a in array{
                    let au = camaraChannel(id: a.value(forKey: "id") as? Int, ultrixId: a.value(forKey: "ultrixId") as? Int, nombre: a.value(forKey: "nombre") as? String, robotId: a.value(forKey: "robotId") as? Int, xPoint: a.value(forKey: "xPoint") as? Float, yPoint: a.value(forKey: "yPoint") as? Float)
                    cb.append(au)
                }
                    
            return cb
                
            }
            else
            {
                return nil
            }
        }
        catch
        {
            debugPrint(error)
            return nil
        }
    }
}
