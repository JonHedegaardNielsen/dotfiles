pragma Singleton

import QtQuick

QtObject {
    readonly property string fontFamily: "JetBrains Mono"
    readonly property int fontSize: 16
    readonly property int iconSize: 26

    // Kanagawa Wave
    readonly property color background: "transparent"
    readonly property color overlayBackground: "transparent"
    readonly property color popupBackground: "#f21f1f28"
    readonly property color foreground: "#dcd7ba"
    readonly property color muted: "#a6a69c"
    readonly property color accent: "#957fb8"
    readonly property color online: "#98bb6c"
    readonly property color offline: "#727169"
    readonly property color warning: "#e82424"
    readonly property color divider: "#16dcd7ba"

    readonly property color moduleIdleBackground: "transparent"
    readonly property color moduleBackground: "#f21f1f28"
    readonly property color moduleHoverBackground: "#f2362637"
    readonly property color moduleBorder: "#28a6a69c"
    readonly property int moduleBorderWidth: 3

    readonly property int barHeight: 30
    readonly property int moduleHeight: barHeight
    readonly property int modulePadding: 20
    readonly property int moduleRadius: 0
    readonly property int moduleBottomRadius: 10
    readonly property int moduleSpacing: 0

    readonly property int contentSpacing: 8
    readonly property int contentTightSpacing: 4
    readonly property int popupWidth: 150
    readonly property int popupHeight: 44
    readonly property int popupOffset: 6
    readonly property int datePopupWidth: 180

    readonly property int launcherPanelTopOffset: 80
    readonly property int launcherMinWidth: 520
    readonly property int launcherMaxWidth: 760
    readonly property real launcherWidthFraction: 0.30
    readonly property int launcherHeight: 620
    readonly property int launcherHeightMargin: 100
    readonly property int launcherPanelRadius: 8
    readonly property int launcherBorderWidth: 2
    readonly property int launcherInputHeight: 64
    readonly property int launcherModeWidth: 62
    readonly property int launcherModeHeight: 32
    readonly property int launcherModeRadius: 6
    readonly property int launcherModeFontSize: 10
    readonly property real launcherModeLetterSpacing: 0.6
    readonly property int launcherSearchIconSize: 22
    readonly property int launcherInputFontSize: 16
    readonly property int launcherRowHeight: 56
    readonly property int launcherKeybindRowHeight: 62
    readonly property int launcherSelectionWidth: 3
    readonly property int launcherSelectionRadius: 1
    readonly property int launcherIconSize: 40
    readonly property int launcherIconRadius: 6
    readonly property int launcherIconFontSize: 20
    readonly property int launcherColumnSpacing: 2
    readonly property int launcherKeybindColumnSpacing: 3
    readonly property int launcherNameFontSize: 16
    readonly property int launcherDetailFontSize: 13
    readonly property int launcherClipboardPreviewFontSize: 13
    readonly property int launcherClipboardMetaFontSize: 10
    readonly property int launcherEmptyFontSize: 14

    readonly property int trayItemSize: 24
    readonly property int trayIconSize: 20
    readonly property int trayIconSpacing: 12

    readonly property int notificationWidth: 400
    readonly property int notificationHeight: 116
    readonly property int notificationHistoryWidth: 540
    readonly property int notificationHistoryHeight: 640
    readonly property int notificationRadius: 10
    readonly property int notificationIconSize: 34
    readonly property int notificationHistoryIconSize: 30
    readonly property int notificationSpacing: 8
    readonly property int notificationTitleFontSize: 14
    readonly property int notificationBodyFontSize: 12
    readonly property int notificationHistoryTitleFontSize: 16
    readonly property int notificationHistorySummaryFontSize: 13
    readonly property int notificationHistoryBodyFontSize: 11
    readonly property int notificationActionFontSize: 10
    readonly property int notificationMetaFontSize: 9
    readonly property int notificationClearFontSize: 11
    readonly property int notificationEmptyFontSize: 13
    readonly property int notificationDividerHeight: 1
    readonly property int notificationListSpacing: 6
    readonly property int notificationHistoryRowHeight: 92
    readonly property int notificationHistoryRowRadius: 8
    readonly property int notificationActionHeight: 24
    readonly property int notificationActionRadius: 6
}
