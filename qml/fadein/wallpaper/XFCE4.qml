import QtQuick 2.3
import QtQuick.Controls 1.2

import "../../elements"

Rectangle {

	property bool currentlySelected: false

	property var selectedScreens_xfce4: []

	visible: currentlySelected

	color: "#00000000"
	width: childrenRect.width
	height: childrenRect.height

	Column {

		spacing: 5

		// NOTE (tool not existing)
		Text {
			id: xfce4_error
			visible: false
			color: colour.text_warning
			font.pointSize: 10
			width: wallpaper_top.width
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
			text: qsTr("Warning: 'xfconf-query' doesn't seem to be available! Are you sure XFCE4 is installed?");
		}

		Rectangle { id: xfce4_error_spacing; color: "#00000000"; width: 1; height: 1; }

		// MONITOR HEADING
		Text {
			id: xfce4_monitor_part_1
			color: colour.text
			font.pointSize: 10
			width: wallpaper_top.width
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
			text: qsTr("The wallpaper can be set to either of the available monitors (or any combination).")
		}

		// MONITOR SELECTION
		Rectangle {
			id: xfce4_monitor_part_2
			color: "#00000000"
			width: childrenRect.width
			height: childrenRect.height
			x: (wallpaper_top.width-width)/2
			ListView {
				id: xfce4_monitor
				spacing: 5
				width: childrenRect.width
				height: childrenRect.height-10
				contentHeight: childrenRect.height
				delegate: CustomCheckBox {
					text: qsTr("Screen") + " #" + index
					checkedButton: true
					fsize: 10
					Component.onCompleted: {
						selectedScreens_xfce4[selectedScreens_xfce4.length] = index
						if(xfce4_monitor.width < width)
							xfce4_monitor.width = width
					}
					onCheckedButtonChanged: {
						if(checkedButton)
							selectedScreens_xfce4[selectedScreens_xfce4.length] = index
						else {
							var newlist = []
							for(var i = 0; i < selectedScreens_xfce4.length; ++i)
								if(selectedScreens_xfce4[i] !== index)
									newlist[newlist.length] = selectedScreens_xfce4[i]
							selectedScreens_xfce4 = newlist
						}
						okay.enabled = enDisableEnter()
					}
				}
				model: ListModel { id: xfce4_monitor_model; }
			}
		}

		Rectangle { id: xfce4_monitor_part_3; color: "#00000000"; width: 1; height: 1; }
		Rectangle { id: xfce4_monitor_part_4; color: "#00000000"; width: 1; height: 1; }

		// PICTURE OPTIONS HEADING
		Text {
			color: colour.text
			font.pointSize: 10
			width: wallpaper_top.width
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
			text: qsTr("There are several picture options that can be set for the wallpaper image.")
		}

		Rectangle { color: "#00000000"; width: 1; height: 1; }

		// PICTURE OPTIONS RADIOBUTTONS
		ExclusiveGroup { id: wallpaperoptions_xfce; }
		Rectangle {
			color: "#00000000"
			width: childrenRect.width
			height: childrenRect.height
			x: (wallpaper_top.width-width)/2
			Column {
				spacing: 10
				CustomRadioButton {
					//: This string refers to the scaling property of an image when setting as wallpaper
					text: qsTr("Automatic")
					fontsize: 10
					exclusiveGroup: wallpaperoptions_xfce
				}
				CustomRadioButton {
					//: This string refers to the scaling property of an image when setting as wallpaper
					text: qsTr("Centered")
					fontsize: 10
					exclusiveGroup: wallpaperoptions_xfce
				}
				CustomRadioButton {
					//: This string refers to the scaling property of an image when setting as wallpaper
					text: qsTr("Tiled")
					fontsize: 10
					exclusiveGroup: wallpaperoptions_xfce
				}
				CustomRadioButton {
					//: This string refers to the scaling property of an image when setting as wallpaper
					text: qsTr("Stretched")
					fontsize: 10
					exclusiveGroup: wallpaperoptions_xfce
				}
				CustomRadioButton {
					//: This string refers to the scaling property of an image when setting as wallpaper
					text: qsTr("Scaled")
					fontsize: 10
					exclusiveGroup: wallpaperoptions_xfce
				}
				CustomRadioButton {
					//: This string refers to the scaling property of an image when setting as wallpaper
					text: qsTr("Zoomed")
					fontsize: 10
					exclusiveGroup: wallpaperoptions_xfce
					checked: true
				}

			}

		}


	}

	function loadXfce4() {

		var c = getanddostuff.getScreenCount()
		xfce4_monitor_model.clear()

		for(var i = 0; i < c; ++i)
			xfce4_monitor_model.append({ "index" : i })

		// Hide screen selection elements for single screen set-ups
		xfce4_monitor_part_1.visible = (c > 1)
		xfce4_monitor_part_2.visible = (c > 1)
		xfce4_monitor_part_3.visible = (c > 1)
		xfce4_monitor_part_4.visible = (c > 1)

		var ret = getanddostuff.checkWallpaperTool("xfce4")
		xfce4_error.visible = (ret === 1)
		xfce4_error_spacing.visible = (ret === 1)

	}

	function getSelectedScreens() {
		return selectedScreens_xfce4
	}

	function getCurrentText() {
		return wallpaperoptions_xfce.current.text
	}

}
