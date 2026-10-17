import QtQuick
import QtQuick.Controls.Basic

ApplicationWindow {
    width: 900
    height: 620
    visible: true
    title: "Car Showroom"

    CarConfiguration {
        anchors.fill: parent
    }
}