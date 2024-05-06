//
//  CreateEnvelopeDateView.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeDateView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeDate>

  // MARK: Content
  
  
  @ViewBuilder
  private func makeNextButton() -> some View {
    SSButton(
      .init(
        size: .mh60,
        status: store.isAbleToPush ? .active : .inactive,
        style: .filled,
        color: .black,
        buttonText: "다음",
        frame: .init(maxWidth: .infinity)
      )
    ) {
      store.send(.view(.tappedNextButton))
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack {
      HStack(spacing: 4) {
        // TODO: change Property
        Text("김철수님에게")
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray60)

        Text(Constants.nameDescriptionText)
          .modifier(SSTypoModifier(.title_m))
          .foregroundStyle(SSColor.gray100)
      }
      HStack(spacing: 0) {
        TextField(
          "",
          text: $store.yearTextFieldText,
          prompt: Constants.yearTextFieldTextPrompt
            .modifier(SSTypoModifier(.title_xl))
            .foregroundStyle(SSColor.gray30) as? Text
        )
        Text("년 ")
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(SSColor.gray100) as? Text
        
        TextField(
          "",
          text: $store.monthTextFieldText,
          prompt: Constants.monthTextFieldTextPrompt
            .modifier(SSTypoModifier(.title_xl))
            .foregroundStyle(SSColor.gray30) as? Text
        )
        Text("월 ")
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(SSColor.gray100) as? Text
        
        
        TextField(
          "",
          text: $store.dayTextFieldText,
          prompt: Constants.dayTextFieldTextPrompt
            .modifier(SSTypoModifier(.title_xl))
            .foregroundStyle(SSColor.gray30) as? Text
        )
        Text("일 ")
          .modifier(SSTypoModifier(.title_xl))
          .foregroundStyle(SSColor.gray100) as? Text
        
        Spacer()
      }
    }
    .padding(.horizontal, Metrics.horizontalSpacing)

  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
        makeContentView()
        makeNextButton()
      }
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let horizontalSpacing: CGFloat = 16
  }
  private enum Constants {
    static let nameDescriptionText: String = "언제 보냈나요"
    
    static let yearTextFieldTextPrompt: Text = Text("2024")
    static let monthTextFieldTextPrompt: Text = Text("11")
    static let dayTextFieldTextPrompt: Text = Text("24")
    
  }
}
