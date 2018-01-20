import QtQuick 2.5
import QtQuick.Controls 1.4

import "../elements"

FadeInTemplate {

    id: scaleUnsupported_top

    heading: ""
    showSeperators: false

    marginTopBottom: (background.height-300)/2
    clipContent: false

    content: [

        Rectangle {
            color: "transparent"
            width: childrenRect.width
            height: childrenRect.height
            x: (scaleUnsupported_top.contentWidth-width)/2
            Text {
                color: colour.text
                font.pointSize: 20
//				font.bold: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                width: Math.min(background.width/2,500)
                lineHeight: 1.1
                text: em.pty+qsTr("Sorry, this fileformat cannot be scaled with PhotoQt yet!")
            }
        },

        Rectangle {
            color: "transparent"
            width: scaleUnsupported_top.contentWidth
            height: 1
        },

        CustomButton {
            text: em.pty+qsTr("Okay, I understand")
            fontsize: 15
            x: (scaleUnsupported_top.contentWidth-width)/2
            onClickedButton: hide()
        }

    ]

    Connections {
        target: call
        onScaleunsupportedShow: {
            if(variables.currentFile == "") return
            show()
        }
        onShortcut: {
            if(!scaleUnsupported_top.visible) return
            if(sh == "Escape")
                hide()
        }
        onCloseAnyElement:
            if(scaleUnsupported_top.visible)
                hide()
    }

}
