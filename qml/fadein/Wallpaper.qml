import QtQuick 2.3
import QtQuick.Controls 1.2

import "../elements"

Rectangle {

	id: wallpaper

	anchors.fill: background
	color: colour_fadein_block_bg

	opacity: 0
	visible: false

	property int currentlySelectedWm: 0

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onClicked: hideWallpaperAni.start()
	}

	Rectangle {

		id: item

		// Set size
		anchors {
			fill: parent
			topMargin: Math.min((parent.width-400)/2,(parent.height-rect.height)/2)
			bottomMargin: Math.min((parent.width-400)/2,(parent.height-rect.height)/2)
			leftMargin: Math.min((parent.width-800)/2,300)
			rightMargin: Math.min((parent.width-800)/2,300)
		}

		// Some styling
		border.width: 1
		border.color: colour_fadein_border
		radius: 10
		color: colour_fadein_bg

		// Clicks INSIDE element doesn't close it
		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.LeftButton | Qt.RightButton
		}

		Rectangle {

			id: rect

			// Set inner area for display
			height: topcol.height+25
			width: parent.width-2*item.radius
			x: item.radius
			color: "#00000000"

			Column {

				id: topcol

				spacing: 10

				Rectangle { color: "#00000000"; width: 1; height: 1; }
				Rectangle { color: "#00000000"; width: 1; height: 1; }


				// HEADING
				Rectangle {
					color: "#00000000"
					width: childrenRect.width
					height: childrenRect.height
					x: (parent.width-width)/2
					Row {
						spacing: 5
						Text {
							color: "white"
							font.pointSize: 20
							font.bold: true
							text: "Set as Wallpaper:"
						}
						Text {
							y: parent.height-height
							color: "white"
							font.pointSize: 19
							text: "P1080310.JPG"
						}
					}
				}


				Rectangle { color: "#00000000"; width: 1; height: 1; }


				// WINDOW MANAGER SETTINGS
				Text {
					color: "white"
					font.bold: true
					font.pointSize: 16
					text: "Window Manager"
				}

				Text {
					color: "white"
					font.pointSize: 11
					width: rect.width
					wrapMode: Text.WordWrap
					text: "PhotoQt tries to detect your window manager according to the environment variables set by your system. If it still got it wrong, you can change the window manager manually."
				}

				CustomComboBox {
					id: wm_selection
					x: (rect.width-width)/2
					fontsize: 14
					width: 150
					model: ["KDE4","Plasma 5","Gnome/Unity","XFCE4","Other"]
				}

				Rectangle { color: "#00000000"; width: 1; height: 1; }

				Rectangle {
					color: "grey"
					width: rect.width
					height: 1
				}

				Rectangle { color: "#00000000"; width: 1; height: 1; }


				// A SCROLLABLE AREA CONTAINING THE SETTINGS
				Flickable {

					width: parent.width
					height: Math.min(300,wallpaper.height/3)
					contentHeight: settingsrect.height
					clip: true
					boundsBehavior: Flickable.StopAtBounds

					Rectangle {

						id: settingsrect

						color: "#00000000"
						width: parent.width
						height: childrenRect.height

						/**********************************************************************************/
						/**********************************************************************************/
						// KDE4
						/**********************************************************************************/
						Rectangle {

							visible: wm_selection.currentIndex == 0

							color: "#00000000"
							width: childrenRect.width
							height: (wm_selection.currentIndex == 0 ? childrenRect.height : 10)

							Text {

								width: rect.width*0.75
								x: (rect.width-width)/2
								color: "red"
								font.bold: true
								wrapMode: Text.WordWrap
								horizontalAlignment: Text.AlignHCenter
								text: "Sorry, KDE4 doesn't offer the feature to change the wallpaper except from their own system settings. Unfortunately there's nothing I can do about that."

							}

						}

						/**********************************************************************************/
						/**********************************************************************************/
						// PLASMA 5
						/**********************************************************************************/
						Rectangle {

							visible: wm_selection.currentIndex == 1

							color: "#00000000"
							width: childrenRect.width
							height: (wm_selection.currentIndex == 1 ? childrenRect.height : 10)

							Text {

								width: rect.width*0.75
								x: (rect.width-width)/2
								color: "red"
								font.bold: true
								wrapMode: Text.WordWrap
								horizontalAlignment: Text.AlignHCenter
								text: "Sorry, Plasma 5 doesn't yet offer the feature to change the wallpaper except from their own system settings. Hopefully this will change soon, but until then there's nothing I can do about that."

							}

						}

						/**********************************************************************************/
						/**********************************************************************************/
						// GNOME/UNITY
						/**********************************************************************************/
						Rectangle {

							visible: wm_selection.currentIndex == 2

							color: "#00000000"
							width: childrenRect.width
							height: (wm_selection.currentIndex == 2 ? childrenRect.height : 10)

							Column {

								spacing: 5

								// PICTURE OPTIONS HEADING
								Text {
									color: "white"
									font.pointSize: 11
									width: rect.width
									wrapMode: Text.WordWrap
									horizontalAlignment: Text.AlignHCenter
									text: "There are several picture options that can be set for the wallpaper image."
								}

								Rectangle { color: "#00000000"; width: 1; height: 1; }

								ExclusiveGroup { id: wallpaperoptions_kde; }
								Rectangle {

									color: "#00000000"
									width: childrenRect.width
									height: childrenRect.height
									x: (rect.width-width)/2

									Column {

										spacing: 10

										CustomRadioButton {
											text: "wallpaper"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_kde
											checked: true
										}
										CustomRadioButton {
											text: "centered"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_kde
										}
										CustomRadioButton {
											text: "scaled"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_kde
										}
										CustomRadioButton {
											text: "zoom"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_kde
										}
										CustomRadioButton {
											text: "spanned"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_kde
										}

									}

								}

							}

						}

						/**********************************************************************************/
						/**********************************************************************************/
						// XFCE4
						/**********************************************************************************/
						Rectangle {

							visible: wm_selection.currentIndex == 3

							color: "#00000000"
							width: childrenRect.width
							height: (wm_selection.currentIndex == 3 ? childrenRect.height : 10)

							Column {

								spacing: 5

								// MONITOR HEADING
								Text {
									color: "white"
									font.pointSize: 11
									width: rect.width
									wrapMode: Text.WordWrap
									horizontalAlignment: Text.AlignHCenter
									text: "The wallpaper can be set to either of the available monitors (or any combination)."
								}

								// MONITOR SELECTION
								Rectangle {
									color: "#00000000"
									width: childrenRect.width
									height: childrenRect.height
									x: (rect.width-width)/2
									ListView {
										id: view
										width: 10
										spacing: 5
										height: childrenRect.height
										delegate: CustomCheckBox {
											text: "Screen #" + index
											checkedButton: true
											Component.onCompleted: {
												if(view.width < width)
													view.width = width
											}
										}
										model: 2
									}
								}

								Rectangle { color: "#00000000"; width: 1; height: 1; }
								Rectangle { color: "#00000000"; width: 1; height: 1; }

								// PICTURE OPTIONS HEADING
								Text {
									color: "white"
									font.pointSize: 11
									width: rect.width
									wrapMode: Text.WordWrap
									horizontalAlignment: Text.AlignHCenter
									text: "There are several picture options that can be set for the wallpaper image."
								}

								Rectangle { color: "#00000000"; width: 1; height: 1; }

								// PICTURE OPTIONS RADIOBUTTONS
								ExclusiveGroup { id: wallpaperoptions_xfce; }
								Rectangle {
									color: "#00000000"
									width: childrenRect.width
									height: childrenRect.height
									x: (rect.width-width)/2
									Column {
										spacing: 10
										CustomRadioButton {
											text: "automatic"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_xfce
											checked: true
										}
										CustomRadioButton {
											text: "centered"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_xfce
										}
										CustomRadioButton {
											text: "tiled"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_xfce
										}
										CustomRadioButton {
											text: "spanned"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_xfce
										}
										CustomRadioButton {
											text: "scaled"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_xfce
										}
										CustomRadioButton {
											text: "magnified"
											fontsize: 11
											exclusiveGroup: wallpaperoptions_xfce
										}

									}

								}


							}

						}


						/**********************************************************************************/
						/**********************************************************************************/
						// OTHER
						/**********************************************************************************/
						Rectangle {

							visible: (wm_selection.currentIndex == 4)

							color: "#00000000"
							width: childrenRect.width
							height: (wm_selection.currentIndex == 4 ? childrenRect.height : 10)

							Column {

								spacing: 15

								// HEADING
								Text {
									color: "white"
									font.pointSize: 11
									width: rect.width
									wrapMode: Text.WordWrap
									horizontalAlignment: Text.AlignHCenter
									text: "PhotoQt can use 'feh' or 'nitrogen' to change the background of the desktop.<br>This is intended particularly for window managers that don't natively support wallpapers (e.g., like Openbox)."
								}

								// SWITCH BETWEEN feh AND nitrogen
								Rectangle {

									color: "#00000000"
									width: childrenRect.width
									height: childrenRect.height
									x: (parent.width-width)/2

									Row {
										spacing: 15
										CustomCheckBox {
											id: feh
											text: "Use 'feh'"
											checkedButton: true
											onButtonCheckedChanged: nitrogen.checkedButton = !feh.checkedButton
										}
										CustomCheckBox {
											id: nitrogen
											text: "Use 'nitrogen'"
											checkedButton: false
											onButtonCheckedChanged: feh.checkedButton = !nitrogen.checkedButton
										}
									}

								}

								Rectangle { color: "#00000000"; width: 1; height: 1; }

								// feh SETTINGS
								Rectangle {

									color: "#00000000"
									width: childrenRect.width
									height: childrenRect.height
									x: (parent.width-width)/2

									Column {
										id: fehcolumn
										visible: feh.checkedButton
										spacing: 10
										ExclusiveGroup { id: fehexclusive; }
										CustomRadioButton {
											exclusiveGroup: fehexclusive
											text: "--bg-center"
											checked: true
										}
										CustomRadioButton {
											exclusiveGroup: fehexclusive
											text: "--bg-fill"
										}
										CustomRadioButton {
											exclusiveGroup: fehexclusive
											text: "--bg-max"
										}
										CustomRadioButton {
											exclusiveGroup: fehexclusive
											text: "--bg-scale"
										}
										CustomRadioButton {
											exclusiveGroup: fehexclusive
											text: "--bg-tile"
										}
									}

									// nitrogen SETTINGS
									Column {
										id: nitrogencolumn
										visible: nitrogen.checkedButton
										spacing: 10
										ExclusiveGroup { id: nitrogenexclusive; }
										CustomRadioButton {
											exclusiveGroup: nitrogenexclusive
											text: "--set-auto"
											checked: true
										}
										CustomRadioButton {
											exclusiveGroup: nitrogenexclusive
											text: "--set-centered"
										}
										CustomRadioButton {
											exclusiveGroup: nitrogenexclusive
											text: "--set-scaled"
										}
										CustomRadioButton {
											exclusiveGroup: nitrogenexclusive
											text: "--set-tiled"
										}
										CustomRadioButton {
											exclusiveGroup: nitrogenexclusive
											text: "--set-zoom"
										}
										CustomRadioButton {
											exclusiveGroup: nitrogenexclusive
											text: "--set-zoom-fill"
										}
									}

								}

							}

						}



					}

				}	// END FLickable

				Rectangle {
					color: "grey"
					width: rect.width
					height: 1
				}

				Rectangle {
					color: "#00000000"
					width: childrenRect.width
					height: childrenRect.height
					x: (parent.width-width)/2

					Row {
						spacing: 10
						CustomButton {
							text: "Okay, do it!"
							onClickedButton: hideWallpaper()
						}
						CustomButton {
							text: "Nooo, don't!"
							onClickedButton: hideWallpaper()
						}
					}
				}

			}

		}	// END id: rect

	}

	function simularEnter() {
		hideWallpaper()
	}

	function showWallpaper() {
		showWallpaperAni.start()
	}
	function hideWallpaper() {
		hideWallpaperAni.start()
	}

	PropertyAnimation {
		id: hideWallpaperAni
		target:  wallpaper
		property: "opacity"
		to: 0
		onStopped: {
			visible = false
			blocked = false
			if(image.url === "")
				openFile()
		}
	}

	PropertyAnimation {
		id: showWallpaperAni
		target:  wallpaper
		property: "opacity"
		to: 1
		onStarted: {
			visible = true
			blocked = true
		}
	}

}
