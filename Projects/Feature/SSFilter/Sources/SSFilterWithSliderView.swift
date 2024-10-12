//
//  SSFilterWithSliderView.swift
//  SSFilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SSLayout
import SwiftUI

struct SSFilterWithSliderView: View {
  @Bindable
  var store: StoreOf<SSFilterWithSliderReducer>

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text(store.titleLabel)
        .modifier(SSTypoModifier(.title_xs))
        .foregroundStyle(SSColor.gray100)

      VStack(alignment: .leading, spacing: 8) {
        Text(store.sliderProperty.sliderRangeText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)

        SliderView(slider: store.sliderProperty.sliderProperty)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
