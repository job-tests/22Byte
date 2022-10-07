//
//  Note.swift
//  Matches
//
//  Created by Kirill Drozdov on 26.12.2021.
//

import Foundation
import CoreData


@objc(Note)
class Note: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var deletedDate: Date?
    @NSManaged var teamOne: String!
    @NSManaged var teamTwo: String!
    @NSManaged var teamWin: String!
    @NSManaged var descriptionMatches: String!
}
