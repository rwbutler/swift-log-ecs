//
//  LoggingSystem+ECSLogging.swift
//
//
//  Created by Ross Butler on 10/05/2024.
//

#if canImport(Logging) && canImport(Vapor)
import Foundation
import Logging
import Vapor

extension LoggingSystem {
    public static func bootstrapECSLogging(from environment: inout Environment) throws {
        try self.bootstrap(from: &environment) { level in
            return { (label: String) in
                return ECSLogHandler(label: label, logLevel: level)
            }
        }
    }
}
#endif
