//
//  OtherVoteDetailView.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct OtherVoteDetailView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OtherVoteDetail>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 16)

      VStack(alignment: .center, spacing: 24) {
        TopContentWithProfileAndText(property: .init(userImage: nil, userName: nil, userText: "고등학교 동창이고 좀 애매하게 친한 사인데 축의금 \n얼마 내야 돼?"))
          .padding(.horizontal, 16)

        VStack(alignment: .center, spacing: 16) {
          ParticipantsAndDateView(property: .init())
            .padding(.horizontal, 16)
        }
      }

      Spacer()
    }
    .frame(maxWidth: .infinity)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
