import QtQuick 2.5
import QtQuick.Controls 1.4
import PImgur 1.0

import "../../../elements"
import "../../"

EntryContainer {

    id: item_top

    Row {

        spacing: 20

        EntryTitle {

            title: "imgur.com"
            helptext: em.pty+qsTr("Here you can connect PhotoQt to your imgur.com account for uploading images directly to it. Alternatively, you can always upload images anonymously to imgur.com without any user account. In either case, PhotoQt will return the image URL to you.")

        }

        EntrySetting {

            id: entry

            // This variable is needed to avoid a binding loop of slider<->spinbox
            property int val: 20

            Column {

                spacing: 5

                Rectangle {
                    color: "transparent"
                    width: 1
                    height: 1
                }

                Row {

                    spacing: 10

                    SettingsText {
                        //: Account refers to an imgur.com user account
                        text: em.pty+qsTr("Authenticated with account") + ":"
                        font.pointSize: 13
                    }
                    SettingsText {
                        id: authenticatedwith
                        text: ""
                        font.bold: true
                        font.pointSize: 13
                    }
                    SettingsText {
                        //: As in "not authenticated with imgur.com user account"
                        text: "[" + em.pty+qsTr("not authenticated") + "]"
                        font.bold: true
                        visible: authenticatedwith.text==""
                        font.pointSize: 13
                    }
                    SettingsText {
                        id: authenticationDateTime
                        property string datetime: "1991-07-23, 13:31"
                        //: As in "authenticated with imgur.com user account on 1991-07-23, 13:31"
                        text: "(" + em.pty+qsTr("authenticated on") + ": " + datetime + ")"
                        visible: authenticatedwith.text!=""
                        font.pointSize: 11
                    }

                }

                Rectangle {
                    color: "transparent"
                    width: 1
                    height: 1
                }

                Row {

                    spacing: 10

                    CustomButton {
                        text: (authenticatedwith.text==""
                        //: Account refers to imgur.com user account
                                ? em.pty+qsTr("Connect to Account")
                                  //: Account refers to imgur.com user account
                                : em.pty+qsTr("Connect to New Account"))
                        onClickedButton:
                            authbox.show()
                    }
                    CustomButton {
                        //: Account refers to imgur.com user account
                        text: em.pty+qsTr("Forget Account")
                        enabled: authenticatedwith.text!=""
                        onClickedButton: {
                            shareonline_imgur.forgetAccount()
                            authenticatedwith.text = shareonline_imgur.getAccountUsername()
                            authenticationDateTime.datetime = shareonline_imgur.getAuthDateTime()
                        }
                    }

                }

                Rectangle {
                    color: "transparent"
                    width: 1
                    height: 1
                }


                Rectangle {

                    id: authbox

                    color: "transparent"

                    width: childrenRect.width
                    height: 0
                    clip: true
                    property int h: childrenRect.height
                    Behavior on height { NumberAnimation { duration: 200 } }
                    visible: (height!=0)

                    function show() {
                        authbox.enabled = getanddostuff.checkIfConnectedToInternet();
                        inetconnected.visible = !getanddostuff.checkIfConnectedToInternet();
                        authpin.clear();
                        height = h;
                        lineeditAuthorizeUrl.text = shareonline_imgur.authorizeUrlForPin()
                    }
                    function hide() { height = 0; }

                    Row {

                        spacing: 10

                        Text {
                            id: inetconnected
                            color: colour.text_warning
                            y: (parent.height-height)/2
                            text: em.pty+qsTr("Not connected to internet")
                        }
                        Text {
                            color: enabled ? colour.text : colour.text_disabled
                            y: (parent.height-height)/2
                            text: em.pty+qsTr("Go to this URL:")
                        }
                        CustomLineEdit {
                            id: lineeditAuthorizeUrl
                            width: 500
                            readOnly: true
                            text: ""
                            emptyMessage: em.pty+qsTr("loading...")
                        }
                        CustomButton {
                            text: em.pty+qsTr("open link")
                            onClickedButton: getanddostuff.openLink(shareonline_imgur.authorizeUrlForPin())
                        }
                        Text {
                            color: enabled ? colour.text : colour.text_disabled
                            y: (parent.height-height)/2
                            text: em.pty+qsTr("Paste PIN here") + ":"
                        }
                        CustomLineEdit {
                            id: authpin
                            width: 100
                        }
                        CustomButton {
                            text: em.pty+qsTr("Connect")
                            onClickedButton: authenticate()
                        }
                        Rectangle {
                            color: "transparent"
                            width: 1
                        }
                        CustomButton {
                            text: em.pty+qsTr("Cancel")
                            onClickedButton:
                                authbox.hide()
                        }

                    }

                }

            }

        }

    }

    function authenticate() {
        authbox.enabled = false
        var ret = shareonline_imgur.authorizeHandlePin(authpin.getText())
        if(ret == PImgur.IMGUR_NOERROR) {
            authbox.hide()
            setData()
        } else {
            authbox.enabled = true
            verboseMessage("SettingsManager/Imgur/authenticate", "authenticate() error return value:",ret)
        }
    }

    function setData() {

        shareonline_imgur.authAccount()

        if(shareonline_imgur.authAccount() == PImgur.IMGUR_NOERROR) {
            authenticatedwith.text = shareonline_imgur.getAccountUsername()
            authenticationDateTime.datetime = shareonline_imgur.getAuthDateTime()
        } else
            authenticatedwith.text = ""

    }

    function saveData() {
    }

}
