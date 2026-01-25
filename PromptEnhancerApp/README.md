# Prompt Enhancer macOS App

A lightweight macOS menu bar application that listens for `Cmd+E` globally,
captures selected text, sends it to a local enhancement API, and replaces it
with the enhanced response.

## Features

- **Global Keyboard Listener**: Listens for `Cmd+E` from any application
- **Text Capture**: Automatically captures selected text via clipboard
- **API Integration**: Sends text to `http://localhost:7172/api/enhance`
- **Text Replacement**: Replaces original text with API response
- **Menu Bar App**: Runs as a lightweight menu bar application
- **Accessibility Friendly**: Simulates keyboard shortcuts to copy/paste

## Requirements

- macOS 13.0 or later
- Swift 5.9 or later
- Local API running at `http://localhost:7172/api/enhance`
- Accessibility permissions granted (app will prompt on first run)

## Build & Run

### Using Swift Package Manager

```bash
cd PromptEnhancerApp
swift build -c release
./.build/release/PromptEnhancerApp
```

### Using Xcode

```bash
swift package generate-xcodeproj
open PromptEnhancerApp.xcodeproj
```

Then build and run from Xcode.

## Permissions

The app requires **Accessibility** permissions to:

- Listen to global keyboard events
- Simulate Cmd+C (copy) and Cmd+V (paste) commands
- Access selected text across applications

### Granting Permissions

1. Open System Preferences → Security & Privacy
2. Go to Accessibility
3. Add the app to the list (drag it there from Applications folder, or use the +
   button)
4. Restart the app

## API Endpoint

Expected request format:

```json
POST http://localhost:7172/api/enhance
Content-Type: application/json

{
  "text": "selected text here"
}
```

Expected response format:

```json
{
  "result": "enhanced text here"
}
```

Or plain text response will be used directly.

## Usage

1. Run the app (it will sit in the menu bar)
2. Select text in any application
3. Press `Cmd+E`
4. The app will capture the text, send it to the API, and replace it with the
   response
5. Monitor console logs to see requests and responses

## Troubleshooting

- **No response from API**: Check that your local API is running on port 7172
- **Text not being replaced**: Ensure accessibility permissions are granted
- **No text captured**: Make sure you have text selected before pressing Cmd+E
- **Check logs**: The app prints debug information to the console

## Architecture

- **main.swift**: Application entry point and AppDelegate
- **KeyboardMonitor.swift**: Global keyboard event listening and Cmd+E detection
- **APIClient.swift**: Handles POST requests to the enhancement API
- **PasteboardManager.swift**: Manages clipboard operations for text
  capture/replacement
