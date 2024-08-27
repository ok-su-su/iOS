//
//  VoteDetailProperty.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSNetwork

typealias VoteDetailProperty = VoteAllInfoResponse

// MARK: Identifiable

extension VoteDetailProperty {
  var createdAtLabel: String { createdAt.subtractFromNowAndMakeLabel() }
}

// MARK: - VoteOptionCountModel + Identifiable

extension VoteOptionCountModel: Identifiable {}
