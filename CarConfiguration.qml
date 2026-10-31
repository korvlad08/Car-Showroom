pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: carConfiguration
    width: 900
    height: 620

    signal applyClicked()
    signal cancelClicked()

    // Усі дані беруться з ConfiguratorController (C++), екран лише показує їх
    readonly property var selectedTrim: configurator.trimIndex >= 0 ? configurator.trims[configurator.trimIndex] : null
    readonly property var selectedColor: configurator.colorIndex >= 0 ? configurator.colors[configurator.colorIndex] : null
    readonly property var selectedOptions: configurator.addOns.filter((o, i) => configurator.addOnStates[i] === true)

    function money(v) {
        return "$" + Number(v).toLocaleString(Qt.locale("uk_UA"), "f", 0)
    }

    component SectionBox: GroupBox {
        id: box
        Layout.fillWidth: true
        topPadding: 26
        leftPadding: 12
        rightPadding: 12
        bottomPadding: 12

        label: Text {
            x: 10
            text: box.title
            font.pixelSize: 13
            color: "#1a1a1a"
            leftPadding: 4
            rightPadding: 4

            Rectangle {
                anchors.fill: parent
                color: "#f3f3f3"
                z: -1
            }
        }

        background: Rectangle {
            y: 8
            width: box.width
            height: box.height - 8
            color: "transparent"
            border.color: "#d0d0d0"
            radius: 4
        }
    }

    component TrimCard: RadioButton {
        id: card
        property string description: ""
        property int extraPrice: 0

        Layout.fillWidth: true
        Layout.preferredWidth: 1
        implicitHeight: 82
        padding: 12
        checkable: false

        indicator: Rectangle {
            implicitWidth: 14
            implicitHeight: 14
            x: card.leftPadding
            y: card.topPadding + 2
            radius: 7
            color: "#ffffff"
            border.color: card.checked ? "#0067c0" : "#8a8a8a"

            Rectangle {
                anchors.centerIn: parent
                width: 8
                height: 8
                radius: 4
                color: "#0067c0"
                visible: card.checked
            }
        }

        contentItem: Column {
            spacing: 6

            Text {
                text: card.text
                leftPadding: card.indicator.width + 8
                font.pixelSize: 13
                font.bold: true
                color: "#1a1a1a"
            }
            Text {
                text: card.description
                width: parent.width
                elide: Text.ElideRight
                font.pixelSize: 12
                color: "#5f5f5f"
            }
            Text {
                text: "+ " + carConfiguration.money(card.extraPrice)
                font.pixelSize: 13
                color: "#1a1a1a"
            }
        }

        background: Rectangle {
            radius: 4
            color: card.checked ? "#eaf3fb" : (card.hovered ? "#fafafa" : "#ffffff")
            border.color: card.checked ? "#0067c0" : "#d2d2d2"
            border.width: card.checked ? 2 : 1
        }
    }

    component OptionCheck: CheckBox {
        id: control
        property string optionName: ""
        property string shortName: optionName
        property int price: 0

        text: optionName + " (+ " + carConfiguration.money(price) + ")"
        checkable: false
        font.pixelSize: 13
        spacing: 8
        padding: 2

        indicator: Rectangle {
            implicitWidth: 14
            implicitHeight: 14
            x: control.leftPadding
            y: (control.height - height) / 2
            radius: 2
            color: control.checked ? "#0067c0" : "#ffffff"
            border.color: control.checked ? "#0067c0" : (control.hovered ? "#5f5f5f" : "#989898")

            Canvas {
                anchors.fill: parent
                visible: control.checked
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    ctx.strokeStyle = "#ffffff"
                    ctx.lineWidth = 1.8
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"
                    ctx.beginPath()
                    ctx.moveTo(width * 0.22, height * 0.52)
                    ctx.lineTo(width * 0.42, height * 0.72)
                    ctx.lineTo(width * 0.78, height * 0.30)
                    ctx.stroke()
                }
            }
        }

        contentItem: Text {
            text: control.text
            font: control.font
            color: "#1a1a1a"
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.indicator.width + control.spacing
        }
    }

    component PriceRow: RowLayout {
        id: row
        property string name: ""
        property string value: ""
        property bool bold: false
        property int size: 13
        Layout.fillWidth: true

        Text {
            text: row.name
            Layout.fillWidth: true
            elide: Text.ElideRight
            font.pixelSize: row.size
            font.bold: row.bold
            color: row.bold ? "#1a1a1a" : "#5f5f5f"
        }
        Text {
            text: row.value
            font.pixelSize: row.size
            font.bold: row.bold
            color: "#1a1a1a"
        }
    }

    component FlatButton: Button {
        id: btn
        property bool accent: false

        Layout.preferredHeight: 28
        font.pixelSize: 13
        leftPadding: 14
        rightPadding: 14

        contentItem: Text {
            text: btn.text
            font: btn.font
            color: btn.accent ? "#ffffff" : "#1a1a1a"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            implicitHeight: 28
            implicitWidth: 80
            radius: 3
            border.color: btn.accent ? "transparent" : "#c4c4c4"
            color: btn.accent
                   ? (btn.down ? "#004c99" : (btn.hovered ? "#0a74d6" : "#0067c0"))
                   : (btn.down ? "#e2e2e2" : (btn.hovered ? "#f2f2f2" : "#ffffff"))
        }
    }

    Rectangle {
        id: configBack
        anchors.fill: parent
        color: "#f3f3f3"

        ColumnLayout {
            id: configCol
            anchors.fill: parent
            spacing: 0

            RowLayout {
                id: configRow1
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 14
                spacing: 14

                ColumnLayout {
                    id: leftCol
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 12

                    SectionBox {
                        id: configBox
                        title: qsTr("Комплектація")

                        RowLayout {
                            anchors.fill: parent
                            spacing: 10

                            Repeater {
                                model: configurator.trims

                                delegate: TrimCard {
                                    required property var modelData
                                    required property int index
                                    text: modelData.name
                                    description: modelData.features || qsTr("Базове оснащення")
                                    extraPrice: modelData.price
                                    checked: configurator.trimIndex === index
                                    onClicked: configurator.selectTrim(index)
                                }
                            }
                        }
                    }

                    SectionBox {
                        id: engineColorBox
                        title: qsTr("Двигун і колір")

                        GridLayout {
                            anchors.fill: parent
                            columns: 2
                            rowSpacing: 10
                            columnSpacing: 12

                            Text {
                                text: qsTr("Двигун")
                                font.pixelSize: 13
                                color: "#1a1a1a"
                                Layout.preferredWidth: 110
                            }

                            // Двигун — характеристика самого авто, тут лише показується
                            Text {
                                text: configurator.carEngine || "—"
                                font.pixelSize: 13
                                color: "#1a1a1a"
                                Layout.fillWidth: true
                                Layout.preferredHeight: 28
                                verticalAlignment: Text.AlignVCenter
                            }

                            Text {
                                text: qsTr("Колір")
                                font.pixelSize: 13
                                color: "#1a1a1a"
                                Layout.preferredWidth: 110
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6

                                Repeater {
                                    model: configurator.colors

                                    delegate: Rectangle {
                                        id: swatch
                                        required property var modelData
                                        required property int index

                                        Layout.preferredWidth: 28
                                        Layout.preferredHeight: 28
                                        radius: 3
                                        color: modelData.hex
                                        border.color: configurator.colorIndex === index ? "#0067c0" : "#adadad"
                                        border.width: configurator.colorIndex === index ? 2 : 1

                                        ToolTip.visible: swatchArea.containsMouse
                                        ToolTip.text: swatch.modelData.description
                                                      + (swatch.modelData.price > 0 ? " (+ " + carConfiguration.money(swatch.modelData.price) + ")" : "")

                                        MouseArea {
                                            id: swatchArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: configurator.selectColor(swatch.index)
                                        }
                                    }
                                }

                                Text {
                                    text: !carConfiguration.selectedColor ? ""
                                          : carConfiguration.selectedColor.description
                                            + (carConfiguration.selectedColor.price > 0
                                               ? " (+ " + carConfiguration.money(carConfiguration.selectedColor.price) + ")" : "")
                                    font.pixelSize: 13
                                    color: "#1a1a1a"
                                    Layout.leftMargin: 8
                                }

                                Item { Layout.fillWidth: true }
                            }
                        }
                    }

                    SectionBox {
                        id: extraBox
                        title: qsTr("Додаткові опції")

                        GridLayout {
                            anchors.fill: parent
                            columns: 2
                            rowSpacing: 8
                            columnSpacing: 40

                            Repeater {
                                model: configurator.addOns

                                delegate: OptionCheck {
                                    required property var modelData
                                    required property int index
                                    optionName: modelData.name
                                    price: modelData.price
                                    checked: configurator.addOnStates[index] === true
                                    onClicked: configurator.toggleAddOn(index)
                                    Layout.fillWidth: true
                                    ToolTip.visible: hovered
                                    ToolTip.delay: 600
                                    ToolTip.text: modelData.description
                                }
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }
                }

                Rectangle {
                    id: pricePanel
                    Layout.preferredWidth: 254
                    Layout.fillHeight: true
                    color: "#ffffff"
                    border.color: "#e2e2e2"
                    radius: 4

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10

                        Text {
                            text: configurator.carName
                            font.pixelSize: 15
                            font.bold: true
                            color: "#1a1a1a"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: qsTr("Розрахунок ціни")
                            font.pixelSize: 13
                            font.bold: true
                            color: "#1a1a1a"
                            Layout.bottomMargin: 2
                        }

                        PriceRow {
                            name: qsTr("Базова ціна")
                            value: carConfiguration.money(configurator.basePrice)
                        }

                        PriceRow {
                            name: carConfiguration.selectedTrim ? carConfiguration.selectedTrim.name : ""
                            value: "+ " + carConfiguration.money(carConfiguration.selectedTrim ? carConfiguration.selectedTrim.price : 0)
                        }

                        PriceRow {
                            visible: carConfiguration.selectedColor !== null && carConfiguration.selectedColor.price > 0
                            name: carConfiguration.selectedColor ? carConfiguration.selectedColor.name : ""
                            value: "+ " + carConfiguration.money(carConfiguration.selectedColor ? carConfiguration.selectedColor.price : 0)
                        }

                        Repeater {
                            model: carConfiguration.selectedOptions

                            delegate: PriceRow {
                                required property var modelData
                                name: modelData.name
                                value: "+ " + carConfiguration.money(modelData.price)
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.topMargin: 2
                            Layout.bottomMargin: 6
                            Layout.preferredHeight: 1
                            color: "#efefef"
                        }

                        PriceRow {
                            name: qsTr("Разом")
                            value: carConfiguration.money(configurator.totalPrice)
                            bold: true
                            size: 16
                        }

                        Item { Layout.fillHeight: true }

                        FlatButton {
                            text: qsTr("Скинути до базової")
                            Layout.fillWidth: true
                            onClicked: configurator.reset()
                        }
                    }
                }
            }

            Rectangle {
                id: bottomBar
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                color: "#f3f3f3"

                Rectangle {
                    anchors.top: parent.top
                    width: parent.width
                    height: 1
                    color: "#e1e1e1"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    spacing: 8

                    Item { Layout.fillWidth: true }

                    FlatButton {
                        id: saveBtn
                        text: qsTr("Застосувати")
                        accent: true
                        onClicked: carConfiguration.applyClicked()
                    }

                    FlatButton {
                        id: cancelbtn
                        text: qsTr("Скасувати")
                        onClicked: carConfiguration.cancelClicked()
                    }
                }
            }
        }
    }
}
