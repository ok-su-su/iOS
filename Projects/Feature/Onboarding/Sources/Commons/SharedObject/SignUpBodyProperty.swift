//
//  SignUpBodyProperty.swift
//  Onboarding
//
//  Created by MaraMincho on 6/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SignUpBodyProperty

final class SignUpBodyProperty: Equatable, Encodable {
  static func == (lhs: SignUpBodyProperty, rhs: SignUpBodyProperty) -> Bool {
    return lhs === rhs
  }

  private var name: String? = nil
  private var termAgreement: [Int] = []
  private var gender: String? = nil
  private var birth: Int? = nil

  init() {}

  func setTermAgreement(terms: [Int]) {
    termAgreement = terms
  }

  func setName(_ val: String?) {
    name = val
  }

  func setGender(_ val: String?) {
    gender = val
  }

  func setBirth(_ val: Int?) {
    birth = val
  }
}

extension SignUpBodyProperty {
  func makeBody() -> SingUpBodyDTO {
    return .init(
      name: name ?? "",
      termAgreement: termAgreement,
      gender: gender,
      birth: birth
    )
  }

  func makeBodyData() throws -> Data {
    let encoder = JSONEncoder()
    return try encoder.encode(makeBody())
  }
}
