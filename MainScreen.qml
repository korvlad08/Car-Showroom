import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: backGround
    width: 1280
    height: 720
    property var car: carList.currentIndex >= 0 ? carModel.get(carList.currentIndex) : null
    clip: false
    transformOrigin: Item.Center
    color: "#f3f3f3"

    ColumnLayout {
        id: mainFormCol
        anchors.fill: parent
        spacing: 0

        MenuBar {
            id: topMenu
            Layout.fillWidth: true

            background: Rectangle {
                implicitHeight: 20
                color: "#FFFFFF"

                Rectangle {
                    anchors.top: parent.top
                    width: parent.width
                    height: 1
                    color: "#dadada"
                }
            }

            delegate: MenuBarItem {
                id: barItem
                contentItem: Text {
                    text: barItem.text
                    font.pixelSize: 11
                    color: "#090909"
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
                title: qsTr("Автомобіль")
                MenuItem { text: qsTr("Параметри") }
            }
            Menu {
                title: qsTr("Пошук")
                MenuItem { text: qsTr("Параметри") }
            }
            Menu {
                title: qsTr("Тест-драйв")
                MenuItem { text: qsTr("Параметри") }
            }
            Menu {
                title: qsTr("Довідка")
                MenuItem { text: qsTr("Параметри") }
            }
        }

        Rectangle {
            id: toolBar
            color: "#f3f3f3"
            Layout.fillHeight: false
            Layout.preferredHeight: 46
            Layout.fillWidth: true
            border.width: 1;
            border.color: "#dadada"

            RowLayout {
                id: toolBarRow
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 6


                Button {
                    id: openBtn
                    text: qsTr("Відкрити…")
                    font.pixelSize: 13
                    leftPadding: 12
                    rightPadding: 12

                    contentItem: Text {
                        text: openBtn.text
                        font: openBtn.font
                        color: "#1a1a1a"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: 28
                        implicitWidth: 70
                        radius: 3
                        border.color: "#c4c4c4"
                        color: openBtn.down ? "#e2e2e2" : (openBtn.hovered ? "#f2f2f2" : "#ffffff")
                    }
                }

                Button {
                    id: saveBtn
                    text: qsTr("Зберегти")

                    font.pixelSize: 13
                    leftPadding: 12
                    rightPadding: 12

                    contentItem: Text {
                        text: saveBtn.text
                        font: saveBtn.font
                        color: "#1a1a1a"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: 28
                        implicitWidth: 70
                        radius: 3
                        border.color: "#c4c4c4"
                        color: saveBtn.down ? "#e2e2e2" : (saveBtn.hovered ? "#f2f2f2" : "#ffffff")
                    }
                }

                ToolSeparator {
                    id: toolSeparator
                }

                Button {
                    id: addBtn
                    text: qsTr("Додати")

                    font.pixelSize: 13
                    leftPadding: 12
                    rightPadding: 12

                    contentItem: Text {
                        text: addBtn.text
                        font: addBtn.font
                        color: "#1a1a1a"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: 28
                        implicitWidth: 70
                        radius: 3
                        border.color: "#c4c4c4"
                        color: addBtn.down ? "#e2e2e2" : (addBtn.hovered ? "#f2f2f2" : "#ffffff")
                    }
                }



                Button {
                    id: changeBtn
                    text: qsTr("Редагувати")

                    font.pixelSize: 13
                    leftPadding: 12
                    rightPadding: 12

                    contentItem: Text {
                        text: changeBtn.text
                        font: changeBtn.font
                        color: "#1a1a1a"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: 28
                        implicitWidth: 70
                        radius: 3
                        border.color: "#c4c4c4"
                        color: changeBtn.down ? "#e2e2e2" : (changeBtn.hovered ? "#f2f2f2" : "#ffffff")
                    }
                }




                Button {
                    id: delBtn
                    text: qsTr("Видалити")

                    font.pixelSize: 13
                    leftPadding: 12
                    rightPadding: 12

                    contentItem: Text {
                        text: delBtn.text
                        font: delBtn.font
                        color: "#1a1a1a"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: 28
                        implicitWidth: 70
                        radius: 3
                        border.color: "#c4c4c4"
                        color: delBtn.down ? "#e2e2e2" : (delBtn.hovered ? "#f2f2f2" : "#ffffff")
                    }
                }


                ToolSeparator {
                    id: toolSeparator1
                }




                Button {
                    id: configBtn
                    text: qsTr("Конфігурувати...")

                    font.pixelSize: 13
                    leftPadding: 12
                    rightPadding: 12

                    contentItem: Text {
                        text: configBtn.text
                        font: configBtn.font
                        color: "#1a1a1a"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: 28
                        implicitWidth: 70
                        radius: 3
                        border.color: "#c4c4c4"
                        color: configBtn.down ? "#e2e2e2" : (configBtn.hovered ? "#f2f2f2" : "#ffffff")
                    }
                }

                Button {
                    id: testDriveBtn
                    text: qsTr("Тест-драйв...")

                    font.pixelSize: 13
                    leftPadding: 12
                    rightPadding: 12

                    contentItem: Text {
                        text: testDriveBtn.text
                        font: testDriveBtn.font
                        color: "#1a1a1a"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitHeight: 28
                        implicitWidth: 70
                        radius: 3
                        border.color: "#c4c4c4"
                        color: testDriveBtn.down ? "#e2e2e2" : (testDriveBtn.hovered ? "#f2f2f2" : "#ffffff")
                    }
                }

                Item {
                    id: toolBarSpace
                    width: 200
                    height: 200
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.fillWidth: true
                }





            }
        }

        ColumnLayout {
            id: workSpaceCol
            width: 100
            height: 100
            spacing: 10
            Layout.margins: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

            Rectangle {
                id: searchBack
                width: 200
                height: 200
                color: "#ffffff"
                radius: 4
                border.color: "#c8c8c8"
                Layout.preferredHeight: 70
                Layout.fillWidth: true
                Layout.fillHeight: false

                RowLayout {
                    id: searchRow
                    x: 0
                    y: 618
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    spacing: 12

                    ColumnLayout {
                        id: modelCol
                        width: 100
                        height: 100

                        Text {
                            id: modelText
                            text: "Модель/Марка"
                            font.pixelSize: 12
                        }

                        TextField {
                            id: modelInput
                            width: 80
                            height: 20
                            font.pixelSize: 12
                            passwordCharacter: "\u25cf"
                            inputMask: ""
                            selectedTextColor: "#ffffff"
                            selectionColor: "#0000ff"
                            Layout.preferredHeight: 28
                            Layout.preferredWidth: 234
                        }
                    }

                    RowLayout {
                        id: priceRow
                        width: 100
                        height: 100

                        ColumnLayout {
                            id: priceMinCol
                            width: 100
                            height: 100

                            Text {
                                id: priceMinText
                                text: "Ціна від, $"
                                font.pixelSize: 12
                            }

                            TextField {
                                id: priceMinInput
                                width: 80
                                height: 20
                                font.pixelSize: 12
                                inputMask: ""
                                Layout.preferredHeight: 28
                                Layout.preferredWidth: 114
                            }
                        }

                        ColumnLayout {
                            id: priceMaxCol
                            width: 100
                            height: 100

                            Text {
                                id: priceMaxText
                                text: "до, $"
                                font.pixelSize: 12
                            }

                            TextField {
                                id: priceMaxInput
                                width: 80
                                height: 20
                                font.pixelSize: 12
                                Layout.preferredHeight: 28
                                Layout.preferredWidth: 114
                            }
                        }
                    }

                    ColumnLayout {
                        id: stateCol
                        width: 100
                        height: 100

                        Text {
                            id: stateText
                            text: "Стан"
                            font.pixelSize: 12
                        }

                        ComboBox {
                            id: stateCmb
                            Layout.preferredWidth: 130
                            Layout.preferredHeight: 28
                            font.pixelSize: 13

                            model: ["Усі","Новий","Вживаний"]

                            background: Rectangle {
                                color: "#ffffff"
                                border.color: "#c4c4c4"
                                border.width: 1
                                radius: 3
                            }

                        }
                    }


                    RowLayout {
                        id: searchRowBtn
                        width: 100
                        height: 100
                        Layout.preferredHeight: 28
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

                        Button {
                            id: searchBtn
                            text: qsTr("Знайти")
                            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

                            font.pixelSize: 13
                            Layout.preferredHeight: 28
                            leftPadding: 12
                            rightPadding: 12

                            contentItem: Text {
                                text: searchBtn.text
                                font: searchBtn.font
                                color: "#1a1a1a"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                implicitHeight: 28
                                implicitWidth: 70
                                radius: 3
                                border.color: "#c4c4c4"
                                color: searchBtn.down ? "#e2e2e2" : (searchBtn.hovered ? "#f2f2f2" : "#ffffff")
                            }
                        }

                        Button {
                            id: resetBtn
                            text: qsTr("Скинути")

                            font.pixelSize: 13
                            Layout.topMargin: 0
                            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                            Layout.preferredHeight: 28
                            Layout.fillHeight: false
                            leftPadding: 12
                            rightPadding: 12

                            contentItem: Text {
                                text: resetBtn.text
                                font: resetBtn.font
                                color: "#1a1a1a"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                implicitHeight: 28
                                implicitWidth: 70
                                radius: 3
                                border.color: "#c4c4c4"
                                color: resetBtn.down ? "#e2e2e2" : (resetBtn.hovered ? "#f2f2f2" : "#ffffff")
                            }
                        }
                    }

                    Item {
                        id: searchSpace
                        width: 200
                        height: 200
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        id: sortRow
                        width: 100
                        height: 100

                        ColumnLayout {
                            id: sortCol
                            width: 100
                            height: 100

                            Text {
                                id: sortText
                                text: "Сортува(методом Шелла) за"
                                font.pixelSize: 12
                            }

                            ComboBox {
                                id: sortCmb
                                Layout.preferredHeight: 28
                                Layout.preferredWidth: 130
                                font.pixelSize: 13

                                model: ["Моделью","Роком виготовлення","Потужністю двигуна","кольором","Витратою палива","Станом"]

                                background: Rectangle {
                                    color: "#ffffff"
                                    border.color: "#c4c4c4"
                                    border.width: 1
                                    radius: 3
                                }
                            }
                        }

                        Button {
                            id: sortBtn
                            text: qsTr("Сортувати")
                            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

                            font.pixelSize: 13
                            leftPadding: 12
                            rightPadding: 12

                            contentItem: Text {
                                text: sortBtn.text
                                font: sortBtn.font
                                color: "#1a1a1a"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                implicitHeight: 28
                                implicitWidth: 70
                                radius: 3
                                border.color: "#c4c4c4"
                                color: sortBtn.down ? "#e2e2e2" : (sortBtn.hovered ? "#f2f2f2" : "#ffffff")
                            }
                        }
                    }




                }
            }

            RowLayout {
                id: carRow
                width: 100
                height: 100
                spacing: 10
                Layout.preferredWidth: -1
                Layout.preferredHeight: -1
                Layout.fillHeight: true
                Layout.fillWidth: true

                Rectangle {
                    id: listBack
                    width: 200
                    height: 200
                    color: "#ffffff"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    border.color: "#c8c8c8"
                    radius: 4

                    ListView {
                        id: carList
                        anchors.fill: parent
                        anchors.margins: 1
                        clip: true
                        currentIndex: 0

                        model: carModel

                        headerPositioning: ListView.OverlayHeader

                        header: Rectangle {
                            z: 2
                            width: carList.width
                            height: 30
                            color: "#f7f7f7"

                            Row {
                                anchors.fill: parent

                                Text {
                                    width: 60;
                                    text: qsTr("Фото");
                                    font.bold: true;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 160;
                                    text: qsTr("Модель");
                                    font.bold: true;
                                    leftPadding: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    width: 60;
                                    text: qsTr("Рік");
                                    font.bold: true;
                                    leftPadding: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 160;
                                    text: qsTr("Двигун");
                                    font.bold: true;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 110;
                                    text: qsTr("Колір");
                                    font.bold: true;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 160;
                                    text: qsTr("Комплектація");
                                    font.bold: true;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 80;
                                    text: qsTr("л/100км");
                                    font.bold: true;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 80;
                                    text: qsTr("Ціна");
                                    font.bold: true;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 80;
                                    text: qsTr("Стан");
                                    font.bold: true;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: "#dcdcdc"
                            }
                        }

                        delegate: Rectangle {
                            required property string name
                            required property int year
                            required property string engine
                            required property string carColor
                            required property string trim
                            required property double consumption
                            required property int price
                            required property string condition
                            required property int index
                            width: carList.width
                            height: 37
                            Row {
                                anchors.fill: parent
                                Text {
                                    width: 60;
                                    text: "photo";
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 160;
                                    text: name;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 60;
                                    text: year;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 160;
                                    text: engine;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 110;
                                    text: carColor;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 160;
                                    text: trim;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 80;
                                    text: consumption;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 80;
                                    text: price;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 80;
                                    text: condition;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                            }

                            color: carList.currentIndex === index ? "#cce4f7" : "white"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: carList.currentIndex = index
                            }
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "#c8c8c8"
                        border.width: 1
                        radius: 4
                    }
                }

                Rectangle {
                    id: carBack
                    width: 200
                    height: 200
                    color: "#f7f7f7"
                    border.color: "#c8c8c8"
                    border.width: 1
                    radius: 4
                    Layout.fillHeight: true
                    Layout.preferredWidth: 290

                    ColumnLayout {
                        id: columnLayout
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.topMargin: 10
                        anchors.bottomMargin: 10
                        spacing: 10

                        Text {
                            id: chosenCarText
                            text: "Обраний автомобіль"
                            font.pixelSize: 12
                            font.bold: true
                        }

                        Rectangle {
                            id: imgBack
                            width: 200
                            height: 200
                            color: "#ffffff"
                            Layout.preferredHeight: 150
                            Layout.fillWidth: true
                        }

                        Label {
                            text: car ? car.name : ""; font.bold: true; font.pixelSize: 15
                        }

                        GridLayout {
                            id: carPropertiesGrid
                            width: 100
                            height: 100
                            columns: 2

                            Label { text: qsTr("Рік") }
                            Label { text: car ? car.year : "" }

                            Label { text: qsTr("Двигун") }
                            Label { text: car ? car.engine : "" }

                            Label { text: qsTr("Колір") }
                            Label { text: car ? car.carColor : "" }

                            Label { text: qsTr("Комплектація") }
                            Label { text: car ? car.trim : "" }

                            Label { text: qsTr("Витрата") }
                            Label { text: car ? car.consumption + " л/100 км" : "" }

                            Label { text: qsTr("Стан") }
                            Label { text: car ? car.condition : "" }

                            Label { text: qsTr("Ціна") }
                            Label { text: car ? "$" + car.price : ""; font.bold: true }
                        }

                        Item {
                            id: carSpace
                            width: 200
                            height: 200
                            Layout.fillHeight: true
                        }

                        Button {
                            id: imgChange
                            text: qsTr("Змінити фото...")
                            Layout.fillWidth: true

                            contentItem: Text {
                                text: imgChange.text
                                font: imgChange.font
                                color: "#1a1a1a"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                implicitHeight: 28
                                implicitWidth: 70
                                radius: 3
                                border.color: "#c4c4c4"
                                color: imgChange.down ? "#e2e2e2" : (imgChange.hovered ? "#f2f2f2" : "#ffffff")
                            }
                        }

                        Button {
                            id: testDrive
                            text: qsTr("Записатись на тест-драйв")
                            Layout.fillWidth: true

                            contentItem: Text {
                                text: testDrive.text
                                font: testDrive.font
                                color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                implicitHeight: 28
                                implicitWidth: 76
                                radius: 3
                                border.color: "#4747ff"
                                color: testDrive.down ? "#004c99" : (testDrive.hovered ? "#0a6ad0" : "#0060c0")
                            }
                        }


                    }
                }
            }
        }

        ListModel {
            id: carModel
            ListElement { name: "Toyota Camry"; year: 2022; engine: "2.5 бензин, 203 к.с."; carColor: "Білий"; trim: "Comfort"; consumption: 7.8; price: 27500; condition: "Вживаний" }
            ListElement { name: "BMW 3-series"; year: 2022; engine: "3.0 бензин, 305 к.с."; carColor: "Чорний"; trim: "Sport"; consumption: 15.0; price: 50000; condition: "Новий" }
        }

        Rectangle {
            id: status
            width: 200
            height: 200
            color: "#ffffff"
            Layout.preferredHeight: 26
            Layout.fillWidth: true

            RowLayout {
                id: rowLayout
                anchors.fill: parent
                layoutDirection: Qt.LeftToRight
                uniformCellSizes: true
                spacing: 3
                Layout.rightMargin: 4

                Text {
                    id: carCount
                    text: qsTr("Знайдено: 6 з 14");
                    font.pixelSize: 12
                    Layout.leftMargin: 10
                }
                Text { id: sortInfo; text: qsTr("Відсортовано за ціною (метод Шелла)"); font.pixelSize: 12 }
                Text { id: fileInfo; text: qsTr("Файл: D:\\autosalon\\cars.dat"); font.pixelSize: 12 }
                Item { id: statusSpace; Layout.fillHeight: true; Layout.fillWidth: true }
            }

            Rectangle {
                id: statusBorder
                    anchors.top: parent.top
                    width: parent.width
                    height: 1
                    color: "#d0d0d0"
                }
        }

    }

}