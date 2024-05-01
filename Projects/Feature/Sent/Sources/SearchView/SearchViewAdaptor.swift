//
//  SearchViewAdaptor.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SearchViewAdaptor

struct SearchViewAdaptor {
  init() {}
  init(sentPeople: [SentPerson]) {
    self.sentPeople = sentPeople
  }

  var sentPeople: [SentPerson] = [.init(name: "김그남"), .init(name: "김그자"), .init(name: "김사랑")]
  var latestSearch: [String] = ["김그남", "김그자", "김사랑"]

  func filterByTextField(_ textFieldText: String) -> [SentPerson] {
    guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else {
      return []
    }
    return sentPeople.filter { $0.name.contains(regex) }
  }
}
