# Zalpha Decoder

Zalpha Decoder is a small iOS UIKit app that decodes short Korean or English text into a clearer, style-aware translation.

The app is built with Storyboard-based UIKit and uses Firebase AI Logic with the Gemini Developer API for AI responses.

## Current Features

- Korean and English language selection
- Source/target language swap
- Style selection: `Clean`, `Plain`, `Casual`, `Zalpha`
- 100-character input limit
- Firebase AI Logic connection through `AIService`
- Output copy button with toast feedback
- Light and dark mode UI support
- Light and dark app icon variants

## Tech Stack

- Swift
- UIKit
- Storyboard
- Firebase Core
- Firebase AI Logic
- Firebase Functions
- Gemini Developer API

## Project Structure

```text
ZalphaDecoder/
  AIService.swift                  # Firebase AI Logic / Gemini calls
  ViewController.swift             # Main screen outlets, state, and actions
  ViewController+AI.swift          # Decode button flow and loading state
  ViewController+Styling.swift     # Dynamic colors and UI styling
  ViewController+Toast.swift       # Toast UI
  Base.lproj/Main.storyboard       # Main storyboard UI
  Assets.xcassets/AppIcon.appiconset/
```

## Firebase Setup

This project requires a local Firebase config file:

```text
ZalphaDecoder/GoogleService-Info.plist
```

That file is ignored by Git and should not be committed. Use `ZalphaDecoder/GoogleService-Info.example.plist` as a reference, then download the real file from Firebase Console.

Firebase AI Logic must also be enabled in Firebase Console, with a configured Gemini Developer API key.

## Current AI Status

The app is currently connected to Firebase AI Logic and can call Gemini successfully.

The first implementation uses a simple test prompt. The next step is replacing that test call with real decode behavior based on:

- input text
- source language
- target language
- selected style

## Korean Summary

Zalpha Decoder는 짧은 한국어/영어 문장을 선택한 스타일에 맞게 자연스럽게 디코딩하거나 번역하는 iOS 앱입니다. 현재 Firebase AI Logic과 Gemini Developer API 연결은 완료되었고, 다음 단계는 실제 Decode 프롬프트를 연결하는 것입니다.
