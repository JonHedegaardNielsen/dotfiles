import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: center

    property var themeObject
    property bool historyOpen: false
    property var notifications: []
    property var popups: []
    readonly property int unreadCount: notifications.length

    signal historyClosed()

    visible: historyOpen || popups.length > 0
    color: center.themeObject.overlayBackground
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    focusable: historyOpen
    WlrLayershell.keyboardFocus: historyOpen
        ? WlrKeyboardFocus.OnDemand
        : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    function receive(notification) {
        notification.tracked = true;
        notifications = [notification].concat(notifications).slice(0, 50);
        popups = [notification].concat(popups).slice(0, 3);
    }

    function removePopup(notification) {
        popups = popups.filter(item => item !== notification);
    }

    function removeNotification(notification) {
        notification.dismiss();
        popups = popups.filter(item => item !== notification);
        notifications = notifications.filter(item => item !== notification);
    }

    function clearNotifications() {
        notifications.forEach(notification => notification.dismiss());
        notifications = [];
        popups = [];
    }

    function closeHistory() {
        historyClosed();
    }

    function iconSource(notification) {
        if (notification.image)
            return notification.image;
        if (notification.appIcon)
            return Quickshell.iconPath(notification.appIcon, true);
        return "";
    }

    onHistoryOpenChanged: {
        if (historyOpen)
            focusTimer.restart();
    }

    HyprlandFocusGrab {
        windows: [center]
        active: center.historyOpen
        onCleared: {
            if (center.historyOpen)
                center.closeHistory();
        }
    }

    NotificationServer {
        keepOnReload: true
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: false
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true

        onNotification: notification => center.receive(notification)
    }

    Timer {
        id: focusTimer
        interval: 40
        repeat: false
        onTriggered: historyFocus.forceActiveFocus()
    }

    FocusScope {
        id: historyFocus
        anchors.fill: parent
        focus: center.historyOpen

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                center.closeHistory();
                event.accepted = true;
            }
        }
    }

    mask: Region {
        regions: [
            Region { item: popupStack },
            Region { item: historyPanel },
        ]
    }

    Column {
        id: popupStack
        x: parent.width - width - 16
        y: 50
        width: center.themeObject.notificationWidth
        spacing: center.themeObject.notificationSpacing

        Repeater {
            model: center.popups

            delegate: Rectangle {
                id: popupCard
                required property var modelData

                width: popupStack.width
                height: center.themeObject.notificationHeight
                radius: center.themeObject.notificationRadius
                color: center.themeObject.moduleBackground
                border.width: center.themeObject.moduleBorderWidth
                border.color: modelData.urgency === NotificationUrgency.Critical
                    ? center.themeObject.warning
                    : center.themeObject.moduleBorder

                Image {
                    id: popupIcon
                    anchors {
                        left: parent.left
                        leftMargin: 14
                        top: parent.top
                        topMargin: 14
                    }
                    width: center.themeObject.notificationIconSize
                    height: center.themeObject.notificationIconSize
                    source: center.iconSource(popupCard.modelData)
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Text {
                    id: popupSummary
                    anchors {
                        left: popupIcon.right
                        leftMargin: 12
                        right: parent.right
                        rightMargin: 12
                        top: parent.top
                        topMargin: 12
                    }
                    text: popupCard.modelData.summary || popupCard.modelData.appName
                    color: center.themeObject.foreground
                    font.family: center.themeObject.fontFamily
                    font.pixelSize: center.themeObject.notificationTitleFontSize
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: 60
                        right: parent.right
                        rightMargin: 12
                        top: parent.top
                        topMargin: 42
                    }
                    text: popupCard.modelData.body
                    textFormat: Text.PlainText
                    color: center.themeObject.muted
                    font.family: center.themeObject.fontFamily
                    font.pixelSize: center.themeObject.notificationBodyFontSize
                    wrapMode: Text.WordWrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                }

                Text {
                    anchors {
                        right: parent.right
                        rightMargin: 12
                        bottom: parent.bottom
                        bottomMargin: 10
                    }
                    text: "Dismiss"
                    color: center.themeObject.accent
                    font.family: center.themeObject.fontFamily
                    font.pixelSize: center.themeObject.notificationActionFontSize
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: center.removeNotification(popupCard.modelData)
                }

                Timer {
                    interval: Math.max(2500, Math.min(
                        8000,
                        (popupCard.modelData.expireTimeout || 5) * 1000
                    ))
                    repeat: false
                    running: true
                    onTriggered: center.removePopup(popupCard.modelData)
                }
            }
        }
    }

    Rectangle {
        id: historyPanel
        anchors.horizontalCenter: parent.horizontalCenter
        y: 56
        width: Math.min(
            center.themeObject.notificationHistoryWidth,
            parent.width - 80
        )
        height: Math.min(
            center.themeObject.notificationHistoryHeight,
            parent.height - 90
        )
        radius: center.themeObject.notificationRadius
        color: center.themeObject.moduleBackground
        border.width: center.themeObject.moduleBorderWidth
        border.color: center.themeObject.moduleBorder
        visible: center.historyOpen
        clip: true

        Text {
            id: historyTitle
            anchors {
                left: parent.left
                leftMargin: 18
                top: parent.top
                topMargin: 16
            }
            text: "Notifications"
            color: center.themeObject.foreground
            font.family: center.themeObject.fontFamily
            font.pixelSize: center.themeObject.notificationHistoryTitleFontSize
            font.bold: true
        }

        Text {
            anchors {
                right: parent.right
                rightMargin: 18
                verticalCenter: historyTitle.verticalCenter
            }
            text: "Clear"
            color: center.notifications.length > 0
                ? center.themeObject.accent
                : center.themeObject.offline
            font.family: center.themeObject.fontFamily
            font.pixelSize: center.themeObject.notificationClearFontSize

            MouseArea {
                anchors.fill: parent
                enabled: center.notifications.length > 0
                onClicked: center.clearNotifications()
            }
        }

        Rectangle {
            anchors {
                top: historyTitle.bottom
                topMargin: 12
                left: parent.left
                right: parent.right
            }
            height: center.themeObject.notificationDividerHeight
            color: center.themeObject.divider
        }

        ListView {
            id: historyList
            anchors {
                top: parent.top
                topMargin: 58
                left: parent.left
                leftMargin: 10
                right: parent.right
                rightMargin: 10
                bottom: parent.bottom
                bottomMargin: 10
            }
            model: center.notifications
            spacing: center.themeObject.notificationListSpacing
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
                id: historyRow
                required property var modelData

                width: historyList.width
                height: center.themeObject.notificationHistoryRowHeight
                radius: center.themeObject.notificationHistoryRowRadius
                color: center.themeObject.moduleHoverBackground
                border.width: center.themeObject.moduleBorderWidth
                border.color: center.themeObject.moduleBorder

                Image {
                    id: historyIcon
                    anchors {
                        left: parent.left
                        leftMargin: 12
                        top: parent.top
                        topMargin: 12
                    }
                    width: center.themeObject.notificationHistoryIconSize
                    height: center.themeObject.notificationHistoryIconSize
                    source: center.iconSource(historyRow.modelData)
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Text {
                    id: historySummary
                    anchors {
                        left: historyIcon.right
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 12
                        top: parent.top
                        topMargin: 11
                    }
                    text: historyRow.modelData.summary || historyRow.modelData.appName
                    color: center.themeObject.foreground
                    font.family: center.themeObject.fontFamily
                    font.pixelSize: center.themeObject.notificationHistorySummaryFontSize
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: 54
                        right: parent.right
                        rightMargin: 12
                        top: parent.top
                        topMargin: 40
                    }
                    text: historyRow.modelData.body
                    textFormat: Text.PlainText
                    color: center.themeObject.muted
                    font.family: center.themeObject.fontFamily
                    font.pixelSize: center.themeObject.notificationHistoryBodyFontSize
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }

                Text {
                    anchors {
                        right: parent.right
                        rightMargin: 12
                        bottom: parent.bottom
                        bottomMargin: 8
                    }
                    text: historyRow.modelData.appName
                    color: center.themeObject.offline
                    font.family: center.themeObject.fontFamily
                    font.pixelSize: center.themeObject.notificationMetaFontSize
                }

                Row {
                    id: historyActions
                    anchors {
                        left: parent.left
                        leftMargin: 54
                        bottom: parent.bottom
                        bottomMargin: 7
                    }
                    spacing: center.themeObject.notificationListSpacing

                    Repeater {
                        model: historyRow.modelData.actions

                        delegate: Rectangle {
                            required property var modelData
                            width: actionText.implicitWidth + 16
                            height: center.themeObject.notificationActionHeight
                            radius: center.themeObject.notificationActionRadius
                            color: center.themeObject.moduleBackground
                            border.width: center.themeObject.moduleBorderWidth
                            border.color: center.themeObject.moduleBorder

                            Text {
                                id: actionText
                                anchors.centerIn: parent
                                text: modelData.text
                                color: center.themeObject.accent
                                font.family: center.themeObject.fontFamily
                                font.pixelSize: center.themeObject.notificationActionFontSize
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: modelData.invoke()
                            }
                        }
                    }
                }

                MouseArea {
                    anchors {
                        left: parent.left
                        right: historyActions.right
                        top: parent.top
                        bottom: historyActions.top
                    }
                    onClicked: center.removeNotification(historyRow.modelData)
                }
            }
        }

        Text {
            anchors.centerIn: historyList
            visible: center.notifications.length === 0
            text: "No notifications"
            color: center.themeObject.muted
            font.family: center.themeObject.fontFamily
            font.pixelSize: center.themeObject.notificationEmptyFontSize
        }
    }
}
