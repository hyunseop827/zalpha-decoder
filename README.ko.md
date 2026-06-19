# Zalpha Decoder

[English README](README.md)

Zalpha Decoder는 Alpha + Z세대를 뜻하는 Zalpha와 해독기를 뜻하는 Decoder를 합친 이름입니다.  

Zalpha Decoder는 Storyboard 기반 UIKit iOS 앱입니다. 입력된 문장을 선택한 스타일과 대상 언어에 맞게 번역하고, 주요 표현을 함께 설명합니다.  

AI 응답은 Firebase AI Logic과 Gemini를 사용해 구현했습니다. 또한 디코드 기록을 로컬에 저장하고, 학습할 대상 언어 표현을 단어장처럼 저장할 수 있습니다.

## 데모 비디오 - 클릭 시, 유튜브로 연결됩니다.

[![Zalpha Decoder Demo](https://img.youtube.com/vi/FZlDrd5T-ns/0.jpg)](https://www.youtube.com/watch?v=FZlDrd5T-ns)

## 주요 기능

- Firebase AI Logic + Gemini 기반 디코드/번역 기능
- 원본 언어: `자동`, `영어`, `한국어`, `일본어`, `스페인어`, `러시아어`
- 대상 언어: `영어`, `한국어`, `일본어`, `스페인어`, `러시아어`
- 스타일 선택: `격식`, `기본`, `잘파`
- 슬랭, 관용 표현, 밈 표현, 축약어, 문화적 표현에 대한 디코드 노트 생성
- 로컬 기록 최대 50개 저장
- 단어장에서 저장 표현 검색, 상세 보기, 예문 생성, 복사, 삭제 지원
- 저장 표현별 예문 최대 3개 생성 가능
- 라이트/다크 모드 UI 및 앱 아이콘 지원

## 스크린샷

### 앱 아이콘

| 라이트 | 다크 |
| --- | --- |
| <img src="assets/icon-light.png" alt="Zalpha Decoder light app icon" width="120"> | <img src="assets/icon-dark.png" alt="Zalpha Decoder dark app icon" width="120"> |

### 기능 화면

#### 1. 메인 화면

메인 화면에서는 입력/출력 언어 선택, 스타일 선택, 입력창, Decode 버튼, 출력 영역, 디코드 노트를 제공합니다.

| 라이트 모드 | 다크 모드 |
| --- | --- |
| <img src="images/main-light.PNG" alt="Main screen in light mode" width="260"> | <img src="images/main-dark.PNG" alt="Main screen in dark mode" width="260"> |

#### 2. 디코드 결과

`Decode` 버튼을 누르면 Gemini가 선택한 스타일에 맞는 번역 결과와 구조화된 디코드 노트를 반환합니다.

| 번역 결과 | 디코드 노트 |
| --- | --- |
| <img src="images/main-translation1.PNG" alt="Main translation result" width="260"> | <img src="images/main-translation2.PNG" alt="Main translation notes" width="260"> |

#### 3. 기록

디코드 결과는 로컬에 저장됩니다. `기록`에서는 최근 기록 요약을 확인하고, 상세 화면에서는 전체 입력/출력을 볼 수 있습니다.

| 기록 | 기록 상세 |
| --- | --- |
| <img src="images/history.PNG" alt="History list" width="260"> | <img src="images/history-detail.PNG" alt="History detail" width="260"> |

#### 4. 단어장

단어장에서는 저장한 표현을 볼 수 있습니다. 이때 예문 생성 버튼을 통해 해당 표현이 들어간 자연스러운 문장을 볼 수 있습니다.

| 단어장 | 단어 상세 | 예문 생성 |
| --- | --- | --- |
| <img src="images/saved-slangs.PNG" alt="Saved slangs list" width="220"> | <img src="images/saved-slangs-detail.PNG" alt="Saved slang detail" width="220"> | <img src="images/saved-slang-detail-generate.PNG" alt="Generated saved slang example" width="220"> |

## 기술 스택

| 구분 | 기술 |
| --- | --- |
| 언어 | ![Swift](https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=swift&logoColor=white) |
| 화면 구성 | ![UIKit](https://img.shields.io/badge/UIKit-000000?style=for-the-badge&logo=apple&logoColor=white) ![Storyboard](https://img.shields.io/badge/Storyboard-147EFB?style=for-the-badge&logo=xcode&logoColor=white) |
| AI | ![Firebase AI Logic](https://img.shields.io/badge/Firebase%20AI%20Logic-FFCA28?style=for-the-badge&logo=firebase&logoColor=black) ![Gemini](https://img.shields.io/badge/Gemini-8E75B2?style=for-the-badge&logo=googlegemini&logoColor=white) |
| 로컬 저장 | ![UserDefaults](https://img.shields.io/badge/UserDefaults-6E6E73?style=for-the-badge&logo=apple&logoColor=white) ![Codable JSON](https://img.shields.io/badge/Codable%20JSON-0A84FF?style=for-the-badge&logo=swift&logoColor=white) |
| 다국어 문자열 | ![Localizable.strings](https://img.shields.io/badge/Localizable.strings-34C759?style=for-the-badge&logo=apple&logoColor=white) |

## 프로젝트 구조

```text
ZalphaDecoder/
  AIService.swift                         # 프롬프트, Gemini 요청, 응답 파싱 흐름 조정
  FirebaseAITextClient.swift              # Firebase AI Logic 호출 클라이언트
  AIServicePromptBuilder.swift            # 디코드 및 예문 생성 프롬프트 생성
  AIServiceResponseParser.swift           # JSON 응답 파싱
  DecodeLanguage.swift                    # 지원 언어 옵션
  TranslationStyle.swift                  # 격식, 기본, 잘파 스타일
  ViewController.swift                    # 메인 디코드 화면
  HistoryViewController.swift             # 로컬 디코드 기록 목록
  HistoryDetailViewController.swift       # 디코드 상세 및 노트 화면
  SavedSlangsViewController.swift         # 저장 표현 목록 및 검색
  SavedSlangDetailViewController.swift    # 저장 표현 상세 및 예문
  Base.lproj/Main.storyboard              # Storyboard 기반 UI
  Assets.xcassets/                        # 앱 아이콘 및 이미지 리소스
```

## Firebase 설정

이 프로젝트는 로컬 Firebase 설정 파일이 필요합니다.

```text
ZalphaDecoder/GoogleService-Info.plist
```

실제 `GoogleService-Info.plist`는 커밋하지 않습니다. `ZalphaDecoder/GoogleService-Info.example.plist`를 참고하고, 실제 파일은 Firebase Console에서 다운로드해야 합니다.

Firebase Console에서 Firebase AI Logic을 활성화하고 Gemini 설정을 완료해야 합니다.
