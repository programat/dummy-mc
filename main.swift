import AppKit

final class DummyMC: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private var window: NSWindow?
    private var selectedOffset = 0

    func applicationDidFinishLaunching(_ notification: Notification) {
        let menu = NSMenu()
        let moderateOffset = 4500
        for (title, offset) in [("Off", 0), ("Moderate", moderateOffset), ("Strong", 7000)] {
            let item = NSMenuItem(title: title, action: #selector(selectZoom(_:)), keyEquivalent: "")
            item.target = self
            item.tag = offset
            menu.addItem(item)
        }
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit Dummy MC", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

        statusItem.button?.image = NSImage(systemSymbolName: "rectangle.3.group", accessibilityDescription: "Dummy MC")
        statusItem.button?.setAccessibilityLabel("Dummy MC")
        statusItem.menu = menu
        setZoom(moderateOffset)
    }

    @objc private func selectZoom(_ item: NSMenuItem) {
        setZoom(item.tag)
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        setZoom(selectedOffset)
    }

    private func setZoom(_ offset: Int) {
        selectedOffset = offset
        window?.close()
        window = nil

        let screens = NSScreen.screens
        if offset > 0, let primary = screens.first {
            let top = screens.map { $0.frame.maxY }.max() ?? primary.frame.maxY
            let frame = NSRect(x: primary.frame.minX - CGFloat(offset),
                               y: top + CGFloat(offset) - 1,
                               width: 1, height: 1)
            let helper = NSWindow(contentRect: frame, styleMask: .borderless,
                                  backing: .buffered, defer: true)
            helper.title = "Dummy MC"
            helper.ignoresMouseEvents = true
            helper.isReleasedWhenClosed = false
            helper.animationBehavior = .none
            // Mission Control must count the off-screen window in its overview.
            helper.collectionBehavior = [.canJoinAllSpaces, .managed, .ignoresCycle]
            if screens.allSatisfy({ !$0.frame.intersects(helper.frame) }) {
                helper.setIsVisible(true)
                window = helper
            }
        }

        let activeOffset = window == nil ? 0 : offset
        for item in statusItem.menu?.items ?? [] where item.action == #selector(selectZoom(_:)) {
            item.state = item.tag == activeOffset ? .on : .off
        }
    }
}

let app = NSApplication.shared
let zoom = DummyMC()
app.delegate = zoom
app.run()
