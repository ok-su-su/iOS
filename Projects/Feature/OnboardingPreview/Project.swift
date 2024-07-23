
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "OnboardingPreview",
  targets: .app(
    name: "OnboardingPreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.onboarding),
    ],
    infoPlist: [
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
                .string("${KAKAO_NATIVE_APP_KEY}"),
              ]),
          ]),
        ]),
      "KAKAO_NATIVE_APP_KEY": "${KAKAO_NATIVE_APP_KEY}",
    ]
  )
)
