//
//  ECSLogField.swift
//  
//
//  Created by Ross Butler on 09/05/2024.
//

import Foundation

public enum ECSLogField: CustomStringConvertible, Hashable, Codable {
    case ecsVersion
    
    // Default fields.
    case timestamp
    case logLevel
    case logger
    case file
    case line
    case function
    case message
    case errorType
    case errorMessage
    case errorStackTrace
    case processThreadName
    
    // Configurable fields.
    case serviceName
    case serviceVersion
    case serviceEnvironment
    case serviceNodeName
    case eventDataset
    
    case custom(String)
    
    public var description: String {
        switch self {
        case .ecsVersion:
            return "ecs.version"
        case .timestamp:
            return "@timestamp"
        case .logLevel:
            return "log.level"
        case .logger:
            return "log.logger"
        case .file:
            return "log.origin.file.name"
        case .line:
            return "log.origin.file.line"
        case .function:
            return "log.origin.function"
        case .message:
            return "message"
        case .errorType:
            return "error.type"
        case .errorMessage:
            return "error.message"
        case .errorStackTrace:
            return "error.stack_trace"
        case .processThreadName:
            return "process.thread.name"
        case .serviceName:
            return "service.name"
        case .serviceVersion:
            return "service.version"
        case .serviceEnvironment:
            return "service.environment"
        case .serviceNodeName:
            return "service.node.name"
        case .eventDataset:
            return "event.dataset"
        case .custom(let stringValue):
            return stringValue
        }
    }
}





