import QtQuick 2.5

import "../../../elements"
import "../../"

EntryContainer {

    id: item_top

    Row {

        spacing: 20

        EntryTitle {

            id: entrytitle

            title: em.pty+qsTr("Animation and Window Geometry")
            helptext: em.pty+qsTr("There are three things that can be adjusted here:") + "<ol><li>" + em.pty+qsTr("Animation of fade-in elements (e.g., Settings or About)") + "</li><li>" + em.pty+qsTr("Save and restore of Window Geometry: On quitting PhotoQt, it stores the size and position of the window and can restore it the next time started.") + "</li><li>" + em.pty+qsTr("Keep PhotoQt above all other windows at all time") + "</li></ol>"

        }

        EntrySetting {

            Row {

                spacing: 10

                CustomCheckBox {

                    id: animate_elements
                    text: em.pty+qsTr("Animate elements")

                }

                CustomCheckBox {

                    id: save_restore_geometry
                    text: em.pty+qsTr("Save and restore window geometry")
                    onCheckedButtonChanged:
                        if(checkedButton) screenCheck.checkedButton = false

                }

                CustomCheckBox {

                    id: keep_on_top
                    wrapMode: Text.WordWrap
                    text: em.pty+qsTr("Keep above other windows")

                }

            }

        }

    }

    function setData() {

        animate_elements.checkedButton = settings.elementsFadeIn
        save_restore_geometry.checkedButton = settings.saveWindowGeometry
        keep_on_top.checkedButton = settings.keepOnTop

    }

    function saveData() {
        settings.elementsFadeIn = animate_elements.checkedButton
        settings.saveWindowGeometry = save_restore_geometry.checkedButton
        settings.keepOnTop = keep_on_top.checkedButton

    }

}
