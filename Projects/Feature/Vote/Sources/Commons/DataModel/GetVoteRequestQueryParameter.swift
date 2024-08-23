//
//  GetVoteRequestQueryParameter.swift
//  Vote
//
//  Created by MaraMincho on 8/23/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct GetVoteRequestQueryParameter: Encodable {
  /// 제목
  var content: String?
  /// 본인 글 소유 여부
  var mine: Bool?
  /// 정렬 기준 / 최신순 : LATEST, 투표 많은 순 : POPULAR
  var sortType: SortType?
  /// 보드 id
  var boardID: Int64?
  /// 페이지, 페이지 0 부터 시작
  var page: Int32?
  /// 페이지 사이즈, default 10
  var size: Int32?
  /// 정렬 조건 (정렬은 SortType이용하길 바람)
  var sort: Sort?

  var queryParameters: [String: Any] {
    var res: [String: Any] = [:]
    if let content {
      res["content"] = content
    }

    if let mine {
      res["mine"] = mine
    }
    if let sortType {
      res["sortType"] = sortType.rawValue
    }
    if let boardID {
      res["boardID"] = boardID
    }
    if let page {
      res["page"] = page
    }
    if let size {
      res["size"] = size
    }
    if let sort {
      res["sort"] = sort.rawValue
    }

    return res
  }

  enum SortType: String, Encodable {
    /// 최신순
    case LATEST
    /// 투표 많은 순
    case POPULAR
  }

  enum Sort: String, Encodable {
    case latest = "createdAt, desc"
    case old = "createdAt, asc"
  }
}
