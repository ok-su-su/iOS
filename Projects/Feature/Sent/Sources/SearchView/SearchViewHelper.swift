//
//  SearchViewHelper.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SearchViewAdaptor

struct SearchEnvelopeHelper: Equatable {
  init() {}
  init(sentPeople: [SentPerson]) {
    self.sentPeople = sentPeople
  }

  var sentPeople: [SentPerson] = []
  var latestSearch: [String] = []

  func filterByTextField(_ textFieldText: String) -> [SentPerson] {
    guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else {
      return []
    }
    return sentPeople.filter { $0.name.contains(regex) }
  }
}
