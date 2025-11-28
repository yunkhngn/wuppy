//
//  JobCategory.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import Foundation
import SwiftData

@Model
final class JobCategory {
    var name: String
    var color: String? // Hex code or system name
    var icon: String? // SF Symbol name
    
    @Relationship(inverse: \Job.category) var jobs: [Job]?
    
    init(name: String, color: String? = nil, icon: String? = nil) {
        self.name = name
        self.color = color
        self.icon = icon
    }
}
