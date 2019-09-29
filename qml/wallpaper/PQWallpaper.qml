import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2

import "../elements"
import "ele"

Rectangle {

    id: wallpaper_top

    color: "#dd000000"

    width: parentWidth
    height: parentHeight

    property int parentWidth: toplevel.width
    property int parentHeight: toplevel.height

    opacity: 0
    Behavior on opacity { NumberAnimation { duration: PQSettings.animationDuration*100 } }
    visible: opacity!=0

    property string curCat: "plasma"
    property int numDesktops: 3

    PQMouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }

    Item {

        id: insidecont
        x: (parent.width-width)/2
        y: (parent.height-height)/2
        width: Math.min(parent.width, Math.max(parent.width/2, 800))
        height: Math.min(parent.height, Math.max(parent.height/2, 600))

        Item {
            id: category
            x: 0
            y: 0
            width: 300
            height: parent.height

            Item {
                width: parent.width
                height: childrenRect.height
                anchors.centerIn: parent
                Column {
                    spacing: 20
                    Text {
                        width: category.width
                        horizontalAlignment: Text.AlignHCenter
                        color: curCat=="plasma" ? "#ffffff" : "#aaaaaa"
                        Behavior on color { ColorAnimation { duration: 150 } }
                        font.pointSize: 15
                        font.bold: true
                        text: "Plasma 5"
                        PQMouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            tooltip: "Click to choose Plasma 5"
                            onClicked:
                                curCat = "plasma"
                        }
                    }
                    Text {
                        width: category.width
                        horizontalAlignment: Text.AlignHCenter
                        color: curCat=="gnome" ? "#ffffff" : "#aaaaaa"
                        Behavior on color { ColorAnimation { duration: 150 } }
                        font.pointSize: 15
                        font.bold: true
                        text: "Gnome/Unity"
                        PQMouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            tooltip: "Click to choose Gnome/Unity"
                            onClicked:
                                curCat = "gnome"
                        }
                    }
                    Text {
                        width: category.width
                        horizontalAlignment: Text.AlignHCenter
                        color: curCat=="xfce" ? "#ffffff" : "#aaaaaa"
                        Behavior on color { ColorAnimation { duration: 150 } }
                        font.pointSize: 15
                        font.bold: true
                        text: "XFCE4"
                        PQMouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            tooltip: "Click to choose XFCE4"
                            onClicked:
                                curCat = "xfce"
                        }
                    }
                    Text {
                        width: category.width
                        horizontalAlignment: Text.AlignHCenter
                        color: curCat=="enlightenment" ? "#ffffff" : "#aaaaaa"
                        Behavior on color { ColorAnimation { duration: 150 } }
                        font.pointSize: 15
                        font.bold: true
                        text: "Enlightenment"
                        PQMouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            tooltip: "Click to choose Enlightenment"
                            onClicked:
                                curCat = "enlightenment"
                        }
                    }
                    Text {
                        width: category.width
                        horizontalAlignment: Text.AlignHCenter
                        color: curCat=="other" ? "#ffffff" : "#aaaaaa"
                        Behavior on color { ColorAnimation { duration: 150 } }
                        font.pointSize: 15
                        font.bold: true
                        text: "Other"
                        PQMouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            tooltip: "Click to choose Other"
                            onClicked:
                                curCat = "other"
                        }
                    }
                }
            }

            Rectangle {
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                }
                width: 1
                color: "#cccccc"
            }

        }

        Text {
            id: heading
            x: category.width
            y: 0
            width: parent.width-x
            height: 100
            text: "Set as Wallpaper"
            color: "white"
            font.pointSize: 20
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Row {
            id: buttons
            x: (parent.width-width)/2 + category.width/2
            y: parent.height-height
            width: childrenRect.width
            spacing: 10
            height: 50
            PQButton {
                y: (parent.height-height)/2
                id: button_ok
                text: "Set as Wallpaper"
                onClicked: {

                    var args = {}

                    if(curCat == "plasma") {

                        if(plasma.checkedScreens.length == 0)
                            return

                        args["screens"] = plasma.checkedScreens

                    } else if(curCat == "gnome") {

                        args["option"] = gnome.checkedOption

                    } else if(curCat == "xfce") {

                        if(xfce.checkedScreens.length == 0)
                            return

                        args["screens"] = xfce.checkedScreens
                        args["option"] = xfce.checkedOption

                    } else if(curCat == "enlightenment") {

                        if(enlightenment.checkedScreens.length == 0 || enlightenment.checkedWorkspaces.length == 0)
                            return

                        args["screens"] = enlightenment.checkedScreens
                        args["workspaces"] = enlightenment.checkedWorkspaces

                    } else if(curCat == "other") {

                        args["app"] = other.checkedTool
                        args["option"] = other.checkedOption

                    }

                    handlingWallpaper.setWallpaper(curCat, variables.allImageFilesInOrder[variables.indexOfCurrentImage], args)

                    wallpaper_top.opacity = 0
                    variables.visibleItem = ""
                }
            }
            PQButton {
                y: (parent.height-height)/2
                id: button_cancel
                text: "Cancel"
                onClicked: {
                    wallpaper_top.opacity = 0
                    variables.visibleItem = ""
                }
            }
        }

        Flickable {

            anchors {
                left: category.right
                top: heading.bottom
                bottom: buttons.top
                right: parent.right
                rightMargin: 10
                bottomMargin: 10
            }

            ScrollBar.vertical: PQScrollBar { }

            contentHeight: (curCat=="plasma" ? plasma.height
                                             : (curCat=="gnome" ? gnome.height
                                                                : (curCat=="xfce" ? xfce.height
                                                                                  : (curCat=="enlightenment" ? enlightenment.height
                                                                                                             : other.height))))

            clip: true

            PQPlasma {
                id: plasma
                visible: curCat=="plasma"
            }

            PQGnome {
                id: gnome
                visible: curCat=="gnome"
            }

            PQXfce {
                id: xfce
                visible: curCat=="xfce"
            }

            PQEnlightenment {
                id: enlightenment
                visible: curCat=="enlightenment"
            }

            PQOther {
                id: other
                visible: curCat=="other"
            }

        }

    }

    Connections {
        target: loader
        onWallpaperPassOn: {
            if(what == "show") {
                if(variables.indexOfCurrentImage == -1)
                    return
                opacity = 1
                variables.visibleItem = "wallpaper"
            } else if(what == "hide") {
                button_cancel.clicked()
            } else if(what == "keyevent") {
                if(param[0] == Qt.Key_Escape)
                    button_cancel.clicked()
                else if(param[0] == Qt.Key_Enter || param[0] == Qt.Key_Return)
                    button_ok.clicked()
                else if(param[0] == Qt.Key_Tab) {
                    var avail = ["plasma", "gnome", "xfce", "enlightenment", "other"]
                    var cur = avail.indexOf(curCat)+1
                    if(cur == avail.length)
                        cur = 0
                    curCat = avail[cur]
                } else if(param[0] == Qt.Key_Right || param[0] == Qt.Key_Left) {
                    if(curCat == "other")
                        other.changeTool()
                }
            }
        }
    }

    Component.onCompleted:
        curCat = handlingWallpaper.detectWM()


    Shortcut {
        sequence: "Esc"
        enabled: PQSettings.wallpaperPopoutElement
        onActivated: button_cancel.clicked()
    }

    Shortcut {
        sequence: "Tab"
        enabled: PQSettings.wallpaperPopoutElement
        onActivated: {
            var avail = ["plasma", "gnome", "xfce", "enlightenment", "other"]
            var cur = avail.indexOf(curCat)+1
            if(cur == avail.length)
                cur = 0
            curCat = avail[cur]
        }
    }

    Shortcut {
        sequences: ["Enter", "Return"]
        enabled: PQSettings.wallpaperPopoutElement
        onActivated: button_ok.clicked()
    }

    Shortcut {
        sequences: ["Left", "Right"]
        enabled: PQSettings.wallpaperPopoutElement
        onActivated: if(curCat == "other") other.changeTool()
    }

}
