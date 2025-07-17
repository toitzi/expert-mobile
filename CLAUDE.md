# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS mobile application built with SwiftUI that uses OAuth 2.0 for authentication with a oauth server.

## Common Development Commands

### Building and Running
- Open `expert.xcodeproj` in Xcode
- Select target device/simulator and press Cmd+R to build and run
- The app connects to a local OAuth server at `http://localhost:3000`

### Testing
- Run unit tests: Cmd+U in Xcode
- Tests use Swift Testing framework (not XCTest)
- Test files are in `expertTests/` directory

## Architecture

### Authentication Flow
The app implements OAuth 2.0 with PKCE flow:
1. **AuthenticationManager** (expert/Features/Authentication/ViewModels/AuthenticationManager.swift:14) - Central auth state management
   - Handles login/logout, token refresh, and user info fetching
   - Stores tokens in Keychain via KeychainHelper
   - Implements automatic token refresh before expiry

2. **APIClient** (expert/Networking/APIClient.swift:11) - Network layer with auth integration
   - Automatically adds Bearer tokens to requests
   - Handles 401 responses with automatic token refresh and retry
   - Provides convenient async/await methods for GET, POST, PUT, DELETE

### Key Components

- **Configuration** (expert/Constants/Configuration.swift:10) - Centralized app configuration
  - OAuth settings (issuer, client ID, redirect URI, scopes)
  - API resource server URL
  - Currently configured for localhost:3000

- **KeychainHelper** (expert/Storage/KeychainHelper.swift) - Secure token storage

### App Structure
```
expert/
├── App/                    # App entry point and main views
├── Features/              # Feature modules
│   └── Authentication/    # OAuth implementation
├── Networking/           # API client and network layer
├── Storage/             # Keychain and persistent storage
├── Constants/          # App configuration
├── Extensions/        # Swift extensions
├── Views/            # Reusable UI components
└── Utils/           # Utility functions
```

### Important Implementation Details

1. The app uses `ASWebAuthenticationSession` for OAuth login
2. Tokens are refreshed automatically 1 minute before expiry
3. The app refreshes user info when becoming active
4. OAuth callback scheme: `com.expert.oauth://callback`
5. All API requests go through APIClient for consistent auth handling

## Development Notes

- The app expects a local OAuth server running on http://localhost:3000
- Client ID is hardcoded in Configuration.swift
- Tests use the new Swift Testing framework (@Test attribute)
