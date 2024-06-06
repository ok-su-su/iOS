//
//  OnboardingVoteHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct OnboardingVoteHelper: Equatable {
  var items: [OnboardingVoteItem]
  
  init(items: [OnboardingVoteItem] = [OnboardingVoteItem].initialItems()) {
    self.items = items
  }
}
struct OnboardingVoteItem: Equatable, Identifiable {
  var title: String
  var id: Int
}

extension [OnboardingVoteItem] {
  static func initialItems() -> Self {
    let itemsTitle = [
      "3만원",
      "5만원",
      "10만원",
      "20만원"
    ]
    return itemsTitle.enumerated().map { cur in
      return .init(title: cur.element, id: cur.offset)
    }
  }
}
