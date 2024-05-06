//
//  SSTextFieldButtonProperty.swift
//  Designsystem
//
//  Created by MaraMincho on 4/12/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

// MARK: - SSTextFieldButtonProperty

public struct SSTextFieldButtonProperty {
  let size: Size
  let status: Status
  let style: Style
  let color: ButtonColor
  @Binding var textFieldText: String
  var showCloseButton: Bool
  var showDeleteButton: Bool
  let prompt: String
  let frame: SSButtonFrame

  public struct SSButtonFrame {
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

  // MARK: - INit

  /// SSTextField에 사용되는 property입니다.
  /// - Parameters:
  ///   - size: Button의 사이즈 입니다.
  ///   - status: focused, filled, saved, unfocused 가 있습니다.
  ///   - style: ghost, filled 가 있습니다.
  ///   - color: button의 foreGround 색을 지정하는데 사용됩니다.
  ///   - buttonText: Text입니다.
  ///   - showCloseButton: closButton을 표시할지 나타냅니다.
  ///   - showDeleteButton: deleteButton을 표시할지 나타냅니다.
  ///   - frame: frame입니다.
  public init(
    size: Size,
    status: Status,
    style: Style,
    color: ButtonColor,
    textFieldText: Binding<String>,
    showCloseButton: Bool,
    showDeleteButton: Bool,
    prompt: String,
    frame: SSButtonFrame = .init()
  ) {
    self.size = size
    self.status = status
    self.style = style
    self.color = color
    _textFieldText = textFieldText
    self.showCloseButton = showCloseButton
    self.showDeleteButton = showDeleteButton
    self.prompt = prompt
    self.frame = frame
  }

  public mutating func update(text: String) {
    textFieldText = text
  }
}

public extension SSTextFieldButtonProperty {
  var isEditingMode: Bool {
    return status == .filled || status == .focused
  }

  // size: Button의 사이즈 입니다.
  enum Size {
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
  }

  enum Status {
    case focused
    case filled
    case saved
    case unfocused
  }

  enum Style {
    case filled
    case ghost
  }

  enum ButtonColor {
    case black
    case orange
    case gray

    var focusedColor: (primary: Color, secondary: Color) {
      switch self {
      case .black:
        return (.gray30, .gray10)
      case .orange:
        return (.gray30, .gray10)
      case .gray:
        return (.gray40, .gray15)
      }
    }

    var filled: (primary: Color, secondary: Color) {
      switch self {
      case .black:
        return (.gray100, .gray10)
      case .orange:
        return (.gray100, .gray10)
      case .gray:
        return (.gray100, .gray15)
      }
    }

    var saved: (primary: Color, secondary: Color) {
      switch self {
      case .black:
        return (.gray100, .gray10)
      case .orange:
        return (.gray10, .orange60)
      case .gray:
        return (.gray100, .orange10)
      }
    }

    var unfocused: (primary: Color, secondary: Color) {
      switch self {
      case .black:
        return (.gray30, .gray10)
      case .orange:
        return (.gray10, .orange20)
      case .gray:
        return (.gray40, .gray40)
      }
    }
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
    let (_, secondaryColor) =
      switch status {
    case .filled:
      color.filled
    case .focused:
      color.focusedColor
    case .saved:
      color.saved
    case .unfocused:
      color.unfocused
    }
    return secondaryColor
  }

  var textColor: Color {
    let (targetColor, _) =
      switch status {
    case .filled:
      color.filled
    case .focused:
      color.focusedColor
    case .saved:
      color.saved
    case .unfocused:
      color.unfocused
    }
    return targetColor
  }

  var isDisable: Bool {
    return false
  }

  var buttonTextModifierProperty: SSTypoModifier {
    switch size {
    case .xsh28:
      .init(.title_xxxxs)
    default:
      .init(.title_xxxs)
    }
  }

  var buttonBackgroundColor: Color {
    switch status {
    case .focused,
         .unfocused:
      return SSColor.gray40
    case .filled,
         .saved:
      return SSColor.gray100
    }
  }

  var buttonHorizontalSpacing: CGFloat { 8 }
  var buttonVerticalSpacing: CGFloat {
    switch size {
    case .lh46,
         .lh54,
         .lh62,
         .mh52,
         .mh60:
      4
    default:
      2
    }
  }

  var buttonText: String {
    switch status {
    case .filled,
         .focused
         :
      return "저장"
    case
      .saved,
      .unfocused:
      return "편집"
    }
  }

  var verticalSpacing: CGFloat {
    switch size {
    case .lh62,
         .mh60:
      16
    case .lh54,
         .mh52,
         .sh48,
         .xsh44:
      12
    case .lh46,
         .mh44,
         .sh40,
         .xsh36:
      8
    case .sh32,
         .xsh28:
      4
    }
  }

  var leadingSpacing: CGFloat {
    switch size {
    case .lh62,
         .mh60:
      24
    case .lh54,
         .mh52,
         .sh48,
         .xsh44:
      20
    case .lh46,
         .mh44,
         .sh40,
         .xsh36:
      16
    case .sh32,
         .xsh28:
      8
    }
  }

  var trailingSpacing: CGFloat {
    switch size {
    case .lh62,
         .mh60,
         .xsh44:
      16
    case .lh54,
         .mh52:
      14
    case .lh46,
         .mh44,
         .sh48:
      12
    case .sh32,
         .sh40,
         .xsh36:
      8
    case .xsh28:
      4
    }
  }
}
