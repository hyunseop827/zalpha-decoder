# Zalpha Decoder

[한국어 README](README.ko.md)

Zalpha Decoder is named by combining Zalpha, meaning Alpha + Gen Z, and Decoder.

Zalpha Decoder is a Storyboard-based UIKit iOS app that translates input text into a selected style and target language, while also explaining key expressions.

AI responses are implemented with Firebase AI Logic and Gemini. The app also stores local decode history and saved target-language expressions for later review.

## Demo Video - Click to open YouTube

[![Zalpha Decoder Demo](https://img.youtube.com/vi/FZlDrd5T-ns/0.jpg)](https://www.youtube.com/watch?v=FZlDrd5T-ns)

## Features

- Decode and translate short text with Firebase AI Logic + Gemini
- Source language: `Auto`, `English`, `Korean`, `Japanese`, `Spanish`, `Russian`
- Target language: `English`, `Korean`, `Japanese`, `Spanish`, `Russian`
- Style selection: `Formal`, `Plain`, `Zalpha`
- AI-generated notes for meaningful slang, idioms, meme expressions, abbreviations, and culturally loaded phrases
- Local history storage for up to 50 records
- Saved Slangs screen with search, detail view, generated examples, copy, and delete actions
- Up to 3 generated examples for each saved expression
- Light/dark mode UI and app icon support

## Screenshots

### App Icon

| Light | Dark |
| --- | --- |
| <img src="assets/icon-light.png" alt="Zalpha Decoder light app icon" width="120"> | <img src="assets/icon-dark.png" alt="Zalpha Decoder dark app icon" width="120"> |

### Feature Walkthrough

#### 1. Main Screen

The main screen contains the source/target language controls, style selection, input box, decode button, output box, and decode notes area.

| Light Mode | Dark Mode |
| --- | --- |
| <img src="images/main-light.PNG" alt="Main screen in light mode" width="260"> | <img src="images/main-dark.PNG" alt="Main screen in dark mode" width="260"> |

#### 2. Decode Result

After tapping `Decode`, Gemini returns a style-aware translation and structured decode notes for meaningful expressions.

| Translation Result | Decode Notes |
| --- | --- |
| <img src="images/main-translation1.PNG" alt="Main translation result" width="260"> | <img src="images/main-translation2.PNG" alt="Main translation notes" width="260"> |

#### 3. History

Successful decodes are saved locally. The history list shows recent input/output summaries, and the detail screen shows the full decode result and notes.

| History List | History Detail |
| --- | --- |
| <img src="images/history.PNG" alt="History list" width="260"> | <img src="images/history-detail.PNG" alt="History detail" width="260"> |

#### 4. Saved Slangs

Decode notes can be saved as target-language expressions. Saved Slangs supports local search, detail view, copy, delete, and example generation.

| Saved Slangs | Saved Slang Detail | Generated Example |
| --- | --- | --- |
| <img src="images/saved-slangs.PNG" alt="Saved slangs list" width="220"> | <img src="images/saved-slangs-detail.PNG" alt="Saved slang detail" width="220"> | <img src="images/saved-slang-detail-generate.PNG" alt="Generated saved slang example" width="220"> |

## Tech Stack

| Category | Tech |
| --- | --- |
| Language | ![Swift](https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=swift&logoColor=white) |
| UI | ![UIKit](https://img.shields.io/badge/UIKit-000000?style=for-the-badge&logo=apple&logoColor=white) ![Storyboard](https://img.shields.io/badge/Storyboard-147EFB?style=for-the-badge&logo=xcode&logoColor=white) |
| AI | ![Firebase AI Logic](https://img.shields.io/badge/Firebase%20AI%20Logic-FFCA28?style=for-the-badge&logo=firebase&logoColor=black) ![Gemini](https://img.shields.io/badge/Gemini-8E75B2?style=for-the-badge&logo=googlegemini&logoColor=white) |
| Local Storage | ![UserDefaults](https://img.shields.io/badge/UserDefaults-6E6E73?style=for-the-badge&logo=apple&logoColor=white) ![Codable JSON](https://img.shields.io/badge/Codable%20JSON-0A84FF?style=for-the-badge&logo=swift&logoColor=white) |
| Localization | ![Localizable.strings](https://img.shields.io/badge/Localizable.strings-34C759?style=for-the-badge&logo=apple&logoColor=white) |

## Project Structure

```text
ZalphaDecoder/
  AIService.swift                         # Prompt, Gemini request, and response parsing coordinator
  FirebaseAITextClient.swift              # Firebase AI Logic client
  AIServicePromptBuilder.swift            # Decode and example-generation prompts
  AIServiceResponseParser.swift           # JSON response parsing
  DecodeLanguage.swift                    # Supported language options
  TranslationStyle.swift                  # Formal, Plain, Zalpha styles
  ViewController.swift                    # Main decode screen
  HistoryViewController.swift             # Local decode history list
  HistoryDetailViewController.swift       # Decode detail and notes
  SavedSlangsViewController.swift         # Saved slang list and search
  SavedSlangDetailViewController.swift    # Saved slang detail and examples
  Base.lproj/Main.storyboard              # Main storyboard UI
  Assets.xcassets/                        # App assets and app icons
```

## Firebase Setup

This project requires a local Firebase config file:

```text
ZalphaDecoder/GoogleService-Info.plist
```

Do not commit the real `GoogleService-Info.plist`. Use `ZalphaDecoder/GoogleService-Info.example.plist` as a reference, then download the real file from Firebase Console.

Firebase AI Logic must be enabled in Firebase Console and configured for Gemini.
