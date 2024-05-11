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

extension Logger {
    public func error(
        _ error: @autoclosure () -> Error,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
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
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
              let jsonMessage = String(data: jsonData, encoding: .utf8) else {
            return
        }
        self.error(
            Logger.Message(stringLiteral: jsonMessage),
            metadata: metadata(),
            source: nil,
            file: file,
            function: function,
            line: line
        )
    }
}
