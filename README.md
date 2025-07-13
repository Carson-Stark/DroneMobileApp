
# Greta Command Center

This is a fork of this [MavSDK example app](https://github.com/mavlink/MAVSDK-Swift-Example) that has been modified to support custom mission commands and TCP communication. The app allows users to send specific commands to a drone or connected system via a TCP client, enhancing the functionality of the original MAVSDK example. Built specifically for [this autonomous drone project](https://github.com/Carson-Stark/AutonomousDrone).

<img width="2554" height="1171" alt="Screenshot 2025-07-13 185621" src="https://github.com/user-attachments/assets/c3a5685d-67d7-4020-9765-57f3eadccd07" />

<img width="2532" height="1154" alt="Screenshot 2025-07-13 185557" src="https://github.com/user-attachments/assets/c692914b-81fc-482e-997c-8601b22d83a8" />

## Custom Modifications

### TCP Communication Integration

This app has been extended to support TCP communication for sending custom mission commands and control messages. The TCP client is initialized and managed in `Mavsdk_Swift_ExampleApp.swift`. TCP connectivity is used in the action menu to send commands to the drone or connected systems.

Key files involved:
- `Mavsdk_Swift_ExampleApp.swift`: Initializes the TCP client.
- `App/Menu/Actions/ActionsViewModel.swift`: Implements custom mission actions that send TCP messages when connected.
- `App/TelemetryDetail/MissionStatusView.swift` and `App/TelemetryDetail/StatusBar.swift`: Observe TCP client status for UI updates.
- `App/Menu/Connection/ConnectionView.swift` and `CommLinkStartView.swift`: Manage connection URIs including TCP addresses.

### UI Changes and Custom Mission Buttons

The action menu UI has been updated to include new buttons for custom missions such as "Pickup Poop", "Land on Bag", "Fly to Position", and others. These buttons are defined in the SwiftUI view `App/Menu/Actions/ActionsView.swift` and their corresponding actions are implemented in `ActionsViewModel.swift`.

Key files involved:
- `App/Menu/Actions/ActionsView.swift`: Defines the UI for the action buttons.
- `App/Menu/Actions/ActionsViewModel.swift`: Contains the logic for each button's action, including sending TCP messages or invoking drone SDK commands.

These modifications enable enhanced control and mission customization through the app's UI and network communication.

---

# Original Readme for MAVSDK-Swift Example 

![Simulator Screen Shot - iPad Pro (11-inch) (2nd generation) - 2021-06-17 at 13 00 45](https://user-images.githubusercontent.com/15242786/122464761-158e5880-cf6c-11eb-9b72-671ca75619f3.png)

### Getting started

1. Create the Xcode project file from `project.yml` with [xcodegen](https://github.com/yonaskolb/XcodeGen) (that can be installed with Homebrew: `$ brew install xcodegen`):

```
xcodegen
```

2. Open `MAVSDK-Swift-Example.xcodeproj` with Xcode.
3. Set the signing team in the "General" tab of target `MAVSDK-Swift-Example`
