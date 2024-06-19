//
//  SignUpBodyProperty.swift
//  Onboarding
//
//  Created by MaraMincho on 6/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SignUpBodyProperty

final class SignUpBodyProperty: CustomStringConvertible, Equatable, Encodable {
  static func == (lhs: SignUpBodyProperty, rhs: SignUpBodyProperty) -> Bool {
    return lhs === rhs
  }

  var description: String {
    return " name: \(name ?? " ") \n loginType: \(loginType?.rawValue ?? " ")\ngender=\(gender ?? "none")\n termAgreement=\(termAgreement), birth=\(birth?.description ?? " ")"
  }

  private var loginType: LoginType? = nil
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

  func setLoginType(_ val: LoginType) {
    loginType = val
  }

  func getLoginType() -> LoginType? {
    return loginType
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
