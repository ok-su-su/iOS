
import Alamofire
import Foundation
import Moya
import OSLog
import SSPersistancy

// MARK: - TokenInterceptHelpable

public protocol TokenInterceptHelpable: Sendable {
  func getToken() -> (accessToken: String, refreshToken: String)?
  func getTokenData() throws -> Data
  var accessTokenString: String { get }
  var refreshTokenString: String { get }
}

// MARK: - TokenInterceptHelper

final class TokenInterceptHelper: TokenInterceptHelpable, Sendable {
  init() {}

  private let keyChainShared = SSKeychain.shared
  private let jsonEncoder = JSONEncoder()
  let accessTokenString = "X-SUSU-AUTH-TOKEN"
  let refreshTokenString = "refreshToken"

  func getToken() -> (accessToken: String, refreshToken: String)? {
    do {
      let token = try SSTokenManager.shared.getToken()
      return (token.accessToken, token.refreshToken)
    } catch {
      os_log("Interceptor에 활용하기 위한\(#function) 토큰이 존재하지 않습니다.\n\(error)")
      return nil
    }
  }

  func getTokenData() throws -> Data {
    guard let (accessToken, refreshToken) = getToken() else {
      throw TokenNetworkingError.noSavedToken
    }
    let body = try jsonEncoder.encode(RefreshRequestBodyDTO(accessToken, refreshToken))
    return body
  }
}

// MARK: - SSTokenInterceptor

public struct SSTokenInterceptor: RequestInterceptor, Sendable {
  public static let shared: SSTokenInterceptor = .init(helper: TokenInterceptHelper())

  var helper: TokenInterceptHelpable
  var statusActor: TokenRequestActor = .init(requestProgressStatus: .notProgress)

  private init(helper: TokenInterceptHelpable) {
    self.helper = helper
  }

  public func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
    // 토큰이 저장되어있는지 확인합니다.
    guard let (accessToken, _) = helper.getToken() else {
      completion(.success(urlRequest))
      return
    }
    // 토큰을 전달합니다.
    var mutalURLRequest = urlRequest
    mutalURLRequest.setValue(accessToken, forHTTPHeaderField: helper.accessTokenString)
    completion(.success(mutalURLRequest))
  }

  public func retry(_ request: Request, for _: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
    guard
      let response = request.task?.response as? HTTPURLResponse,
      response.statusCode == 401
    else {
      completion(.doNotRetryWithError(error))
      return
    }
    refreshTokenWithNetworking(completion)
  }

  public func refreshTokenWithNetworking(_ completion: @escaping (RetryResult) -> Void) {
    do {
      let body: Data = try helper.getTokenData()
      let refreshProvider = MoyaProvider<RefreshTokenTargetType>()

      refreshProvider.request(.init(bodyData: body)) { responseResult in
        refreshTokenResponse(result: responseResult, completion: completion)
      }
    } catch {
      completion(.doNotRetryWithError(error))
    }
  }

  public func refreshTokenResponse(result: Result<Response, MoyaError>, completion: @escaping (RetryResult) -> Void) {
    // 현재 토큰 재발급중인지 확인
    if statusActor.getProgressStatus() == .progress {
      completion(.doNotRetry)
      return
    }
    // progressStatus 변경
    statusActor.setProgressStatus(.progress)
    do {
      switch result {
      case let .success(response):
        let responseDTO = try response.map(RefreshResponseDTO.self, failsOnEmptyData: true)
        try SSTokenManager.shared.saveToken(.init(
          accessToken: responseDTO.accessToken,
          accessTokenExp: responseDTO.accessTokenExp,
          refreshToken: responseDTO.refreshToken,
          refreshTokenExp: responseDTO.refreshTokenExp
        ))
        // progressStatus 변경
        statusActor.setProgressStatus(.notProgress)
        completion(.retry)
      case let .failure(error):
        completion(.doNotRetryWithError(SSTokenRetryError.failedRetryTokenRequest(error)))
      }
    } catch {
      completion(.doNotRetryWithError(SSTokenRetryError.failedRetryTokenRequest(error)))
    }
  }
}

public extension SSTokenInterceptor {
  func refreshTokenWithNetwork() async throws {
    let body: Data = try helper.getTokenData()
    let refreshProvider = MoyaProvider<RefreshTokenTargetType>()
    let response: SSToken = try await refreshProvider.request(.init(bodyData: body))
    try SSTokenManager.shared.saveToken(response)
  }

  func isValidToken() async throws {
    let provider = MoyaProvider<ValidTokenTargetType>(session: .init(interceptor: self))
    try await provider.request(.init())
  }

  func healthCheck() async {
    let customEndpointClosure = { (target: HealthCheck) -> Endpoint in
      return Endpoint(
        url: URL(target: target).absoluteString,
        sampleResponseClosure: { .networkError(NSError(domain: "TokenInvalid", code: 401, userInfo: nil)) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
      )
    }
    let provider = MoyaProvider<HealthCheck>(endpointClosure: customEndpointClosure, session: Session(interceptor: SSTokenInterceptor.shared))
    do {
      let responseDTO: healthCheckResponseDTO = try await provider.request(.init())
      os_log("responseDTO Message: \(responseDTO.message)")
    } catch {
      os_log("\(error)")
    }
  }

  func setUserNameByAccessToken() async throws {
    let provider = MoyaProvider<MyInfoTargetType>(session: .init(interceptor: Self.shared))
    let response: UserInfoResponse = try await provider.request(.init())
    let userID = response.id
    try SSTokenManager.shared.saveUserID(userID)
  }
}

// MARK: - UserInfoResponse

private struct UserInfoResponse: Decodable {
  let id: Int64
}

// MARK: - TokenRequestActor

final class TokenRequestActor: @unchecked Sendable {
  private var requestProgressStatus: TokenRequestActorStatus

  func getProgressStatus() -> TokenRequestActorStatus {
    requestProgressStatus
  }

  init(requestProgressStatus: TokenRequestActorStatus) {
    self.requestProgressStatus = requestProgressStatus
  }

  func setProgressStatus(_ status: TokenRequestActorStatus) {
    switch status {
    case .progress:
      requestProgressStatus = status
    case .notProgress:
      DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        self.requestProgressStatus = status
      }
    }
  }
}

// MARK: - SSTokenRetryError

enum SSTokenRetryError: Error, Sendable {
  case failedRetryTokenRequest(Error)
}

// MARK: - TokenRequestActorStatus

enum TokenRequestActorStatus: Equatable, Sendable, CaseIterable {
  case progress
  case notProgress
}
