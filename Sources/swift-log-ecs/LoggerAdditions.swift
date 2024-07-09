//
//  LoggerAdditions.swift
//
//
//  Created by Ross Butler on 09/05/2024.
//

#if canImport(_Backtracing)
import _Backtracing
#endif
import Foundation
import Logging

public extension Logger {
    func error(
        _ error: @autoclosure () -> Error,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        let error = error()
        let errorType = String(describing: type(of: error).self)
        var json: [ECSLogField: Any] = [
            .errorType: errorType,
            .errorMessage: error.localizedDescription
        ]
#if canImport(_Backtracing)
        if let trace = try? Backtrace.capture(algorithm: .precise).symbolicated() {
            json[.errorStackTrace] = trace
        }
#endif
        let mappedJSON = json.mapKeys { // Map ECSLogFields to Strings.
            $0.description
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: mappedJSON, options: []),
              let jsonMessage = String(data: jsonData, encoding: .utf8) else {
            return
        }
        self.error(
            Logger.Message(stringLiteral: jsonMessage),
            metadata: metadata(),
            source: source(),
            file: file,
            function: function,
            line: line
        )
    }
}
