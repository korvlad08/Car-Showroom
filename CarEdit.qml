import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15

Item {
    id: carEditWindow
    width: 760
    height: 640
    Rectangle{
        id: carEditBack
        color: "#f3f3f3"
        anchors.fill: parent

        ColumnLayout {
            id: carEditCol
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            spacing: 10

            RowLayout {
                id: mainEditRow
                width: 100
                height: 100
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout {
                    id: carPropCol
                    width: 100
                    height: 100
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    GroupBox {
                        id: carInfoBox
                        width: 200
                        height: 200
                        title: "Загальні відомості"
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        GridLayout {
                            id: carInfoGrid
                            anchors.fill: parent
                            columnSpacing: 12
                            rowSpacing: 8
                            columns: 2

                            Text {
                                id: brandText
                                text: "Марка"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            TextField {
                                id: brandInput
                                placeholderText: "напр. BMW"
                                Layout.preferredHeight: 28
                                Layout.fillWidth: true
                            }

                            Text {
                                id: modelText
                                text: "Модель"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            TextField {
                                id: modelInput
                                placeholderText: "напр. 3-series"
                                Layout.fillWidth: true
                                Layout.preferredHeight: 28
                            }

                            Text {
                                id: yearText
                                text: "Рік випуску"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            TextField {
                                id: yearInput
                                placeholderText: "1950-2026"
                                Layout.preferredHeight: 28
                                Layout.fillWidth: true
                            }

                            Text {
                                id: colorText
                                text: "Колір"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            RowLayout {
                                id: colorRow
                                width: 100
                                height: 100
                                Layout.fillWidth: true

                                Rectangle {
                                    id: colorSquare
                                    width: 200
                                    height: 200
                                    radius: 4
                                    color: colorCmb.currentValue
                                    border.color: "#adadad"
                                    Layout.preferredWidth: 28
                                    Layout.preferredHeight: 28
                                    Layout.fillWidth: false
                                    Layout.fillHeight: false
                                }

                                ComboBox {
                                    id: colorCmb
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 28

                                    font.pixelSize: 13

                                    textRole: "name"
                                    valueRole: "hex"
                                    model: [
                                            { name: "Білий",         hex: "#ffffff" },                                            { name: "Перламутровий", hex: "#f2efe6" },
                                            { name: "Сріблястий",    hex: "#c0c4c8" },
                                            { name: "Сірий",         hex: "#8a8f94" },
                                            { name: "Графітовий",    hex: "#4a4e52" },
                                            { name: "Чорний",        hex: "#1a1a1a" },
                                            { name: "Червоний",      hex: "#c62828" },
                                            { name: "Бордовий",      hex: "#7b1f2a" },
                                            { name: "Синій",         hex: "#1565c0" },
                                            { name: "Темно-синій",   hex: "#1c2e4a" },
                                            { name: "Блакитний",     hex: "#5fa8d3" },
                                            { name: "Зелений",       hex: "#2e7d32" },
                                            { name: "Оливковий",     hex: "#6b6e3a" },
                                            { name: "Бежевий",       hex: "#d8c8a8" },
                                            { name: "Коричневий",    hex: "#6d4c41" },
                                            { name: "Жовтий",        hex: "#f2c200" },
                                            { name: "Помаранчевий",  hex: "#e8731a" }
                                        ]

                                    background: Rectangle {
                                        color: "#ffffff"
                                        border.color: "#c4c4c4"
                                        border.width: 1
                                        radius: 3
                                    }
                                }
                            }
                        }
                    }

                    GroupBox {
                        id: carEngineBox
                        width: 200
                        height: 200
                        title: "Двигун"
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        GridLayout {
                            id: engineGrid
                            anchors.fill: parent
                            columns: 2

                            Text {
                                id: fuelTypeText
                                text: "Тип пального"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            ComboBox {
                                id: fuelTypeCmb
                                Layout.fillWidth: true
                                Layout.preferredHeight: 28

                                font.pixelSize: 13

                                model: ["Бензин","Дизель","Електро","Гібрид"]

                                background: Rectangle {
                                    color: "#ffffff"
                                    border.color: "#c4c4c4"
                                    border.width: 1
                                    radius: 3
                                }
                            }

                            Text {
                                id: volumeEngineText
                                text: "Об'єм, л"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                                Layout.fillWidth: false
                            }

                            TextField {
                                id: volumeEngineInput
                                placeholderText: "напр. 2.5"
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: 28
                            }

                            Text {
                                id: powerEngineText
                                text: "Потужність, к.с."
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            TextField {
                                id: powerEngineInput
                                placeholderText: "напр. 200"
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: 28
                            }

                            Text {
                                id: fuelRateText
                                text: "Витрата, л/100км"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            TextField {
                                id: fuelRateInput
                                placeholderText: "напр. 5.7"
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: 28
                            }
                        }
                    }

                    GroupBox {
                        id: carSaleBox
                        width: 200
                        height: 200
                        title: "Продаж"
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        GridLayout {
                            id: carSaleGrid
                            anchors.fill: parent
                            columns: 2

                            Text {
                                id: configurationText
                                text: "Комплектація"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            RowLayout {
                                id: configurationRow
                                width: 100
                                height: 100
                                Layout.rightMargin: 10

                                ComboBox {
                                    id: configurationCmb
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 300
                                    Layout.preferredHeight: 28

                                    font.pixelSize: 13

                                    model: ["Standard","Comfort","Premium","Luxury","Sport"]

                                    background: Rectangle {
                                        color: "#ffffff"
                                        border.color: "#c4c4c4"
                                        border.width: 1
                                        radius: 3
                                    }
                                }

                                Button {
                                    id: configurationBtn
                                    text: qsTr("Налаштувати...")
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 28

                                    font.pixelSize: 13
                                    Layout.preferredWidth: 150
                                    leftPadding: 12
                                    rightPadding: 12

                                    contentItem: Text {
                                        text: configurationBtn.text
                                        font: configurationBtn.font
                                        color: "#1a1a1a"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    background: Rectangle {
                                        implicitHeight: 28
                                        implicitWidth: 70
                                        radius: 3
                                        border.color: "#c4c4c4"
                                        color: configurationBtn.down ? "#e2e2e2" : (configurationBtn.hovered ? "#f2f2f2" : "#ffffff")
                                    }
                                }
                            }

                            Text {
                                id: priceText
                                text: "Ціна, $"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            TextField {
                                id: priceInput
                                placeholderText: "напр. 25500"
                                Layout.preferredHeight: 28
                            }

                            Text {
                                id: statusText
                                text: "Стан"
                                font.pixelSize: 12
                                Layout.preferredWidth: 110
                            }

                            RowLayout {
                                id: rowLayout1
                                width: 100
                                height: 100
                                Layout.rightMargin: 10

                                RadioButton {
                                    id: newRBtn
                                    text: qsTr("Новий")
                                    Layout.preferredHeight: 28

                                    font.pixelSize: 13
                                    spacing: 6

                                    indicator: Rectangle {
                                            implicitWidth: 14
                                            implicitHeight: 14
                                            x: newRBtn.leftPadding
                                            y: (newRBtn.height - height) / 2
                                            radius: 7
                                            color: "#ffffff"
                                            border.color: newRBtn.checked ? "#0067c0" : "#8a8a8a"
                                            border.width: 1

                                            Rectangle {
                                                anchors.centerIn: parent
                                                width: 8
                                                height: 8
                                                radius: 4
                                                color: "#0067c0"
                                                visible: newRBtn.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: newRBtn.text
                                            font: newRBtn.font
                                            color: "#1a1a1a"
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: newRBtn.indicator.width + newRBtn.spacing
                                        }
                                }

                                RadioButton {
                                    id: usedRBtn
                                    text: qsTr("Вживаний")

                                    font.pixelSize: 13
                                    spacing: 6

                                    indicator: Rectangle {
                                            implicitWidth: 14
                                            implicitHeight: 14
                                            x: usedRBtn.leftPadding
                                            y: (usedRBtn.height - height) / 2
                                            radius: 7
                                            color: "#ffffff"
                                            border.color: usedRBtn.checked ? "#0067c0" : "#8a8a8a"
                                            border.width: 1

                                            Rectangle {
                                                anchors.centerIn: parent
                                                width: 8
                                                height: 8
                                                radius: 4
                                                color: "#0067c0"
                                                visible: usedRBtn.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: usedRBtn.text
                                            font: usedRBtn.font
                                            color: "#1a1a1a"
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: usedRBtn.indicator.width + usedRBtn.spacing
                                        }
                                }

                                Text {
                                    id: mileageText
                                    text: "Пробіг, км"
                                    font.pixelSize: 12
                                    Layout.leftMargin: 20
                                    Layout.preferredWidth: 60
                                }

                                TextField {
                                    id: mileageInput
                                    placeholderText: "напр. 135000"
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 150
                                    Layout.preferredHeight: 28
                                }
                            }
                        }
                    }

                }

                GroupBox {
                    id: carImgBox
                    width: 200
                    height: 200
                    title: "Фото"
                    Layout.preferredWidth: 200
                    Layout.fillHeight: true
                    Layout.fillWidth: false

                    ColumnLayout {
                        id: carImgCol
                        anchors.fill: parent

                        Rectangle {
                            id: rectangle
                            width: 200
                            height: 200
                            color: "#bababa"
                            Layout.preferredWidth: 0
                            Layout.preferredHeight: 150
                            Layout.margins: 5
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.fillWidth: true
                        }

                        Text {
                            id: imgText
                            text: qsTr("Text")
                            font.pixelSize: 12
                        }

                        Button {
                            id: addImg
                            text: qsTr("Додати фото...")
                            Layout.fillWidth: true

                            font.pixelSize: 13
                            leftPadding: 12
                            rightPadding: 12

                            contentItem: Text {
                                text: addImg.text
                                font: addImg.font
                                color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                implicitHeight: 28
                                implicitWidth: 70
                                radius: 3
                                border.color: "#c4c4c4"
                                color: addImg.down ? "#004c99" : (addImg.hovered ? "#0a6ad0" : "#0060c0")
                            }
                        }

                        Button {
                            id: delImg
                            text: qsTr("Видалити фото")
                            Layout.fillWidth: true

                            font.pixelSize: 13
                            leftPadding: 12
                            rightPadding: 12

                            contentItem: Text {
                                text: delImg.text
                                font: delImg.font
                                color: "#1a1a1a"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                implicitHeight: 28
                                implicitWidth: 70
                                radius: 3
                                border.color: "#c4c4c4"
                                color: delImg.down ? "#e2e2e2" : (delImg.hovered ? "#f2f2f2" : "#ffffff")
                            }
                        }

                        Item {
                            id: item1
                            width: 200
                            height: 200
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }
            }

            RowLayout {
                id: saveEditRow
                width: 100
                height: 100
                Layout.fillHeight: false
                Layout.fillWidth: true

                Item {
                    id: saveSpace
                    width: 200
                    height: 200
                    Layout.preferredHeight: 26
                    Layout.fillWidth: true
                }

                Button {
                    id: saveBtn
                    text: qsTr("Зберегти")
                    Layout.preferredHeight: 28
                    Layout.fillWidth: false

                    font.pixelSize: 13
                    leftPadding: 12
                    rightPadding: 12

                    contentItem: Text {
                        text: saveBtn.text
                        font: saveBtn.font
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: 28
                        implicitWidth: 70
                        radius: 3
                        border.color: "#4747ff"
                        color: saveBtn.down ? "#004c99" : (saveBtn.hovered ? "#0a6ad0" : "#0060c0")
                    }
                }

                Button {
                    id: cancelbtn
                    text: qsTr("Скасувати")
                    Layout.preferredHeight: 28
                    Layout.fillWidth: false

                    font.pixelSize: 13
                    leftPadding: 12
                    rightPadding: 12

                    contentItem: Text {
                        text: cancelbtn.text
                        font: cancelbtn.font
                        color: "#1a1a1a"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: 28
                        implicitWidth: 70
                        radius: 3
                        border.color: "#c4c4c4"
                        color: cancelbtn.down ? "#e2e2e2" : (cancelbtn.hovered ? "#f2f2f2" : "#ffffff")
                    }
                }
            }
        }
    }
}