import QtQuick
import QtQuick.Controls.Basic

ApplicationWindow {
    width: 760
    height: 640
    visible: true
    title: "Car Showroom"

    CarEdit {
        anchors.fill: parent
    }
}