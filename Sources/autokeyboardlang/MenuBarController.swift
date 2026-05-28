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

import AppKit

// NSObject is required for #selector and @objc methods
@available(macOS 11.0, *)
final class MenuBarController: NSObject {
    private let statusItem: NSStatusItem
    private let appName: String
    private let version: String

    init(appName: String, version: String) {
        self.appName = appName
        self.version = version
        // let-properties MUST be initialized before super.init() (Swift Phase-1)
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        super.init()
        // Configuration after super.init() is allowed
        statusItem.button?.image = NSImage(systemSymbolName: "keyboard",
                                           accessibilityDescription: appName)
    }

    struct State {
        var hasPermission: Bool
        var currentInputSource: String
        var keyboards: [(id: String, isEnabled: Bool)]
    }

    func update(state: State) {
        let menu = NSMenu()

        if !state.hasPermission {
            let item = NSMenuItem(
                title: "⚠ Fehlende Berechtigungen",
                action: #selector(openInputMonitoringSettings),
                keyEquivalent: ""
            )
            item.target = self
            menu.addItem(item)
            menu.addItem(.separator())
        }

        let header = NSMenuItem(title: "\(appName) v\(version)", action: nil, keyEquivalent: "")
        header.isEnabled = false
        menu.addItem(header)
        menu.addItem(.separator())

        let src = state.currentInputSource.isEmpty ? "(unbekannt)" : state.currentInputSource
        let sourceItem = NSMenuItem(title: "Eingabequelle: \(src)", action: nil, keyEquivalent: "")
        sourceItem.isEnabled = false
        menu.addItem(sourceItem)
        menu.addItem(.separator())

        if state.keyboards.isEmpty {
            let emptyItem = NSMenuItem(title: "Keine Tastaturen erkannt", action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            menu.addItem(emptyItem)
        } else {
            for kb in state.keyboards {
                let prefix = kb.isEnabled ? "✓" : "✗"
                let item = NSMenuItem(title: "\(prefix) \(kb.id)", action: nil, keyEquivalent: "")
                item.isEnabled = false
                menu.addItem(item)
            }
        }

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Beenden", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    @objc private func openInputMonitoringSettings() {
        NSWorkspace.shared.open(
            URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_InputMonitoring")!
        )
    }
}
