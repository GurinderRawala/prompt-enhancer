## Prompt Enhancer

Prompt Enhancer is a macOS menu bar app plus a small TypeScript backend that helps you turn rough, informal text into a clear, well‑structured prompt for an AI coding assistant.

Once everything is running, you can select any text on your Mac, press `Cmd + E`, and the app will send that text to the backend. The backend rewrites it into an improved, “LLM‑friendly” prompt (fixing grammar and tone, organizing instructions, and sanitizing sensitive details in code blocks) and then replaces your original selection with the enhanced version.

---

## Components

- **macOS app** (status bar app)
  - Lives in the menu bar with a "PE" icon.
  - Listens globally for `Cmd + E`.
  - Captures the currently selected text and replaces it with the enhanced prompt.

- **Backend API** (TypeScript + Express)
  - Runs on `http://localhost:7172`.
  - Exposes `POST /api/enhance` and `POST /api/enhancer`.
  - Uses OpenAI to rewrite your text into a clear, structured coding prompt.

---

## Prerequisites

- macOS 13 or later.
- Xcode installed (for building and running the macOS app).
- Node.js and Yarn installed (for the backend).
- An OpenAI API key (set in `.env`).

---

## Backend Setup

All backend files live in the repository root (e.g. `package.json`, `src/index.ts`).

1. **Install dependencies**

   From the repo root:

   ```bash
   yarn install
   ```

2. **Configure environment variables**

   Create a `.env` file in the repo root (if it does not already exist):

   ```bash
   OPENAI_API_KEY=your_openai_api_key_here
   # Optional
   LOG_LEVEL=info
   ```

   The `.env` file is already ignored in version control.

3. **Start the backend server**

   From the repo root:

   ```bash
   yarn dev
   ```

   The backend will start on `http://localhost:7172` and log requests using Winston.

---

## macOS App Setup (Xcode)

The macOS app code is under `PromptEnhancerApp/`.

1. **Open the project in Xcode**
   - In Xcode, choose **File → Open…**.
   - Select `PromptEnhancerApp/Package.swift`.
   - Xcode will load the Swift package as a project with an executable target.

2. **Select the scheme and build**
   - In the Xcode toolbar, select the `PromptEnhancerApp` scheme.
   - Choose your Mac (My Mac) as the run destination.
   - Press **Run** (▶) to build and launch the app.

3. **Grant Accessibility permissions**

   The app needs Accessibility and input permissions to listen for `Cmd + E` globally and to simulate copy/paste:
   - When macOS prompts that the app wants to control your computer, click **Open System Settings**.
   - In **Privacy & Security → Accessibility**, add/enable the built app if it is not already enabled.
   - If prompted for **Input Monitoring**, also enable the app there.

4. **Verify the app is running**
   - After launching, you should see a **PE** icon in the macOS menu bar.
   - The app does not show a main window; it is a background status bar app.

---

## Using the Prompt Enhancer

Once both the backend and the macOS app are running:

1. Make sure the backend is running:

   ```bash
   yarn dev
   ```

2. Confirm the macOS app is active (the **PE** icon is visible in the menu bar).

3. In any app on your Mac (editor, browser, etc.):
   - Select the text you want to enhance.
   - Press `Cmd + E`.

4. Behavior:
   - If no text is selected, the app shows a small toast notification asking you to select text.
   - If text is selected, the app sends it to the backend.
   - The backend rewrites it into a cleaner, AI‑friendly prompt.
   - The app then replaces your selected text with the enhanced prompt automatically.

This makes it easy to refine prompts while asking an AI to perform coding tasks: you write a rough prompt, select it, press `Cmd + E`, and continue working with the improved version that appears in place.
