//
//  SentMainProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SentMainProperty: Equatable {
  var selectedFilterDial: FilterDialItem? = [FilterDialItem].initialValue
  var sentPeopleFilterHelper: SentPeopleFilterHelper = .init()
  var searchHelper: SearchEnvelopeHelper = .init()
}
