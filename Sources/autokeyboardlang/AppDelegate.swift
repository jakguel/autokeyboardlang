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
import AutokbiswCore

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let useLocation: Bool
    private let verbosity: Int
    private var monitor: IOKeyEventMonitor?
    private var menuBar: MenuBarController?

    init(useLocation: Bool, verbosity: Int) {
        self.useLocation = useLocation
        self.verbosity = verbosity
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        menuBar = MenuBarController(appName: "autokeyboardlang", version: version)

        menuBar?.onEnableAutostart = { [weak self] in
            try? AutostartManager.enable()
            self?.refreshMenu()
        }

        guard InputMonitoringPermission.isGranted else {
            menuBar?.update(state: .init(hasPermission: false, currentInputSource: "", keyboards: [],
                                         isAutostart: AutostartManager.isEnabled))
            InputMonitoringPermission.request()
            return
        }

        monitor = IOKeyEventMonitor(
            usagePage: 0x01,
            usage: 6,
            useLocation: useLocation,
            verbosity: verbosity
        )
        monitor?.start()
        refreshMenu()

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(onMonitorStateChanged),
            name: NSNotification.Name(IOKeyEventMonitor.settingsChangedNotificationName),
            object: nil
        )
    }

    @objc private func onMonitorStateChanged() {
        refreshMenu()
    }

    private func refreshMenu() {
        guard let monitor else { return }
        menuBar?.update(state: .init(
            hasPermission: true,
            currentInputSource: monitor.currentInputSourceName,
            keyboards: monitor.knownKeyboards,
            isAutostart: AutostartManager.isEnabled
        ))
    }
}
