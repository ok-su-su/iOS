//
//  GetVoteRequestResponse.swift
//  Vote
//
//  Created by MaraMincho on 8/23/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct GetVoteResponse {
  let items: [VotePreviewProperty]
  let page: Int32?
  let size: Int32?
  let hasNext: Bool
}
