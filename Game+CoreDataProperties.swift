//
//  Game+CoreDataProperties.swift
//  Game Detail
//
//  Created by Andy Walters on 12/11/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var gameDescription: String?
    @NSManaged public var gameName: String?
    @NSManaged public var goal: NSSet?
    
    public var wrappedGameName: String {
        gameName ?? "Unknown Game"
    }
    
    public var wrappedGameDescription: String {
        gameDescription ?? "Unknown Game Description"
    }
    
    public var goalArray: [Goal] {
        let set = goal as? Set<Goal> ?? []
        
        // Checks to see if the goalComplete are the same, then sorts by goalName, if not sorts by complete or not.
        return set.sorted(by: { (lhs, rhs) -> Bool in
            if lhs.goalComplete == rhs.goalComplete { return lhs.wrappedGoalCreatedDate.compare(rhs.wrappedGoalCreatedDate) == .orderedDescending}
            return lhs.goalComplete == false && rhs.goalComplete != false
        })
    }

}

// MARK: Generated accessors for goal
extension Game {

    @objc(addGoalObject:)
    @NSManaged public func addToGoal(_ value: Goal)

    @objc(removeGoalObject:)
    @NSManaged public func removeFromGoal(_ value: Goal)

    @objc(addGoal:)
    @NSManaged public func addToGoal(_ values: NSSet)

    @objc(removeGoal:)
    @NSManaged public func removeFromGoal(_ values: NSSet)

}
