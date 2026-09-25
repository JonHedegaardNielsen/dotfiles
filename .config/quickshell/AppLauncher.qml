import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: launcher

    property var themeObject
    property bool opened: false
    property bool active: true
    property bool inputArmed: false
    property int requestedMode: 0
    property string query: ""
    property int selectedIndex: 0
    property int mode: 0
    property int clipboardSelectedIndex: 0
    property int keybindSelectedIndex: 0
    property var clipboardItems: []
    property var keybindEntries: []

    readonly property var filteredApplications: {
        const needle = query.trim().toLowerCase();
        const matches = DesktopEntries.applications.values.filter(application => {
            if (needle === "")
                return true;

            const searchable = [
                application.name,
                application.genericName,
                application.comment,
                application.categories,
                application.keywords,
            ].join(" ").toLowerCase();
            return searchable.includes(needle);
        });

        matches.sort((a, b) => a.name.localeCompare(b.name));
        return matches.slice(0, 200);
    }
    readonly property var filteredClipboard: {
        const needle = query.trim().toLowerCase();
        return clipboardItems
            .filter(item => needle === "" || item.preview.toLowerCase().includes(needle))
            .slice(0, 200);
    }
    readonly property var filteredKeybinds: {
        const needle = query.trim().toLowerCase();
        return keybindEntries
            .filter(item => needle === ""
                || item.shortcut.toLowerCase().includes(needle)
                || item.description.toLowerCase().includes(needle))
            .slice(0, 200);
    }

    onOpenedChanged: {
        if (!opened)
            return;

        query = "";
        inputArmed = false;
        mode = requestedMode;
        selectedIndex = 0;
        clipboardSelectedIndex = 0;
        keybindSelectedIndex = 0;
        clipboardListProcess.running = true;
        keybindProcess.running = true;
        focusTimer.restart();
    }

    onRequestedModeChanged: {
        if (!opened)
            return;

        mode = requestedMode;
        selectedIndex = 0;
        clipboardSelectedIndex = 0;
        keybindSelectedIndex = 0;
    }

    signal dismissed()

    function dismiss() {
        dismissed();
    }

    function setMode(nextMode) {
        mode = nextMode;
        selectedIndex = 0;
        clipboardSelectedIndex = 0;
        keybindSelectedIndex = 0;

        if (mode === 1)
            clipboardListProcess.running = true;
        else if (mode === 2)
            keybindProcess.running = true;
    }

    function cycleMode() {
        setMode((mode + 1) % 3);
    }

    function moveSelection(delta) {
        if (mode === 0) {
            if (filteredApplications.length === 0)
                return;

            selectedIndex = Math.max(0, Math.min(
                filteredApplications.length - 1,
                selectedIndex + delta
            ));
            applicationList.positionViewAtIndex(selectedIndex, ListView.Contain);
        } else if (mode === 1) {
            if (filteredClipboard.length === 0)
                return;

            clipboardSelectedIndex = Math.max(0, Math.min(
                filteredClipboard.length - 1,
                clipboardSelectedIndex + delta
            ));
            clipboardList.positionViewAtIndex(clipboardSelectedIndex, ListView.Contain);
        } else {
            if (filteredKeybinds.length === 0)
                return;

            keybindSelectedIndex = Math.max(0, Math.min(
                filteredKeybinds.length - 1,
                keybindSelectedIndex + delta
            ));
            keybindList.positionViewAtIndex(keybindSelectedIndex, ListView.Contain);
        }
    }

    function launch(application) {
        if (!application)
            return;

        dismiss();
        application.execute();
    }

    function copyClipboard(entry) {
        if (!entry)
            return;

        dismiss();
        clipboardCopyProcess.command = [
            "sh",
            "-c",
            "cliphist decode " + entry.index + " | wl-copy",
        ];
        clipboardCopyProcess.running = true;
    }

    function copyKeybind(entry) {
        if (!entry)
            return;

        dismiss();
        clipboardCopyProcess.command = [
            "sh",
            "-c",
            "printf '%s' " + JSON.stringify(entry.shortcut) + " | wl-copy",
        ];
        clipboardCopyProcess.running = true;
    }

    function launchSelected() {
        if (mode === 0)
            launch(filteredApplications[selectedIndex]);
        else if (mode === 1)
            copyClipboard(filteredClipboard[clipboardSelectedIndex]);
        else
            copyKeybind(filteredKeybinds[keybindSelectedIndex]);
    }

    function updateClipboard(output) {
        const entries = [];

        output.split(/\r?\n/).forEach(line => {
            const separator = line.indexOf("\t");
            if (separator <= 0)
                return;

            const index = Number.parseInt(line.slice(0, separator), 10);
            if (Number.isNaN(index))
                return;

            entries.push({
                index: index,
                preview: line.slice(separator + 1),
            });
        });

        clipboardItems = entries.slice(0, 200);
    }

    function modifiersFor(mask) {
        const modifiers = [];
        if (mask & 64)
            modifiers.push("SUPER");
        if (mask & 4)
            modifiers.push("CTRL");
        if (mask & 8)
            modifiers.push("ALT");
        if (mask & 1)
            modifiers.push("SHIFT");
        if (mask & 16)
            modifiers.push("SUPER2");
        if (mask & 32)
            modifiers.push("HYPER");
        if (mask & 2)
            modifiers.push("LOCK");
        return modifiers;
    }

    function updateKeybinds(output) {
        try {
            const binds = JSON.parse(output);
            keybindEntries = binds
                .filter(bind => !bind.mouse && bind.key)
                .map(bind => {
                    const modifiers = modifiersFor(bind.modmask || 0);
                    const shortcut = modifiers.concat(bind.key).join(" + ");
                    const description = bind.description
                        || (bind.dispatcher === "__lua"
                            ? "Hyprland Lua bind"
                            : bind.dispatcher);

                    return {
                        shortcut: shortcut,
                        description: description,
                        submap: bind.submap || "",
                    };
                })
                .sort((a, b) => a.shortcut.localeCompare(b.shortcut));
        } catch (error) {
            keybindEntries = [];
        }
    }

    Timer {
        id: focusTimer
        interval: 120
        repeat: false
        onTriggered: {
            searchInput.forceActiveFocus();
            inputArmed = true;
        }
    }

    Timer {
        interval: 1500
        repeat: true
        triggeredOnStart: true
        running: launcher.opened && launcher.active
        onTriggered: {
            clipboardListProcess.running = true;
            if (launcher.mode === 2)
                keybindProcess.running = true;
        }
    }

    Process {
        id: clipboardListProcess
        command: ["cliphist", "list"]

        stdout: StdioCollector {
            onStreamFinished: launcher.updateClipboard(text)
        }
    }

    Process {
        id: keybindProcess
        command: ["hyprctl", "binds", "-j"]

        stdout: StdioCollector {
            onStreamFinished: launcher.updateKeybinds(text)
        }
    }

    Process {
        id: clipboardCopyProcess
        command: ["true"]
    }

        Rectangle {
            id: panel
            anchors.horizontalCenter: parent.horizontalCenter
            y: launcher.themeObject.launcherPanelTopOffset
            width: Math.max(
                launcher.themeObject.launcherMinWidth,
                Math.min(
                    launcher.themeObject.launcherMaxWidth,
                    parent.width * launcher.themeObject.launcherWidthFraction
                )
            )
            height: Math.min(
                launcher.themeObject.launcherHeight,
                parent.height - launcher.themeObject.launcherHeightMargin
            )
            radius: launcher.themeObject.launcherPanelRadius
            color: launcher.themeObject.moduleBackground
            border.width: launcher.themeObject.launcherBorderWidth
            border.color: launcher.themeObject.moduleBorder
            clip: true

            Rectangle {
                id: inputBar
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: launcher.themeObject.launcherInputHeight
                color: launcher.themeObject.moduleHoverBackground

                Rectangle {
                    id: modeButton
                    anchors {
                        left: parent.left
                        leftMargin: 14
                        verticalCenter: parent.verticalCenter
                    }
                    width: launcher.themeObject.launcherModeWidth
                    height: launcher.themeObject.launcherModeHeight
                    radius: launcher.themeObject.launcherModeRadius
                    color: launcher.mode !== 0
                        ? launcher.themeObject.accent
                        : launcher.themeObject.moduleBackground
                    border.width: launcher.themeObject.moduleBorderWidth
                    border.color: launcher.themeObject.moduleBorder

                    Text {
                        anchors.centerIn: parent
                        text: launcher.mode === 0
                            ? "APPS"
                            : launcher.mode === 1 ? "CLIP" : "KEYS"
                        color: launcher.mode !== 0
                            ? launcher.themeObject.moduleBackground
                            : launcher.themeObject.foreground
                        font.family: launcher.themeObject.fontFamily
                        font.pixelSize: launcher.themeObject.launcherModeFontSize
                        font.bold: true
                        font.letterSpacing: launcher.themeObject.launcherModeLetterSpacing
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: launcher.cycleMode()
                    }
                }

                Text {
                    id: searchGlyph
                    anchors {
                        left: modeButton.right
                        leftMargin: 12
                        verticalCenter: parent.verticalCenter
                    }
                    text: ""
                    color: launcher.themeObject.accent
                    font.family: launcher.themeObject.fontFamily
                    font.pixelSize: launcher.themeObject.launcherSearchIconSize
                }

                Text {
                    anchors {
                        left: searchGlyph.right
                        leftMargin: 14
                        right: parent.right
                        rightMargin: 18
                        verticalCenter: parent.verticalCenter
                    }
                    text: launcher.mode === 0
                        ? "Search applications..."
                        : launcher.mode === 1
                            ? "Search clipboard..."
                            : "Search keybinds..."
                    color: launcher.themeObject.muted
                    font.family: launcher.themeObject.fontFamily
                    font.pixelSize: launcher.themeObject.launcherInputFontSize
                    visible: launcher.query === ""
                }

                TextInput {
                    id: searchInput
                    anchors {
                        left: searchGlyph.right
                        leftMargin: 14
                        right: parent.right
                        rightMargin: 18
                        verticalCenter: parent.verticalCenter
                    }
                    text: launcher.query
                    color: launcher.themeObject.foreground
                    selectionColor: launcher.themeObject.accent
                    selectedTextColor: launcher.themeObject.foreground
                    font.family: launcher.themeObject.fontFamily
                    font.pixelSize: launcher.themeObject.launcherInputFontSize
                    selectByMouse: true
                    focus: true
                    activeFocusOnTab: true
                    clip: true

                    onTextEdited: {
                        launcher.query = text;
                        launcher.selectedIndex = 0;
                        launcher.clipboardSelectedIndex = 0;
                        launcher.keybindSelectedIndex = 0;
                        applicationList.positionViewAtBeginning();
                        clipboardList.positionViewAtBeginning();
                        keybindList.positionViewAtBeginning();
                    }

                    Keys.onPressed: event => {
                        const ctrlPressed = (event.modifiers & Qt.ControlModifier) !== 0;

                        if (event.key === Qt.Key_Escape) {
                            launcher.dismiss();
                            event.accepted = true;
                        } else if (ctrlPressed && event.key === Qt.Key_L) {
                            launcher.cycleMode();
                            event.accepted = true;
                        } else if (ctrlPressed && event.key === Qt.Key_N) {
                            launcher.moveSelection(1);
                            event.accepted = true;
                        } else if (ctrlPressed && event.key === Qt.Key_P) {
                            launcher.moveSelection(-1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down) {
                            launcher.moveSelection(1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up) {
                            launcher.moveSelection(-1);
                            event.accepted = true;
                        } else if (launcher.inputArmed
                            && (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)) {
                            launcher.launchSelected();
                            event.accepted = true;
                        }
                    }
                }
            }

            ListView {
                id: applicationList
                visible: launcher.mode === 0
                anchors {
                    top: inputBar.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                model: launcher.filteredApplications
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                currentIndex: launcher.selectedIndex

                delegate: Rectangle {
                    id: applicationDelegate
                    required property var modelData
                    required property int index

                    width: applicationList.width
                    height: launcher.themeObject.launcherRowHeight
                    color: index === launcher.selectedIndex
                        ? launcher.themeObject.moduleHoverBackground
                        : launcher.themeObject.moduleIdleBackground

                    Rectangle {
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        width: launcher.themeObject.launcherSelectionWidth
                        height: parent.height - 16
                        radius: launcher.themeObject.launcherSelectionRadius
                        color: launcher.themeObject.accent
                        visible: applicationDelegate.index === launcher.selectedIndex
                    }

                    Image {
                        id: applicationIcon
                        anchors {
                            left: parent.left
                            leftMargin: 18
                            verticalCenter: parent.verticalCenter
                        }
                        width: launcher.themeObject.launcherIconSize
                        height: launcher.themeObject.launcherIconSize
                        source: Quickshell.iconPath(applicationDelegate.modelData.icon, true)
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    Column {
                        anchors {
                            left: applicationIcon.right
                            leftMargin: 14
                            right: parent.right
                            rightMargin: 16
                            verticalCenter: parent.verticalCenter
                        }
                        spacing: launcher.themeObject.launcherColumnSpacing

                        Text {
                            width: parent.width
                            text: applicationDelegate.modelData.name
                            textFormat: Text.PlainText
                            color: launcher.themeObject.foreground
                            font.family: launcher.themeObject.fontFamily
                            font.pixelSize: launcher.themeObject.launcherNameFontSize
                            font.bold: applicationDelegate.index === launcher.selectedIndex
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width
                            text: applicationDelegate.modelData.genericName
                                || applicationDelegate.modelData.comment
                            textFormat: Text.PlainText
                            color: launcher.themeObject.muted
                            font.family: launcher.themeObject.fontFamily
                            font.pixelSize: launcher.themeObject.launcherDetailFontSize
                            visible: text !== ""
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: launcher.selectedIndex = applicationDelegate.index
                        onClicked: launcher.launch(applicationDelegate.modelData)
                    }
                }
            }

            ListView {
                id: clipboardList
                visible: launcher.mode === 1
                anchors {
                    top: inputBar.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                model: launcher.filteredClipboard
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                currentIndex: launcher.clipboardSelectedIndex

                delegate: Rectangle {
                    id: clipboardDelegate
                    required property var modelData
                    required property int index

                    width: clipboardList.width
                    height: launcher.themeObject.launcherRowHeight
                    color: index === launcher.clipboardSelectedIndex
                        ? launcher.themeObject.moduleHoverBackground
                        : launcher.themeObject.moduleIdleBackground

                    Rectangle {
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        width: launcher.themeObject.launcherSelectionWidth
                        height: parent.height - 16
                        radius: launcher.themeObject.launcherSelectionRadius
                        color: launcher.themeObject.accent
                        visible: clipboardDelegate.index === launcher.clipboardSelectedIndex
                    }

                    Rectangle {
                        id: clipboardIcon
                        anchors {
                            left: parent.left
                            leftMargin: 18
                            verticalCenter: parent.verticalCenter
                        }
                        width: launcher.themeObject.launcherIconSize
                        height: launcher.themeObject.launcherIconSize
                        radius: launcher.themeObject.launcherIconRadius
                        color: launcher.themeObject.moduleBackground
                        border.width: launcher.themeObject.moduleBorderWidth
                        border.color: launcher.themeObject.moduleBorder

                        Text {
                            anchors.centerIn: parent
                            text: ""
                            color: launcher.themeObject.accent
                            font.family: launcher.themeObject.fontFamily
                            font.pixelSize: launcher.themeObject.launcherIconFontSize
                        }
                    }

                    Column {
                        anchors {
                            left: clipboardIcon.right
                            leftMargin: 14
                            right: parent.right
                            rightMargin: 16
                            verticalCenter: parent.verticalCenter
                        }
                        spacing: launcher.themeObject.launcherColumnSpacing

                        Text {
                            width: parent.width
                            text: clipboardDelegate.modelData.preview || "(empty clipboard entry)"
                            textFormat: Text.PlainText
                            color: launcher.themeObject.foreground
                            font.family: launcher.themeObject.fontFamily
                            font.pixelSize: launcher.themeObject.launcherClipboardPreviewFontSize
                            font.bold: clipboardDelegate.index === launcher.clipboardSelectedIndex
                            elide: Text.ElideRight
                        }

                        Text {
                            text: "Clipboard entry #" + clipboardDelegate.modelData.index
                            color: launcher.themeObject.muted
                            font.family: launcher.themeObject.fontFamily
                            font.pixelSize: launcher.themeObject.launcherClipboardMetaFontSize
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: launcher.clipboardSelectedIndex = clipboardDelegate.index
                        onClicked: launcher.copyClipboard(clipboardDelegate.modelData)
                    }
                }
            }

            ListView {
                id: keybindList
                visible: launcher.mode === 2
                anchors {
                    top: inputBar.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                model: launcher.filteredKeybinds
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                currentIndex: launcher.keybindSelectedIndex

                delegate: Rectangle {
                    id: keybindDelegate
                    required property var modelData
                    required property int index

                    width: keybindList.width
                    height: launcher.themeObject.launcherKeybindRowHeight
                    color: index === launcher.keybindSelectedIndex
                        ? launcher.themeObject.moduleHoverBackground
                        : launcher.themeObject.moduleIdleBackground

                    Rectangle {
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        width: launcher.themeObject.launcherSelectionWidth
                        height: parent.height - 16
                        radius: launcher.themeObject.launcherSelectionRadius
                        color: launcher.themeObject.accent
                        visible: keybindDelegate.index === launcher.keybindSelectedIndex
                    }

                    Rectangle {
                        id: keybindIcon
                        anchors {
                            left: parent.left
                            leftMargin: 18
                            verticalCenter: parent.verticalCenter
                        }
                        width: launcher.themeObject.launcherIconSize
                        height: launcher.themeObject.launcherIconSize
                        radius: launcher.themeObject.launcherIconRadius
                        color: launcher.themeObject.moduleBackground
                        border.width: launcher.themeObject.moduleBorderWidth
                        border.color: launcher.themeObject.moduleBorder

                        Text {
                            anchors.centerIn: parent
                            text: ""
                            color: launcher.themeObject.accent
                            font.family: launcher.themeObject.fontFamily
                            font.pixelSize: launcher.themeObject.launcherIconFontSize
                        }
                    }

                    Column {
                        anchors {
                            left: keybindIcon.right
                            leftMargin: 14
                            right: parent.right
                            rightMargin: 16
                            verticalCenter: parent.verticalCenter
                        }
                        spacing: launcher.themeObject.launcherKeybindColumnSpacing

                        Text {
                            width: parent.width
                            text: keybindDelegate.modelData.shortcut
                            color: launcher.themeObject.accent
                            font.family: launcher.themeObject.fontFamily
                            font.pixelSize: launcher.themeObject.launcherNameFontSize
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width
                            text: keybindDelegate.modelData.description
                            color: launcher.themeObject.muted
                            font.family: launcher.themeObject.fontFamily
                            font.pixelSize: launcher.themeObject.launcherDetailFontSize
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: launcher.keybindSelectedIndex = keybindDelegate.index
                        onClicked: launcher.copyKeybind(keybindDelegate.modelData)
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                visible: (launcher.mode === 0 && launcher.filteredApplications.length === 0)
                    || (launcher.mode === 1 && launcher.filteredClipboard.length === 0)
                    || (launcher.mode === 2 && launcher.filteredKeybinds.length === 0)
                text: launcher.mode === 0
                    ? "No applications found"
                    : launcher.mode === 1
                        ? "No clipboard entries found"
                        : "No keybinds found"
                color: launcher.themeObject.muted
                font.family: launcher.themeObject.fontFamily
                font.pixelSize: launcher.themeObject.launcherEmptyFontSize
            }
        }
    }
