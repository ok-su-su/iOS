//
//  VoteProgressBar.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI
import Designsystem

struct VoteProgressBar: View {
  var property: VoteProgressBarProperty
  var body: some View {
    let progress = property.showVoteProgressBarProperty
    HStack(alignment: .center, spacing: 0) {
      // if voted, add check image
      if let progress = progress , progress.isVoted {
        SSImage
          .commonCheckBox
          .resizable()
          .frame(width: 20, height: 20)
      }
      
      Text(property.title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray100)
      
      if let progress {
        HStack(spacing: 8) {
          Text(progress.participantCountText)
            .modifier(SSTypoModifier(.text_xxxs))
          
          Text(progress.)
        }
        
        
          
      }
      
    }
    .frame(maxWidth: .infinity, alignment: .center)
    .background(Color(red: 1, green: 0.97, blue: 0.92))
    .cornerRadius(4)
  }
}

struct VoteProgressBarProperty: Equatable {
  var title: String
  var showVoteProgressBarProperty: ShowVoteProgressBarProperty?
  struct ShowVoteProgressBarProperty: Equatable {
    var progress: Int
    var showProgress: Bool
    var participantsCount: Int
    var isVoted: Bool
    
    var participantCountText: String {
      return "\(participantsCount)명"
    }
    var progressText: String {
      return "\(progress.debugDescription)%"
    }
  }
  init(title: String, showVoteProgressBarProperty: ShowVoteProgressBarProperty? = nil) {
    self.title = title
    self.showVoteProgressBarProperty = showVoteProgressBarProperty
  }
}


