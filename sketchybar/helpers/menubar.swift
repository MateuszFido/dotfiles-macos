// Open native menus from SketchyBar clicks through the Accessibility API, so they
// work while the macOS menu bar is hidden. Needs Accessibility access for SketchyBar.
//
//   menubar list         print the frontmost app's menu titles (File, Edit, ...), one per line
//   menubar press <n>    open the frontmost app's nth menu (0 = Apple menu, 1 = first of `list`)
//   menubar extra <id>   open a system menu extra, e.g. com.apple.menuextra.controlcenter
import AppKit
import ApplicationServices

func element(_ e: AXUIElement, _ name: String) -> AXUIElement? {
	var value: CFTypeRef?
	guard AXUIElementCopyAttributeValue(e, name as CFString, &value) == .success,
		let value, CFGetTypeID(value) == AXUIElementGetTypeID()
	else { return nil }
	return (value as! AXUIElement)
}

func children(_ e: AXUIElement) -> [AXUIElement] {
	var value: CFTypeRef?
	guard AXUIElementCopyAttributeValue(e, kAXChildrenAttribute as CFString, &value) == .success else { return [] }
	return value as? [AXUIElement] ?? []
}

func identifier(_ e: AXUIElement) -> String? {
	var value: CFTypeRef?
	guard AXUIElementCopyAttributeValue(e, "AXIdentifier" as CFString, &value) == .success else { return nil }
	return value as? String
}

func find(_ id: String, in e: AXUIElement, depth: Int = 3) -> AXUIElement? {
	if identifier(e) == id { return e }
	guard depth > 0 else { return nil }
	for child in children(e) {
		if let hit = find(id, in: child, depth: depth - 1) { return hit }
	}
	return nil
}

func appMenuItems() -> [AXUIElement] {
	guard let app = NSWorkspace.shared.frontmostApplication,
		let bar = element(AXUIElementCreateApplication(app.processIdentifier), kAXMenuBarAttribute)
	else { return [] }
	return children(bar)
}

func title(_ e: AXUIElement) -> String {
	var value: CFTypeRef?
	AXUIElementCopyAttributeValue(e, kAXTitleAttribute as CFString, &value)
	return value as? String ?? ""
}

func extra(_ id: String) -> AXUIElement? {
	// macOS 27 hosts system extras in MenuBarAgent; older releases in ControlCenter/SystemUIServer.
	let hosts = ["com.apple.MenuBarAgent", "com.apple.controlcenter", "com.apple.systemuiserver"]
	for app in NSWorkspace.shared.runningApplications where hosts.contains(app.bundleIdentifier ?? "") {
		if let bar = element(AXUIElementCreateApplication(app.processIdentifier), "AXExtrasMenuBar"),
			let hit = find(id, in: bar)
		{
			return hit
		}
	}
	return nil
}

func fail(_ message: String) -> Never {
	FileHandle.standardError.write(Data("menubar: \(message)\n".utf8))
	exit(1)
}

// Untrusted: macOS shows its "allow Accessibility" prompt for SketchyBar.
let promptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
guard AXIsProcessTrustedWithOptions([promptKey: true] as CFDictionary) else {
	fail("no Accessibility access: allow sketchybar in System Settings > Privacy & Security > Accessibility")
}
AXUIElementSetMessagingTimeout(AXUIElementCreateSystemWide(), 1.0)

let args = Array(CommandLine.arguments.dropFirst())
let target: AXUIElement?
switch (args.first, args.count) {
case ("list", 1):
	for item in appMenuItems().dropFirst() { print(title(item)) }
	exit(0)
case ("press", 2):
	let items = appMenuItems()
	guard let n = Int(args[1]), items.indices.contains(n) else { fail("no menu \(args[1])") }
	target = items[n]
case ("extra", 2): target = extra(args[1])
default: fail("usage: menubar list | menubar press <n> | menubar extra <identifier>")
}
guard let target else { fail("menu not found") }
let result = AXUIElementPerformAction(target, kAXPressAction as CFString)
guard result == .success else { fail("press failed (\(result.rawValue))") }
