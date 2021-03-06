/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2018 Lukas Spies                                       **
 ** Contact: http://photoqt.org                                          **
 **                                                                      **
 ** This file is part of PhotoQt.                                        **
 **                                                                      **
 ** PhotoQt is free software: you can redistribute it and/or modify      **
 ** it under the terms of the GNU General Public License as published by **
 ** the Free Software Foundation, either version 2 of the License, or    **
 ** (at your option) any later version.                                  **
 **                                                                      **
 ** PhotoQt is distributed in the hope that it will be useful,           **
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of       **
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        **
 ** GNU General Public License for more details.                         **
 **                                                                      **
 ** You should have received a copy of the GNU General Public License    **
 ** along with PhotoQt. If not, see <http://www.gnu.org/licenses/>.      **
 **                                                                      **
 **************************************************************************/

import QtQuick 2.5
import QtQuick.Controls 1.4

import "../../elements"

Rectangle {

    property bool currentlySelected: false

    visible: currentlySelected

    color: "#00000000"
    width: childrenRect.width
    height: (currentlySelected ? childrenRect.height : 10)

    Column {

        spacing: 5

        // NOTE (tool not existing)
        Text {
            id: gnome_unity_error
            visible: false
            color: colour.text_warning
            font.pointSize: 10
            width: wallpaper_top.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            //: "gsettings", "Gnome" and "Unity" are fixed names, please don't translate
            text: em.pty+qsTr("Warning: 'gsettings' doesn't seem to be available! Are you sure Gnome/Unity is installed?");
        }

        // PICTURE OPTIONS HEADING
        Text {
            color: colour.text
            font.pointSize: 10
            width: wallpaper_top.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            //: 'picture options' refers to options like stretching the image to fill the background, or tile the image, center it, etc.
            text: em.pty+qsTr("There are several picture options that can be set for the wallpaper image.")
        }

        Rectangle { color: "#00000000"; width: 1; height: 1; }

        ExclusiveGroup { id: wallpaperoptions_gnomeunity; }
        Rectangle {

            color: "#00000000"
            width: childrenRect.width
            height: childrenRect.height
            x: (wallpaper_top.width-width)/2

            Column {

                spacing: 10

                CustomRadioButton {
                    text: "wallpaper"
                    fontsize: 10
                    exclusiveGroup: wallpaperoptions_gnomeunity
                    checked: true
                }
                CustomRadioButton {
                    text: "centered"
                    fontsize: 10
                    exclusiveGroup: wallpaperoptions_gnomeunity
                }
                CustomRadioButton {
                    text: "scaled"
                    fontsize: 10
                    exclusiveGroup: wallpaperoptions_gnomeunity
                }
                CustomRadioButton {
                    text: "zoom"
                    fontsize: 10
                    exclusiveGroup: wallpaperoptions_gnomeunity
                }
                CustomRadioButton {
                    text: "spanned"
                    fontsize: 10
                    exclusiveGroup: wallpaperoptions_gnomeunity
                }

            }

        }

    }

    function loadGnomeUnity() {

        verboseMessage("Wallpaper/GnomeUnity","loadGnomeUnity()")

        var ret = getanddostuff.checkWallpaperTool("gnome_unity")
        gnome_unity_error.visible = (ret === 1)
    }

    function getCurrentText() {
        return wallpaperoptions_gnomeunity.current.text
    }

}
