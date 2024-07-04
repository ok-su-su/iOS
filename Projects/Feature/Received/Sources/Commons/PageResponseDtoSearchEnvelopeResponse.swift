//
//  PageResponseDtoSearchEnvelopeResponse.swift
//  Received
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - PageResponseDtoSearchEnvelopeResponse

struct PageResponseDtoSearchEnvelopeResponse: Decodable {
  let data: [SearchLatestOfThreeEnvelopeDataResponseDTO]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortObject
}
