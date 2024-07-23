
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "KakaoLogin",
  targets: .custom(
    name: "KakaoLogin",
    product: .framework,
    dependencies: [
      .thirdParty(.KakaoSDK),
    ],
    infoPlist: [
      // KAKAO InfoPlist
      "LSApplicationQueriesSchemes":
        .dictionary([
          // 카카오톡으로 로그인
          "item 0": "kakaokompassauth",
          // 카카오톡 공유
          "item 1": "kakaolink",
        ]),
      "CFBundleURLTypes":
        .array([
          .dictionary([
            "CFBundleURLSchemes":
              .array([
                .string("kakao${NATIVE_APP_KEY}"),
              ]),
          ]),
        ]),
      "NATIVE_APP_KEY": "${NATIVE_APP_KEY}",
    ]
  )
)
