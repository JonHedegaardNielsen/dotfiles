//@ pragma UseQApplication
import "." as ShellTheme
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import QtQuick

Scope {
    id: root

    readonly property var theme: ShellTheme.Theme

    readonly property var batteryDevice: UPower.devices.values.find(device => device.isLaptopBattery) || null
    readonly property bool batteryAvailable: batteryDevice !== null
    readonly property bool batteryCharging: batteryAvailable
        && (batteryDevice.state === UPowerDeviceState.Charging
            || batteryDevice.state === UPowerDeviceState.PendingCharge)
    readonly property string batteryIcon: {
        if (!batteryAvailable)
            return "\uf240";

        const level = Math.round(batteryDevice.percentage);
        if (level <= 20)
            return "\uf244";
        if (level <= 50)
            return "\uf243";
        if (level <= 80)
            return "\uf242";
        return "\uf241";
    }
    readonly property bool internetConnected: Networking.devices.values.some(device => device.connected)
    readonly property bool wifiConnected: Networking.devices.values.some(device =>
        device.connected && device.type === DeviceType.Wifi
    )
    readonly property bool bluetoothAvailable: Bluetooth.defaultAdapter !== null
    readonly property bool bluetoothEnabled: bluetoothAvailable && Bluetooth.defaultAdapter.enabled
    property int volume: -1
    property bool audioMuted: false
    readonly property string volumeIcon: audioMuted || volume <= 0
        ? "\uf026"
        : volume < 50 ? "\uf027" : "\uf028"
    property date currentTime: new Date()
    property bool barVisible: true
    property bool launcherVisible: false
    property int launcherMode: 0
    property bool notificationsHistoryVisible: false
    property var launcherScreen: null
    readonly property var launcherTargetScreen: {
        if (launcherScreen)
            return launcherScreen;

        const monitor = Hyprland.focusedMonitor;
        return Quickshell.screens.find(screen => monitor && screen.name === monitor.name)
            || Quickshell.screens[0]
            || null;
    }

    function openLauncher() {
        launcherMode = 0;
        launcherVisible = true;
    }

    function openClipboardLauncher() {
        launcherMode = 1;
        launcherVisible = true;
    }

    function closeLauncher() {
        launcherVisible = false;
        launcherMode = 0;
        launcherScreen = null;
    }

    function toggleLauncher() {
        if (launcherVisible) {
            closeLauncher();
        } else {
            launcherScreen = null;
            openLauncher();
        }
    }

    IpcHandler {
        target: "launcher"
        enabled: true

        function toggle(): void {
            root.toggleLauncher();
        }

        function openClipboard(): void {
            root.launcherScreen = null;
            root.openClipboardLauncher();
        }

        function openKeybinds(): void {
            root.launcherScreen = null;
            root.launcherMode = 2;
            root.launcherVisible = true;
        }
    }

    IpcHandler {
        target: "notifications"

        function toggle(): void {
            root.notificationsHistoryVisible = !root.notificationsHistoryVisible;
        }
    }

    IpcHandler {
        target: "shell"

        function toggleBar(): void {
            root.barVisible = !root.barVisible;
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.currentTime = new Date()
    }

    Process {
        id: volumeProcess
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/Volume:\s*([0-9.]+)/);
                root.volume = match ? Math.round(parseFloat(match[1]) * 100) : -1;
                root.audioMuted = /Muted:\s*yes/.test(text);
            }
        }
    }

    Process {
        id: volumeControl
        command: ["pavucontrol"]
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: volumeProcess.running = true
    }

    ShellTheme.NotificationCenter {
        id: notificationCenter
        themeObject: theme
        historyOpen: root.notificationsHistoryVisible
        onHistoryClosed: root.notificationsHistoryVisible = false
    }

    PanelWindow {
        id: launcherOverlay
        visible: root.launcherVisible
        screen: root.launcherTargetScreen
        color: theme.overlayBackground
        exclusionMode: ExclusionMode.Ignore
        aboveWindows: true
        focusable: true

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        ShellTheme.AppLauncher {
            id: launcherApp
            anchors.fill: parent
            themeObject: theme
            requestedMode: root.launcherMode
            opened: root.launcherVisible
            active: true
            onDismissed: root.closeLauncher()
        }
    }

    HyprlandFocusGrab {
        windows: [launcherOverlay]
        active: root.launcherVisible
        onCleared: {
            if (root.launcherVisible)
                root.closeLauncher();
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData

            visible: root.barVisible
            screen: modelData
            implicitHeight: theme.barHeight
            exclusiveZone: theme.barHeight
            color: theme.background

            anchors {
                top: true
                left: true
                right: true
            }

            Rectangle {
                id: clockModule
                anchors.centerIn: parent
                width: clock.width + theme.modulePadding * 2
                height: theme.moduleHeight
                radius: theme.moduleRadius
                color: timeHover.hovered === true ? theme.moduleHoverBackground : theme.moduleBackground
                border.width: theme.moduleBorderWidth
                border.color: theme.moduleBorder

                Behavior on color {
                    ColorAnimation { duration: 120 }
                }

                Text {
                    id: clock
                    anchors.centerIn: parent
                    text: Qt.formatTime(root.currentTime, "HH:mm")
                    color: theme.foreground
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                    font.bold: true
                }

                HoverHandler {
                    id: timeHover
                }
            }

            PopupWindow {
                id: datePopup
                visible: timeHover.hovered === true
                grabFocus: false
                implicitWidth: theme.datePopupWidth
                implicitHeight: theme.popupHeight
                color: theme.popupBackground

                anchor.window: bar
                anchor.rect.x: clockModule.x + (clockModule.width / 2) - (implicitWidth / 2)
                anchor.rect.y: bar.height + theme.popupOffset

                Row {
                    anchors.centerIn: parent
                    spacing: theme.contentSpacing

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf133"
                        color: theme.accent
                        font.family: theme.fontFamily
                        font.pixelSize: theme.iconSize
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: Qt.formatDate(root.currentTime, "ddd, MMM d")
                        color: theme.foreground
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize
                    }
                }
            }

            Row {
                id: leftStatusRow
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: -(clockModule.width / 2 + width / 2)
                    verticalCenter: parent.verticalCenter
                }
                spacing: theme.moduleSpacing

                Rectangle {
                    id: batteryModule
                    visible: root.batteryAvailable
                    anchors.verticalCenter: parent.verticalCenter
                    width: batteryContent.width + theme.modulePadding * 2
                    height: theme.moduleHeight
                    radius: theme.moduleRadius
                    bottomLeftRadius: root.batteryAvailable
                        ? theme.moduleBottomRadius
                        : 0
                    color: theme.moduleBackground
                    border.width: theme.moduleBorderWidth
                    border.color: theme.moduleBorder

                    Row {
                        id: batteryContent
                        anchors.centerIn: parent
                        spacing: theme.contentTightSpacing

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.batteryIcon
                            color: !root.batteryAvailable
                                ? theme.offline
                                : root.batteryDevice.percentage <= 20
                                    ? theme.warning
                                    : root.batteryCharging ? theme.online : theme.muted
                            font.family: theme.fontFamily
                            font.pixelSize: theme.fontSize
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.batteryAvailable
                                ? Math.round(root.batteryDevice.percentage) + "%"
                                : ""
                            color: !root.batteryAvailable
                                ? theme.offline
                                : root.batteryDevice.percentage <= 20 ? theme.warning : theme.muted
                            font.family: theme.fontFamily
                            font.pixelSize: theme.fontSize
                            font.bold: true
                        }
                    }
                }

                Rectangle {
                    id: volumeButton
                    width: volumeGlyph.width + theme.modulePadding * 2
                    height: theme.moduleHeight
                    radius: theme.moduleRadius
                    bottomLeftRadius: root.batteryAvailable
                        ? 0
                        : theme.moduleBottomRadius
                    color: volumeHover.hovered === true ? theme.moduleHoverBackground : theme.moduleBackground
                    border.width: theme.moduleBorderWidth
                    border.color: theme.moduleBorder

                    Behavior on color {
                        ColorAnimation { duration: 120 }
                    }

                    Text {
                        id: volumeGlyph
                        anchors.centerIn: parent
                        text: root.volumeIcon
                        color: root.audioMuted || root.volume <= 0 ? theme.offline : theme.foreground
                        font.family: theme.fontFamily
                        font.pixelSize: theme.iconSize
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        cursorShape: Qt.PointingHandCursor
                        onClicked: volumeControl.running = true
                    }

                    HoverHandler {
                        id: volumeHover
                    }
                }
            }

            Row {
                id: rightStatusRow
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: clockModule.width / 2 + width / 2
                    verticalCenter: parent.verticalCenter
                }
                spacing: theme.moduleSpacing

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: internetGlyph.width + theme.modulePadding * 2
                    height: theme.moduleHeight
                    radius: theme.moduleRadius
                    color: theme.moduleBackground
                    border.width: theme.moduleBorderWidth
                    border.color: theme.moduleBorder

                    Text {
                        id: internetGlyph
                        anchors.centerIn: parent
                        text: root.internetConnected
                            ? root.wifiConnected ? "\uf1eb" : "\uef09"
                            : "\uf0ac"
                        color: root.internetConnected ? theme.online : theme.offline
                        font.family: theme.fontFamily
                        font.pixelSize: theme.iconSize
                    }
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: bluetoothGlyph.width + theme.modulePadding * 2
                    height: theme.moduleHeight
                    radius: theme.moduleRadius
                    bottomRightRadius: SystemTray.items.values.length > 0
                        ? 0
                        : theme.moduleBottomRadius
                    color: theme.moduleBackground
                    border.width: theme.moduleBorderWidth
                    border.color: theme.moduleBorder

                    Text {
                        id: bluetoothGlyph
                        anchors.centerIn: parent
                        text: "\uf293"
                        color: root.bluetoothEnabled ? theme.accent : theme.offline
                        font.family: theme.fontFamily
                        font.pixelSize: theme.iconSize
                    }
                }

                Rectangle {
                    id: trayModule
                    visible: SystemTray.items.values.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    width: trayContent.width + theme.modulePadding * 2
                    height: theme.moduleHeight
                    radius: theme.moduleRadius
                    bottomRightRadius: theme.moduleBottomRadius
                    color: theme.moduleBackground
                    border.width: theme.moduleBorderWidth
                    border.color: theme.moduleBorder

                    Row {
                        id: trayContent
                        anchors.centerIn: parent
                        spacing: theme.trayIconSpacing

                        Repeater {
                            model: SystemTray.items

                            delegate: Item {
                                id: trayIcon
                                required property var modelData
                                width: theme.trayItemSize
                                height: theme.trayItemSize

                                Image {
                                    anchors.centerIn: parent
                                    width: theme.trayIconSize
                                    height: theme.trayIconSize
                                    source: modelData.icon
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                    cursorShape: Qt.PointingHandCursor
                                    onPressed: mouse => {
                                        if (mouse.button === Qt.RightButton) {
                                            if (modelData.hasMenu) {
                                                const point = trayIcon.mapToItem(bar.contentItem, 0, trayIcon.height);
                                                modelData.display(bar, point.x, point.y);
                                            } else {
                                                modelData.secondaryActivate();
                                            }
                                        } else if (mouse.button === Qt.MiddleButton) {
                                            modelData.secondaryActivate();
                                        } else if (modelData.onlyMenu && modelData.hasMenu) {
                                            const point = trayIcon.mapToItem(bar.contentItem, 0, trayIcon.height);
                                            modelData.display(bar, point.x, point.y);
                                        } else {
                                            modelData.activate();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            PopupWindow {
                id: volumePopup
                visible: volumeHover.hovered === true
                grabFocus: false
                implicitWidth: theme.popupWidth
                implicitHeight: theme.popupHeight
                color: theme.popupBackground

                anchor.window: bar
                anchor.rect.x: leftStatusRow.x + volumeButton.x
                    + (volumeButton.width / 2) - (implicitWidth / 2)
                anchor.rect.y: bar.height + theme.popupOffset

                Row {
                    anchors.centerIn: parent
                    spacing: theme.contentSpacing

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.volumeIcon
                        color: root.audioMuted || root.volume <= 0 ? theme.offline : theme.foreground
                        font.family: theme.fontFamily
                        font.pixelSize: theme.iconSize
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.volume < 0
                            ? "--"
                            : root.audioMuted
                                ? "Muted · " + root.volume + "%"
                                : root.volume + "%"
                        color: theme.foreground
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize
                    }
                }
            }
        }
    }
}
