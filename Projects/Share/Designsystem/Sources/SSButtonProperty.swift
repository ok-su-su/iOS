//
//  SSButtonProperty.swift
//  Designsystem
//
//  Created by MaraMincho on 4/12/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - SSButtonProperty

public struct SSButtonProperty: Sendable {
  let size: Size
  let status: Status
  let style: Style
  let color: ButtonColor
  let leftIcon: LeftIcon
  let rightIcon: RightIcon
  var buttonText: String
  let frame: SSButtonFrame

  public struct SSButtonFrame: Sendable {
    let minWidth: CGFloat?
    let idealWidth: CGFloat?
    let maxWidth: CGFloat?
    let minHeight: CGFloat?
    let idealHeight: CGFloat?
    let maxHeight: CGFloat?
    let alignment: Alignment

    public init(
      minWidth: CGFloat? = nil,
      idealWidth: CGFloat? = nil,
      maxWidth: CGFloat? = nil,
      minHeight: CGFloat? = nil,
      idealHeight: CGFloat? = nil,
      maxHeight: CGFloat? = nil,
      alignment: Alignment = .center
    ) {
      self.minWidth = minWidth
      self.idealWidth = idealWidth
      self.maxWidth = maxWidth
      self.minHeight = minHeight
      self.idealHeight = idealHeight
      self.maxHeight = maxHeight
      self.alignment = alignment
    }
  }

  /// SusuButton의 Property 입니다.
  /// - Parameters:
  ///   - size: Button의 사이즈 입니다.
  ///   - status: Status입니다. Status는 active, inactive가 있습ㄴ디ㅏ.
  ///   - style: Button이 어떤 스타일인지 정의하는 Property 입니다. filled, ghost, lined가 있습니다.
  ///   - color: Button이 어떤 Color를 갖는지 정의합니다. Black, Orange가 있습니다.
  ///   - leftIcon: leftIcon에 대해 정의합니다. 기본값은 non입니다.
  ///   - rightIcon: rightIcon에 대해 정의합니다. 기본값은 non입니다.
  ///   - buttonText: button의 Text입니다.
  public init(
    size: Size,
    status: Status,
    style: Style,
    color: ButtonColor,
    leftIcon: LeftIcon = .none,
    rightIcon: RightIcon = .none,
    buttonText: String,
    frame: SSButtonFrame? = .init()
  ) {
    self.size = size
    self.status = status
    self.style = style
    self.color = color
    self.leftIcon = leftIcon
    self.rightIcon = rightIcon
    self.buttonText = buttonText
    self.frame = frame ?? .init()
  }

  public func toggleProperty() -> Self {
    return .init(
      size: size,
      status: status == .active ? .inactive : .active,
      style: style,
      color: color,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
      buttonText: buttonText,
      frame: frame
    )
  }

  public mutating func update(text: String) {
    buttonText = text
  }
}

public extension SSButtonProperty {
  // size: Button의 사이즈 입니다.
  enum Size: Sendable {
    case lh62
    case lh54
    case lh46

    case mh60
    case mh52
    case mh44

    case sh48
    case sh40
    case sh32

    case xsh44
    case xsh36
    case xsh28

    var height: CGFloat {
      return switch self {
      case .lh62:
        62
      case .lh54:
        54
      case .lh46:
        46
      case .mh60:
        60
      case .mh52:
        52
      case .mh44:
        44
      case .sh48:
        48
      case .sh40:
        40
      case .sh32:
        32
      case .xsh44:
        44
      case .xsh36:
        36
      case .xsh28:
        28
      }
    }

    var horizontalSpacing: CGFloat {
      switch self {
      case .lh62:
        24
      case .lh54:
        20
      case .lh46:
        16

      case .mh60:
        24
      case .mh52:
        20
      case .mh44:
        16

      case .sh48:
        16
      case .sh40:
        12
      case .sh32:
        8

      case .xsh44:
        16
      case .xsh36:
        12
      case .xsh28:
        8
      }
    }

    var verticalSpacing: CGFloat {
      switch self {
      case .lh62:
        16
      case .lh54:
        12
      case .lh46:
        8

      case .mh60:
        16
      case .mh52:
        12
      case .mh44:
        8

      case .sh48:
        12
      case .sh40:
        8
      case .sh32:
        4

      case .xsh44:
        12
      case .xsh36:
        8
      case .xsh28:
        4
      }
    }

    var hStackSpacing: CGFloat {
      switch self {
      case .lh62,
           .mh60,
           .sh48,
           .xsh44:
        8
      case .lh54,
           .mh52,
           .sh40,
           .xsh36:
        6
      case .lh46,
           .mh44,
           .sh32,
           .xsh28:
        4
      }
    }
  }

  enum Status: Sendable {
    case inactive
    case active
  }

  enum Style: Sendable {
    case filled
    case ghost
    case lined
  }

  enum ButtonColor: Sendable {
    case black
    case orange

    var color: (primary: Color, secondary: Color) {
      switch self {
      case .black:
        return (.gray100, .gray10)
      case .orange:
        return (.orange60, .gray10)
      }
    }

    var inactiveColor: (primary: Color, secondary: Color) {
      switch self {
      case .black:
        return (.gray30, .gray10)
      case .orange:
        return (.orange20, .gray10)
      }
    }
  }

  enum LeftIcon: Sendable {
    case none
    case icon(Image)
  }

  enum RightIcon: Sendable {
    case none
    case icon(Image)
  }

  var font: SSFont {
    switch size {
    case .lh46,
         .lh54,
         .lh62:
      .title_s
    case .mh44,
         .mh52,
         .mh60:
      .title_xs
    case .sh32,
         .sh40,
         .sh48:
      .title_xxs
    case .xsh28,
         .xsh36,
         .xsh44:
      .title_xxxs
    }
  }

  var backgroundColor: Color {
    let (primaryColor, secondaryColor) = status == .active ? color.color : color.inactiveColor
    return switch style {
    case .filled:
      primaryColor
    case .ghost,
         .lined:
      secondaryColor
    }
  }

  var textColor: Color {
    let (primaryColor, secondaryColor) = status == .active ? color.color : color.inactiveColor
    return switch style {
    case .filled:
      secondaryColor
    case .ghost,
         .lined:
      primaryColor
    }
  }

  var lineColor: Color? {
    if style == .lined {
      return status == .active ? activeLineColor : inactiveLineColor
    }
    return nil
  }

  var activeLineColor: Color {
    return switch color {
    case .black:
      .gray90
    case .orange:
      .orange50
    }
  }

  var inactiveLineColor: Color {
    return switch color {
    case .black:
      .gray30
    case .orange:
      .orange20
    }
  }

  var isLined: Bool {
    return style == .lined
  }

  var isDisable: Bool {
    return false
  }
}
