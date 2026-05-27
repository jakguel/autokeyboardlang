// Copyright 2024 Ole Hüter
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import IOKit.hid

/// Provides a clean interface for checking and requesting Input Monitoring (TCC) permission.
///
/// Input Monitoring permission is required for the app to receive HID keyboard events.
/// Without it, `IOHIDManagerOpen` silently fails and no keyboard events are delivered.
///
/// - Note: Do NOT call `AXIsProcessTrustedWithOptions()` before `request()` —
///   a known macOS bug causes the Input Monitoring request to silently fail if
///   the Accessibility API has been queried first in the same process.
public enum InputMonitoringPermission {

    /// Returns `true` if Input Monitoring permission is currently granted by the OS.
    ///
    /// Uses `IOHIDCheckAccess(kIOHIDRequestTypeListenEvent)` — the correct IOKit HID
    /// API for apps that monitor keyboard events via IOHIDManager.
    /// Non-blocking, no side effects.
    public static var isGranted: Bool {
        if #available(macOS 10.15, *) {
            return IOHIDCheckAccess(kIOHIDRequestTypeListenEvent) == kIOHIDAccessTypeGranted
        }
        return true
    }

    /// Requests Input Monitoring permission from the OS.
    ///
    /// Uses `IOHIDRequestAccess(kIOHIDRequestTypeListenEvent)` — adds the binary to
    /// System Settings → Privacy & Security → Input Monitoring and returns immediately.
    /// The user must manually enable the toggle.
    public static func request() {
        if #available(macOS 10.15, *) {
            IOHIDRequestAccess(kIOHIDRequestTypeListenEvent)
        }
    }
}
