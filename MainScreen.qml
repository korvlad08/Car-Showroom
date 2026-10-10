import QtQuick
import QtQuick.Controls

Item {
    width: 1280
    height: 720
    clip: false
    transformOrigin: Item.Center

    Rectangle {
        id: backGround
        color: "#efefef"
        radius: 0
        anchors.fill: parent
        activeFocusOnTab: false
        focus: false
        layer.enabled: false
        layer.samples: 0
        transformOrigin: Item.Center

    }

    MenuBar {
            id: topMenu
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.left: parent.left
            anchors.right: parent.right

            background: Rectangle {
                        implicitHeight: 20
                        color: "#FFFFFF"
                    }

            delegate: MenuBarItem {
                        id: barItem
                        contentItem: Text {
                            text: barItem.text
                            font.pixelSize: 11
                            color: barItem, "#090909"
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: barItem.highlighted ? "#aaaaaa" : "transparent"
                        }
                    }

            Menu {
                title: qsTr("Файл")
                MenuItem { text: qsTr("Новий") }
                MenuItem { text: qsTr("Вихід"); onTriggered: Qt.quit() }
            }
            Menu {
                title: qsTr("Налаштування")
                MenuItem { text: qsTr("Параметри") }
            }
        }

}