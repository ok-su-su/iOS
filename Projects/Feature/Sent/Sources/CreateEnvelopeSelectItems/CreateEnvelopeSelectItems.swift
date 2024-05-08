//
//  CreateEnvelopeSelectItems.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation
import OSLog

@Reducer
struct CreateEnvelopeSelectItems<Item: CreateEnvelopeSelectItemable> {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false

    /// Add Custom Item TextField Button 의 TextField Text입니다.
    var customTitleText: String = ""
    
    /// customItem이 저장되거나 혹은 실행될 변수 입니다.
    @Shared var isCustomItem: Item?
    
    /// defaults로 펴현될 아이템들 입니다.
    @Shared var items: [Item]
    
    /// 선택된 ID들 입니다.
    @Shared var selectedID: [UUID]
    
    /// CustomItem을 저장했는지 나타내는 변수 입니다.
    /// 만약 사용자가 CustomItem을 저장했다면 변수가 True바뀝니다.
    /// 저장한 변수를 제거하는 버튼을 누를 경우 false로 바뀝니다.
    var customItemSaved: Bool = false
    
    /// 현재 TextFieldButton을 통해서 수정되고 있는지 여부를 나타냅니다.
    /// TextFieldButton을 통해 수정할 경우 True로 바뀝니다.
    var isAddingNewItem: Bool = false

    /// 버튼을 통한 아이템을 선택하는 Reducer입니다.
    /// 생성자에 모든 변수들은 @Shared처리 되어서 부모에서 Shared로 선언되어야 합니다.
    /// - Parameters:
    ///   - items: defaults아이템들을 나타냅니다. 이는 CreateEnvelopeSelectItemable을 따라야 합니다.
    ///   - selectedID: 선택된 아이템들의 UUID를 나타내는 함수 입니다.
    ///   - isCustomItem: 사용자 입력을 통한 새로운 아이템을 받을지 여부를 나타냅니다.
    ///
    ///    isCustomItem을 Nil로 할 경우 "직접 입력" 버튼이 추가되지 않습니다.
    init(items: Shared<[Item]>, selectedID: Shared<[UUID]>, isCustomItem: Shared<Item?>) {
      _items = items
      _selectedID = selectedID
      _isCustomItem = isCustomItem
    }
  }

  enum Action: Equatable, FeatureAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedItem(id: UUID)
    case tappedAddCustomRelation
    case tappedTextFieldCloseButton
    case tappedTextFieldSaveAndEditButton
  }

  enum InnerAction: Equatable {
    case singleSelection(id: UUID)
    case multipleSelection(id: UUID)
    case startAddCustomRelation
    case endAddCustomRelation
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {
    case selected(id: [UUID])
  }

  var multipleSelectionCount = 1

  init(multipleSelectionCount: Int = 1) {
    self.multipleSelectionCount = multipleSelectionCount
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

        // MARK: - 사용자가 버튼을 눌렀을 경우에

      case let .view(.tappedItem(id)):

        // MARK: - 이미 선택된 버튼일 때

        if state.selectedID.contains(id) {
          state.selectedID = state.selectedID.filter { $0 != id }
          let curSelected = state.selectedID
          return .run { send in
            await send(.delegate(.selected(id: curSelected)))
          }
        }

        // MARK: - 한개의 버튼을 선택하는 화면일 때

        else if multipleSelectionCount == 1 {
          return .run { send in
            await send(.inner(.singleSelection(id: id)))
          }
        }

        // MARK: - 여러개의 버튼을 선택할 수 있을 때

        return .run { send in
          await send(.inner(.multipleSelection(id: id)))
        }

      case .delegate(.selected):
        return .none

      case let .inner(.singleSelection(id)):
        state.selectedID = [id]
        let curSelection = state.selectedID
        return .run { send in
          await send(.delegate(.selected(id: curSelection)))
        }

      case let .inner(.multipleSelection(id)):
        if state.selectedID.count + 1 <= multipleSelectionCount {
          state.selectedID.append(id)
        }
        // TODO: Some Logic to depend multiple Selection
        else {}
        let curSelection = state.selectedID
        return .run { send in
          await send(.delegate(.selected(id: curSelection)))
        }

      case .binding:
        return .none

      case .view(.tappedAddCustomRelation):
        return .run { send in
          await send(.inner(.startAddCustomRelation))
        }

      case .view(.tappedTextFieldCloseButton):
        state.customTitleText = ""
        if state.customItemSaved {
          return .run { send in
            await send(.inner(.endAddCustomRelation))
          }
        }
        return .none

      case .view(.tappedTextFieldSaveAndEditButton):
        state.customItemSaved.toggle()
        state.isCustomItem?.setTitle(state.customTitleText)
        return .none

      case .inner(.startAddCustomRelation):
        state.isAddingNewItem = true
        state.customTitleText = ""
        state.customItemSaved = false
        return .none

      case .inner(.endAddCustomRelation):
        state.isAddingNewItem = false
        return .none
      }
    }
  }
}
