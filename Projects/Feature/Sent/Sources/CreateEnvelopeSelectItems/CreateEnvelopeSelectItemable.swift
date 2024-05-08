//
//  CreateEnvelopeSelectItemable.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

protocol CreateEnvelopeSelectItemable: Identifiable, Equatable {
  var title: String { get }
  var id: UUID { get }
}
