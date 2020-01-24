//
//  Goal+CoreDataProperties.swift
//  Game Detail
//
//  Created by Andy Walters on 12/11/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var goalName: String?
    @NSManaged public var goalComplete: Bool
    @NSManaged public var goalOfGame: Game?
    @NSManaged public var goalCreatedDate: Date
    @NSManaged public var goalDifficulty: String?
    
    public var wrappedGoalName: String {
        goalName ?? "Unknown Goal"
    }

}
