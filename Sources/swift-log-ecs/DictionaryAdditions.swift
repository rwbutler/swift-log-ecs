//
//  DictionaryAdditions.swift
//

import Foundation

public extension Dictionary {

  func mapKeys<Transformed>(
    _ transform: (Key) throws -> Transformed
  ) rethrows -> [Transformed: Value] {
    .init(
      uniqueKeysWithValues: try map { (try transform($0.key), $0.value) }
    )
  }

  func mapKeys<Transformed>(
    _ transform: (Key) throws -> Transformed,
    uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows -> [Transformed: Value] {
    try .init(
      map { (try transform($0.key), $0.value) },
      uniquingKeysWith: combine
    )
  }
    
}
