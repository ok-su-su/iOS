//
//  Collections+.swift
//  CommonExtension
//
//  Created by MaraMincho on 8/23/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public extension Array where Element: Identifiable {
  /// Returns a new collection where the elements in the current collection are updated or appended based on
  /// the elements in the provided collection, matching by their `ID`. If an element in `others` has the same
  /// `ID` as an element in the current collection, the current element is updated with the new one. If an
  /// element in `others` does not have a matching `ID`, it is appended to the returned collection.
  ///
  /// - Parameter others: A collection of elements with the same type and ID as the current collection.
  /// - Returns: A new collection where elements from `others` either overwrite existing elements or are appended.
  func overwritedByID(_ others: Self) -> Self {
    var mutatingSelf = self
    var indexDictionary: [Element.ID: Int] = [:]
    enumerated().forEach { indexDictionary[$0.element.id] = $0.offset }
    let notUpdateOthers = others.compactMap { element -> Element? in
      if let index = indexDictionary[element.id] {
        mutatingSelf[index] = element
        return nil
      }
      return element
    }
    return mutatingSelf + notUpdateOthers
  }

  /// Updates the elements in the current collection based on the elements in the provided collection,
  /// matching by their `ID`. If an element in `others` has the same `ID` as an element in the current
  /// collection, the current element is updated with the new one. If an element in `others` does not
  /// have a matching `ID`, it is appended to the current collection.
  ///
  /// - Parameter others: A collection of elements with the same type and ID as the current collection.
  /// - Returns: A new collection where elements from `others` either overwrite existing elements or are appended.
  mutating func overwriteByID(_ others: Self) {
    var indexDictionary: [Element.ID: Int] = [:]
    enumerated().forEach { indexDictionary[$0.element.id] = $0.offset }
    let notUpdateOthers = others.compactMap { element -> Element? in
      if let index = indexDictionary[element.id] {
        self[index] = element
        return nil
      }
      return element
    }
    notUpdateOthers.forEach { append($0) }
  }
}

public extension Array {
  subscript(safe index: Int) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
