import QtQuick 2.9
import Qt.labs.folderlistmodel 2.3
import "../../elements"

GridView {

    id: files_grid

    clip: true

    cacheBuffer: 1

    property int dragItemIndex: -1

    model: FolderListModel {
        id: files_model
        showDirsFirst: true
        nameFilters: tweaks.showallfiles ? [] : imageformats.getAllEnabledFileformats()
        caseSensitive: false
    }

    cellWidth: settings.openDefaultView=="icons" ? settings.openZoomLevel*6 : width
    cellHeight: settings.openDefaultView=="icons" ? settings.openZoomLevel*6 : settings.openZoomLevel*2
    Behavior on cellWidth { NumberAnimation { id: cellWidthAni; duration: 125; } }
    Behavior on cellHeight { NumberAnimation { id: cellHeightAni; duration: 125; } }

    delegate: Item {

        width: files_grid.cellWidth
        height: files_grid.cellHeight

        Rectangle {

            id: deleg_container

            width: files_grid.cellWidth
            height: files_grid.cellHeight

            // these anchors make sure the item falls back into place after being dropped
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            property bool mouseInside: false
            color: fileIsDir
                       ? (mouseInside ? "#44444455" : "#44222233")
                       : (mouseInside ? "#44666666" : "#44444444")

            border.width: 1
            border.color: "#282828"

            Behavior on color { ColorAnimation { duration: 200 } }

            Image {

                id: fileicon

                x: 5
                y: 5
                width: settings.openDefaultView=="icons" ? parent.width-10 : parent.height-10
                height: parent.height-10

                asynchronous: true

                Behavior on width { NumberAnimation { duration: 100 } }
                Behavior on height { NumberAnimation { duration: 100 } }

                opacity: deleg_container.mouseInside ? 1 : 0.8
                Behavior on opacity { NumberAnimation { duration: 200 } }

                source: fileName==".."||filethumb.status==Image.Ready ? "" : "image://icon/" + (fileIsDir ? "folder" : "image")

                Text {
                    id: numberOfFilesInsideFolder
                    visible: settings.openDefaultView=="icons" && fileIsDir
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                    font.pointSize: 11
                    font.bold: true
                    elide: Text.ElideMiddle
                    text: ""
                }

                Image {

                    id: filethumb
                    anchors.fill: parent
                    visible: !fileIsDir

                    cache: false

                    sourceSize: Qt.size(256, 256)

                    fillMode: Image.PreserveAspectFit

                    // mipmap does not look good, use only smooth
                    smooth: true
                    asynchronous: true

                    source: (fileIsDir||!settings.openPreview) ? "" : ("image://thumb/" + filePath)

                }

            }

            Rectangle {

                width: parent.width
                height: fileName==".." ? parent.height : parent.height/2
                y: parent.height-height

                opacity: settings.openDefaultView=="icons" ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }

                color: "#66000000"

                Text {

                    width: parent.width-20
                    height: fileName==".." ? parent.height-20 : parent.height
                    x: 10
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                    text: decodeURIComponent(fileName)
                    maximumLineCount: 2
                    elide: Text.ElideMiddle
                    wrapMode: Text.Wrap

                    font.pointSize: fileName==".." ? 20 : 10


                }

            }

            Text {
                anchors.fill: parent
                anchors.leftMargin: fileName == ".." ? fileicon.width/2 : fileicon.width+10

                opacity: settings.openDefaultView=="list" ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }

                verticalAlignment: Text.AlignVCenter

                font.bold: true //fileName == ".."

                color: "white"
                text: decodeURIComponent(fileName)
                maximumLineCount: 2
                elide: Text.ElideMiddle
                wrapMode: Text.Wrap
            }

            Text {
                id: filesizenum
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    rightMargin: 5
                }
                verticalAlignment: Qt.AlignVCenter
                visible: settings.openDefaultView=="list"
                color: "white"
                font.bold: true
                text: ""

            }

            PQMouseArea {

                id: mouseArea

                anchors.fill: parent

                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                drag.target: fileIsDir ? parent : undefined

                tooltip: filePath

                // if drag is started
                drag.onActiveChanged: {
                    if (mouseArea.drag.active) {
                        // store which index is being dragged and that the entry comes from the userplaces (reordering only)
                        files_grid.dragItemIndex = index
                        splitview.dragSource = "folders"
                        splitview.dragItemPath = filePath
                    }
                    deleg_container.Drag.drop();
                    if(!mouseArea.drag.active) {
                        // reset variables used for drag/drop
                        files_grid.dragItemIndex = -1
                        splitview.dragItemPath = ""
                    }
                }

                onEntered:
                    deleg_container.mouseInside = true
                onExited:
                    deleg_container.mouseInside = false
                onClicked: {
                    if(fileIsDir)
                        filedialog_top.setCurrentDirectory(filePath)
                    else {
                        hideFileDialog()
                        imageitem.loadImage(filePath)
                    }
                }
            }

            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: fileicon.width/2
            Drag.hotSpot.y: fileicon.height/2

            states: [
                State {
                    // when drag starts, reparent entry to splitview
                    when: deleg_container.Drag.active
                    ParentChange {
                        target: deleg_container
                        parent: splitview
                    }
                    // (temporarily) remove anchors
                    AnchorChanges {
                        target: deleg_container
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: undefined
                    }
                }
            ]

            Component.onCompleted: {
                if(fileIsDir && fileName != "..") {
                    handlingFileDialog.getNumberOfFilesInFolder(filePath, function(count) {
                        if(count > 0) {
                            updateCount(count)
                            setFileSize(count + " images")
                        }
                    })
                } else if(!fileIsDir) {
                    handlingFileDialog.getFileSize(filePath, function(s) {
                        setFileSize(s)
                    })
                }
            }

            function updateCount(count) {
                if(count > 0)
                    numberOfFilesInsideFolder.text = count
            }
            function setFileSize(s) {
                filesizenum.text = s
            }

        }

    }

    Component.onCompleted:
        loadFolder(filedialog_top.currentDirectory)

    function loadFolder(loc) {

        loc = handlingFileDialog.cleanPath(loc)

        files_model.folder = "file://" + loc

        if(loc == "/")
            breadcrumbs.pathParts = [""]
        else
            breadcrumbs.pathParts = loc.split("/")

    }

    Connections {
        target: filedialog_top
        onCurrentDirectoryChanged:
            loadFolder(filedialog_top.currentDirectory)
    }

}