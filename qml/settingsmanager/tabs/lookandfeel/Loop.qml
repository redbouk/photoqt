import QtQuick 2.5

import "../../../elements"
import "../../"

EntryContainer {

    id: item_top

    Row {

        spacing: 20

        EntryTitle {

            //: Refers to looping through the folder, i.e., from the last image go back to the first one (and vice versa)
            title: em.pty+qsTr("Looping")
            helptext: em.pty+qsTr("PhotoQt can loop over the images in the folder, i.e., when reaching the last image it continues to the first one and vice versa. If disabled, it will stop at the first/last image.")

        }

        EntrySetting {

            CustomCheckBox {

                id: loopfolder
                text: em.pty+qsTr("Loop through images in folder")

            }

        }

    }

    function setData() {
        loopfolder.checkedButton = settings.loopThroughFolder
    }

    function saveData() {
        settings.loopThroughFolder = loopfolder.checkedButton
    }

}
