//
//  ECSLogHandler.swift
//
//
//  Created by Ross Butler on 09/05/2024.
//

import Collections
import Foundation
import Logging

public struct ECSLogHandler: LogHandler {
    private static let timestampSubstitute = "_1"
    private static let logLevelSubstitute = "_2"
    private static let messageSubstitute = "_3"
    public let label: String
    public let logHandler: LogHandler?
    public var logLevel: Logger.Level
    public var metadata: Logger.Metadata
    public var prettyPrint: Bool
    
    public init(
        label: String,
        logHandler: LogHandler? = nil,
        logLevel: Logger.Level = .info,
        metadata: Logger.Metadata = [:],
        prettyPrint: Bool = false
    ) {
        self.label = label
        self.logHandler = logHandler
        self.logLevel = logLevel
        self.metadata = metadata
        self.prettyPrint = prettyPrint
    }
    
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let formatter = ISO8601DateFormatter()
        let formattedDate = formatter.string(from: Date())
        var json: Dictionary<ECSLogField, Any> = [
            .timestamp: formattedDate,
            .logLevel: level.rawValue.uppercased(),
            .message: message.description,
            .logger: label,
            .file: file,
            .line: "\(line)",
            .function: function
        ]
        // Add thread name if available.
        if let threadName = Thread.current.name {
            json[.processThreadName] = threadName
        }
        if let metadata = metadata {
            for (key, value) in metadata {
                switch value {
                case .array, .dictionary:
                    json[.custom("custom.\(key)")] = unwrapMetadataValue(value)
                    continue
                case .string, .stringConvertible:
                    json[.custom("labels.\(key)")] = unwrapMetadataValue(value)
                    continue
                }
            }
        }
       
        var mappedJSON = json.mapKeys { // Map ECSLogFields to Strings.
            $0.description
        }
        
        // Ensure that these fields will be printed first.
        mappedJSON[Self.timestampSubstitute] = mappedJSON[ECSLogField.timestamp.description]
        mappedJSON[Self.logLevelSubstitute] = mappedJSON[ECSLogField.logLevel.description]
        mappedJSON[Self.messageSubstitute] = mappedJSON[ECSLogField.message.description]
        [ECSLogField.timestamp, ECSLogField.logLevel, ECSLogField.message].map {
            $0.description
        }.forEach {
            mappedJSON.removeValue(forKey: $0)
        }
        
        // Convert Dictionary to JSON String.
        var options: JSONSerialization.WritingOptions = [.sortedKeys]
        if prettyPrint {
            options.insert(.prettyPrinted)
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: mappedJSON, options: options),
              var jsonMessage = String(data: jsonData, encoding: .utf8) else {
            return
        }
        
        // Restore original field names.
        jsonMessage = jsonMessage.replacingOccurrences(of: Self.timestampSubstitute, with: ECSLogField.timestamp.description)
        jsonMessage = jsonMessage.replacingOccurrences(of: Self.logLevelSubstitute, with: ECSLogField.logLevel.description)
        jsonMessage = jsonMessage.replacingOccurrences(of: Self.messageSubstitute, with: ECSLogField.message.description)
        
        guard let logHandler = logHandler else {
            print(jsonMessage)
            fflush(stdout)
            return
        }
        logHandler.log(
            level: level,
            message: .init(stringLiteral: jsonMessage),
            metadata: metadata,
            source: source,
            file: file,
            function: function,
            line: line
        )
    }
    
    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get {
            self.metadata[key]
        }
        set {
            self.metadata[key] = newValue
        }
    }
    
    private func unwrapMetadataValue(_ value: Logger.Metadata.Value) -> Any {
        switch value {
        case .array(let valuesArray):
            return valuesArray.map { value in
                unwrapMetadataValue(value)
            }
        case .dictionary(let metadata):
            return metadata.mapValues { value in
                unwrapMetadataValue(value)
            }
        case .string(let stringValue):
            return stringValue
        case .stringConvertible(let stringValue):
            return stringValue.description
        }
    }
}
