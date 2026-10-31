import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15

// Форма додавання / редагування автомобіля.
// openForNew() — порожня форма, openForEdit(id) — дані авто з контролера.
// Перевірку значень робить C++ (Car::validate), помилку показує вікно в MainScreen.
// Комплектація і колір тут лише показуються: їх задає конфігуратор (кнопка «Налаштувати…»).
Item {
    id: carEditWindow
    implicitWidth: 760
    implicitHeight: 640

    property int carId: -1                     // -1 — новий автомобіль
    readonly property bool isNew: carId < 0

    property string trimName: ""
    property string colorName: ""

    signal saved(int carId)
    signal cancelled()
    signal configureRequested(int carId)

    function openForNew() {
        carId = -1
        trimName = ""
        colorName = ""
        brandInput.text = ""
        modelInput.text = ""
        yearInput.text = ""
        fuelTypeCmb.currentIndex = 0
        volumeEngineInput.text = ""
        powerEngineInput.text = ""
        fuelRateInput.text = ""
        priceInput.text = ""
        newRBtn.checked = true
        mileageInput.text = "0"
        brandInput.forceActiveFocus()
    }

    function openForEdit(id) {
        const car = showroom.carForForm(id)
        if (car.carId === undefined)
            return false

        carId = car.carId
        trimName = car.trim
        colorName = car.color

        brandInput.text = car.brand
        modelInput.text = car.model
        yearInput.text = car.year
        priceInput.text = car.price
        mileageInput.text = car.mileage
        newRBtn.checked = car.condition === "New"
        usedRBtn.checked = car.condition !== "New"
        fuelRateInput.text = car.consumption > 0 ? car.consumption.toFixed(1) : ""

        const engine = parseEngine(car.engine)
        fuelTypeCmb.currentIndex = engine.fuel
        volumeEngineInput.text = engine.volume
        powerEngineInput.text = engine.power

        brandInput.forceActiveFocus()
        return true
    }

    // Після «Застосувати» в конфігураторі оновлює лише комплектацію і колір,
    // решта введених у формі значень лишається
    function reloadConfiguration() {
        const car = showroom.carForForm(carId)
        if (car.carId !== undefined) {
            trimName = car.trim
            colorName = car.color
        }
    }

    // "2.5 бензин, 200 к.с." -> { volume: "2.5", fuel: 0, power: "200" }
    function parseEngine(text) {
        const result = { volume: "", fuel: 0, power: "" }
        if (!text)
            return result

        const power = text.match(/(\d+)\s*к\.с/)
        if (power)
            result.power = power[1]

        const rest = text.replace(/,?\s*\d+\s*к\.с\.?/, "")
        const volume = rest.match(/\d+(?:[.,]\d+)?/)
        if (volume)
            result.volume = volume[0].replace(",", ".")

        const lower = rest.toLowerCase()
        for (let i = 0; i < fuelTypeCmb.count; ++i) {
            if (lower.indexOf(fuelTypeCmb.textAt(i).toLowerCase()) >= 0) {
                result.fuel = i
                break
            }
        }
        return result
    }

    // Поля двигуна -> один рядок для Car::engine, напр. "2.5 бензин, 200 к.с."
    function composeEngine() {
        const volume = volumeEngineInput.text.trim().replace(",", ".")
        let engine = (volume ? volume + " " : "") + fuelTypeCmb.currentText.toLowerCase()
        const power = powerEngineInput.text.trim()
        if (power)
            engine += ", " + power + " к.с."
        return engine
    }

    function save() {
        const data = {
            brand: brandInput.text,
            model: modelInput.text,
            year: yearInput.text,
            price: priceInput.text,
            mileage: mileageInput.text,
            condition: newRBtn.checked ? "New" : "Used",
            engine: composeEngine(),
            consumption: fuelRateInput.text,
            trim: trimName,
            color: colorName
        }

        if (isNew) {
            const newId = showroom.addCar(data)
            if (newId > 0)
                saved(newId)
        } else if (showroom.editCar(carId, data)) {
            saved(carId)
        }
    }

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
                                validator: IntValidator { bottom: 0 }
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
                                    color: configurator.colorHex(carEditWindow.colorName) || "transparent"
                                    border.color: "#adadad"
                                    Layout.preferredWidth: 28
                                    Layout.preferredHeight: 28
                                    Layout.fillWidth: false
                                    Layout.fillHeight: false
                                }

                                Text {
                                    id: colorValue
                                    text: carEditWindow.colorName || qsTr("— (задається в конфігураторі)")
                                    font.pixelSize: 13
                                    color: carEditWindow.colorName ? "#1a1a1a" : "#8a8a8a"
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter
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
                                validator: RegularExpressionValidator { regularExpression: /\d{0,2}([.,]\d?)?/ }
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
                                validator: IntValidator { bottom: 0; top: 2000 }
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
                                validator: RegularExpressionValidator { regularExpression: /\d{0,3}([.,]\d?)?/ }
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

                                Text {
                                    id: trimValue
                                    text: carEditWindow.trimName || "—"
                                    font.pixelSize: 13
                                    color: carEditWindow.trimName ? "#1a1a1a" : "#8a8a8a"
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: 300
                                    Layout.preferredHeight: 28
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Button {
                                    id: configurationBtn
                                    text: qsTr("Налаштувати...")
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 28
                                    enabled: !carEditWindow.isNew
                                    onClicked: carEditWindow.configureRequested(carEditWindow.carId)
                                    ToolTip.visible: hovered
                                    ToolTip.delay: 300
                                    ToolTip.text: carEditWindow.isNew
                                                  ? qsTr("Спочатку збережіть автомобіль, потім налаштуйте комплектацію")
                                                  : qsTr("Вибрати комплектацію, колір і опції в конфігураторі")

                                    font.pixelSize: 13
                                    Layout.preferredWidth: 150
                                    leftPadding: 12
                                    rightPadding: 12

                                    contentItem: Text {
                                        text: configurationBtn.text
                                        font: configurationBtn.font
                                        color: configurationBtn.enabled ? "#1a1a1a" : "#9a9a9a"
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
                                validator: IntValidator { bottom: 0 }
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
                                    checked: true
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
                                    validator: IntValidator { bottom: 0 }
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
                            text: qsTr("Фото не додано")
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
                    onClicked: carEditWindow.save()
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: carEditWindow.isNew ? qsTr("Додати автомобіль до списку") : qsTr("Зберегти зміни")

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
                    onClicked: carEditWindow.cancelled()

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
