import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs

Rectangle {
    id: backGround
    width: 1280
    height: 720
    clip: false
    transformOrigin: Item.Center
    color: "#f3f3f3"

    // Обраний автомобіль (знімок рядка моделі). Оновлюється при виборі рядка
    // і після кожної зміни таблиці (відкриття, пошук, сортування, видалення).
    property var car: null
    property bool sortAsc: true

    function updateSelectedCar() {
        const count = showroom.model.count
        if (count === 0) {
            car = null
            return
        }
        if (carList.currentIndex < 0)
            carList.currentIndex = 0
        else if (carList.currentIndex >= count)
            carList.currentIndex = count - 1
        car = showroom.model.get(carList.currentIndex)
    }

    function doSearch() {
        showroom.search(modelInput.text,
                        parseInt(priceMinInput.text) || 0,
                        parseInt(priceMaxInput.text) || 0,
                        stateCmb.currentIndex)
    }

    function resetSearch() {
        modelInput.text = ""
        priceMinInput.text = ""
        priceMaxInput.text = ""
        stateCmb.currentIndex = 0
        showroom.resetSearch()
    }

    function sortBy(field) {
        sortCmb.currentIndex = field
        showroom.sortBy(field, sortAsc)
    }

    function openAddForm() {
        carEditForm.openForNew()
        editDialog.open()
    }

    function openEditForm() {
        if (car && carEditForm.openForEdit(car.carId))
            editDialog.open()
    }

    function openConfigurator(id) {
        if (id !== undefined && id >= 0 && configurator.open(id))
            configDialog.open()
    }

    // Після додавання / редагування виділяє в таблиці збережене авто
    function selectCar(id) {
        for (let i = 0; i < showroom.model.count; ++i) {
            if (showroom.model.get(i).carId === id) {
                carList.currentIndex = i
                carList.positionViewAtIndex(i, ListView.Contain)
                break
            }
        }
        updateSelectedCar()
    }

    function conditionText(condition) {
        return condition === "New" ? qsTr("Новий") : qsTr("Вживаний")
    }

    function consumptionText(consumption) {
        return consumption > 0 ? consumption.toFixed(1) : "—"
    }

    Connections {
        target: showroom.model
        function onModelReset() { Qt.callLater(backGround.updateSelectedCar) }
    }

    Connections {
        target: showroom
        function onErrorOccurred(message) {
            errorDialog.text = message
            errorDialog.open()
        }
    }

    Connections {
        target: configurator
        function onErrorOccurred(message) {
            errorDialog.text = message
            errorDialog.open()
        }
        function onApplied(carId) {
            configDialog.close()
            if (editDialog.opened)
                carEditForm.reloadConfiguration()
            else
                backGround.selectCar(carId)
        }
    }

    FileDialog {
        id: openDialog
        title: qsTr("Відкрити файл з автомобілями")
        nameFilters: [qsTr("Файли авто (*.dat *.txt)"), qsTr("Усі файли (*)")]
        onAccepted: showroom.loadFromFile(selectedFile)
    }

    FileDialog {
        id: saveDialog
        title: qsTr("Зберегти автомобілі у файл")
        fileMode: FileDialog.SaveFile
        defaultSuffix: "dat"
        nameFilters: [qsTr("Файли авто (*.dat)"), qsTr("Усі файли (*)")]
        onAccepted: showroom.saveToFile(selectedFile)
    }

    MessageDialog {
        id: errorDialog
        title: qsTr("Помилка")
        buttons: MessageDialog.Ok
    }

    MessageDialog {
        id: deleteDialog
        title: qsTr("Видалення")
        text: qsTr("Видалити автомобіль %1?").arg(backGround.car ? backGround.car.name : "")
        buttons: MessageDialog.Yes | MessageDialog.No
        onButtonClicked: function(button, role) {
            if (button === MessageDialog.Yes && backGround.car)
                showroom.removeCar(backGround.car.carId)
        }
    }

    Dialog {
        id: editDialog
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: Math.min(760, backGround.width - 40)
        height: Math.min(640, backGround.height - 40)
        modal: true
        padding: 0
        closePolicy: Popup.CloseOnEscape
        title: carEditForm.isNew ? qsTr("Новий автомобіль") : qsTr("Редагування автомобіля")

        contentItem: CarEdit {
            id: carEditForm
            onSaved: function(id) {
                editDialog.close()
                backGround.selectCar(id)
            }
            onCancelled: editDialog.close()
            onConfigureRequested: function(id) { backGround.openConfigurator(id) }
        }
    }

    Dialog {
        id: configDialog
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: Math.min(900, backGround.width - 40)
        height: Math.min(660, backGround.height - 40)
        modal: true
        padding: 0
        closePolicy: Popup.CloseOnEscape
        title: qsTr("Конфігуратор: %1").arg(configurator.carName)

        contentItem: CarConfiguration {
            onApplyClicked: configurator.apply()
            onCancelClicked: configDialog.close()
        }
    }

    MessageDialog {
        id: aboutDialog
        title: qsTr("Про програму")
        text: qsTr("Car Showroom — облік автомобілів автосалону")
        informativeText: qsTr("Відкрити / Зберегти — робота з файлом (*.dat).\n"
                              + "Знайти — пошук за маркою або моделлю, ціною і станом.\n"
                              + "Сортувати — сортування методом Шелла (↑ / ↓ — напрямок).\n"
                              + "Додати / Редагувати — форма автомобіля (редагування також подвійним кліком по рядку).\n"
                              + "Конфігурувати — комплектація, колір і додаткові опції з розрахунком ціни.\n"
                              + "Видалити — видалення обраного автомобіля (також правою кнопкою миші по рядку).")
        buttons: MessageDialog.Ok
    }

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
                MenuItem { text: qsTr("Відкрити…"); onTriggered: openDialog.open() }
                MenuItem { text: qsTr("Зберегти як…"); onTriggered: saveDialog.open() }
                MenuSeparator {}
                MenuItem { text: qsTr("Вихід"); onTriggered: Qt.quit() }
            }
            Menu {
                title: qsTr("Автомобіль")
                MenuItem { text: qsTr("Додати…"); onTriggered: backGround.openAddForm() }
                MenuItem {
                    text: qsTr("Редагувати…")
                    enabled: backGround.car !== null
                    onTriggered: backGround.openEditForm()
                }
                MenuItem {
                    text: qsTr("Конфігурувати…")
                    enabled: backGround.car !== null
                    onTriggered: backGround.openConfigurator(backGround.car.carId)
                }
                MenuSeparator {}
                MenuItem {
                    text: qsTr("Видалити")
                    enabled: backGround.car !== null
                    onTriggered: deleteDialog.open()
                }
            }
            Menu {
                title: qsTr("Пошук")
                MenuItem { text: qsTr("Знайти"); onTriggered: backGround.doSearch() }
                MenuItem { text: qsTr("Скинути пошук"); onTriggered: backGround.resetSearch() }
                MenuSeparator {}
                MenuItem { text: qsTr("Сортувати за роком"); onTriggered: backGround.sortBy(0) }
                MenuItem { text: qsTr("Сортувати за ціною"); onTriggered: backGround.sortBy(1) }
                MenuItem { text: qsTr("Сортувати за пробігом"); onTriggered: backGround.sortBy(2) }
            }
            Menu {
                title: qsTr("Тест-драйв")
                MenuItem { text: qsTr("Параметри") }
            }
            Menu {
                title: qsTr("Довідка")
                MenuItem { text: qsTr("Про програму"); onTriggered: aboutDialog.open() }
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
                    onClicked: openDialog.open()
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Завантажити автомобілі з файлу")

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
                    onClicked: saveDialog.open()
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Зберегти всі автомобілі у файл")

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
                    onClicked: backGround.openAddForm()
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Додати новий автомобіль")

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
                    enabled: backGround.car !== null
                    onClicked: backGround.openEditForm()
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Змінити дані обраного автомобіля")

                    contentItem: Text {
                        text: changeBtn.text
                        font: changeBtn.font
                        color: changeBtn.enabled ? "#1a1a1a" : "#9a9a9a"
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
                    enabled: backGround.car !== null
                    onClicked: deleteDialog.open()
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Видалити обраний автомобіль")

                    contentItem: Text {
                        text: delBtn.text
                        font: delBtn.font
                        color: delBtn.enabled ? "#1a1a1a" : "#9a9a9a"
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
                    enabled: backGround.car !== null
                    onClicked: backGround.openConfigurator(backGround.car.carId)
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: qsTr("Вибрати комплектацію, колір і опції обраного автомобіля")

                    contentItem: Text {
                        text: configBtn.text
                        font: configBtn.font
                        color: configBtn.enabled ? "#1a1a1a" : "#9a9a9a"
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
                            placeholderText: "напр. BMW"
                            passwordCharacter: "●"
                            inputMask: ""
                            selectedTextColor: "#ffffff"
                            selectionColor: "#0000ff"
                            Layout.preferredHeight: 28
                            Layout.preferredWidth: 234
                            onAccepted: backGround.doSearch()
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
                                placeholderText: "напр. 15000"
                                inputMask: ""
                                validator: IntValidator { bottom: 0 }
                                Layout.preferredHeight: 28
                                Layout.preferredWidth: 114
                                onAccepted: backGround.doSearch()
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
                                placeholderText: "напр. 45500"
                                validator: IntValidator { bottom: 0 }
                                Layout.preferredHeight: 28
                                Layout.preferredWidth: 114
                                onAccepted: backGround.doSearch()
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
                            onClicked: backGround.doSearch()
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Показати лише автомобілі, що відповідають умовам")

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
                            onClicked: backGround.resetSearch()
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Очистити умови пошуку і показати всі автомобілі")

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
                                text: "Сортувати (методом Шелла) за"
                                font.pixelSize: 12
                            }

                            ComboBox {
                                id: sortCmb
                                Layout.preferredHeight: 28
                                Layout.preferredWidth: 130
                                font.pixelSize: 13
                                Layout.fillWidth: true

                                // Порядок відповідає sortBy у контролері: 0 — рік, 1 — ціна, 2 — пробіг
                                model: ["Роком виготовлення","Ціною","Пробігом"]

                                background: Rectangle {
                                    color: "#ffffff"
                                    border.color: "#c4c4c4"
                                    border.width: 1
                                    radius: 3
                                }
                            }
                        }

                        Button {
                            id: sortDirBtn
                            text: backGround.sortAsc ? "↑" : "↓"
                            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

                            font.pixelSize: 13
                            leftPadding: 8
                            rightPadding: 8
                            onClicked: {
                                backGround.sortAsc = !backGround.sortAsc
                                if (showroom.sortField >= 0)
                                    showroom.sortBy(showroom.sortField, backGround.sortAsc)
                            }
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: backGround.sortAsc ? qsTr("За зростанням") : qsTr("За спаданням")

                            contentItem: Text {
                                text: sortDirBtn.text
                                font: sortDirBtn.font
                                color: "#1a1a1a"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                implicitHeight: 28
                                implicitWidth: 28
                                radius: 3
                                border.color: "#c4c4c4"
                                color: sortDirBtn.down ? "#e2e2e2" : (sortDirBtn.hovered ? "#f2f2f2" : "#ffffff")
                            }
                        }

                        Button {
                            id: sortBtn
                            text: qsTr("Сортувати")
                            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

                            font.pixelSize: 13
                            leftPadding: 12
                            rightPadding: 12
                            onClicked: backGround.sortBy(sortCmb.currentIndex)
                            ToolTip.visible: hovered
                            ToolTip.delay: 600
                            ToolTip.text: qsTr("Відсортувати таблицю методом Шелла")

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

                        model: showroom.model
                        onCurrentIndexChanged: backGround.updateSelectedCar()

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
                            id: rowItem
                            required property int carId
                            required property string name
                            required property int year
                            required property int mileage
                            required property int price
                            required property string condition
                            required property string engine
                            required property double consumption
                            required property string trim
                            required property string carColor
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
                                    text: rowItem.name;
                                    leftPadding: 8;
                                    elide: Text.ElideRight
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 60;
                                    text: rowItem.year;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 160;
                                    text: rowItem.engine || "—";
                                    leftPadding: 8;
                                    elide: Text.ElideRight
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 110;
                                    text: rowItem.carColor || "—";
                                    leftPadding: 8;
                                    elide: Text.ElideRight
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 160;
                                    text: rowItem.trim || "—";
                                    leftPadding: 8;
                                    elide: Text.ElideRight
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 80;
                                    text: backGround.consumptionText(rowItem.consumption);
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 80;
                                    text: rowItem.price;
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    width: 80;
                                    text: backGround.conditionText(rowItem.condition);
                                    leftPadding: 8;
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                            }

                            color: carList.currentIndex === index ? "#cce4f7" : "white"
                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                onClicked: function(mouse) {
                                    carList.currentIndex = rowItem.index
                                    if (mouse.button === Qt.RightButton)
                                        rowMenu.popup()
                                }
                                onDoubleClicked: function(mouse) {
                                    if (mouse.button === Qt.LeftButton) {
                                        carList.currentIndex = rowItem.index
                                        backGround.openEditForm()
                                    }
                                }
                            }
                        }

                        // Контекстне меню рядка (правий клік)
                        Menu {
                            id: rowMenu
                            MenuItem { text: qsTr("Редагувати…"); onTriggered: backGround.openEditForm() }
                            MenuItem { text: qsTr("Конфігурувати…"); onTriggered: backGround.openConfigurator(backGround.car ? backGround.car.carId : -1) }
                            MenuItem { text: qsTr("Видалити"); onTriggered: deleteDialog.open() }
                            MenuSeparator {}
                            MenuItem { text: qsTr("Сортувати за роком"); onTriggered: backGround.sortBy(0) }
                            MenuItem { text: qsTr("Сортувати за ціною"); onTriggered: backGround.sortBy(1) }
                            MenuItem { text: qsTr("Сортувати за пробігом"); onTriggered: backGround.sortBy(2) }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: showroom.model.count === 0
                        text: showroom.searchActive ? qsTr("Нічого не знайдено") : qsTr("Немає автомобілів. Відкрийте файл (Файл → Відкрити…)")
                        color: "#8a8a8a"
                        font.pixelSize: 13
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
                            text: backGround.car ? backGround.car.name : ""; font.bold: true; font.pixelSize: 15
                        }

                        GridLayout {
                            id: carPropertiesGrid
                            width: 100
                            height: 100
                            columns: 2

                            Label { text: qsTr("Рік") }
                            Label { text: backGround.car ? backGround.car.year : "" }

                            Label { text: qsTr("Пробіг") }
                            Label { text: backGround.car ? backGround.car.mileage + " км" : "" }

                            Label { text: qsTr("Двигун") }
                            Label { text: backGround.car ? (backGround.car.engine || "—") : "" }

                            Label { text: qsTr("Колір") }
                            Label { text: backGround.car ? (backGround.car.carColor || "—") : "" }

                            Label { text: qsTr("Комплектація") }
                            Label { text: backGround.car ? (backGround.car.trim || "—") : "" }

                            Label { text: qsTr("Витрата") }
                            Label {
                                text: !backGround.car ? ""
                                      : backGround.car.consumption > 0 ? backGround.car.consumption.toFixed(1) + " л/100 км" : "—"
                            }

                            Label { text: qsTr("Стан") }
                            Label { text: backGround.car ? backGround.conditionText(backGround.car.condition) : "" }

                            Label { text: qsTr("Ціна") }
                            Label { text: backGround.car ? "$" + backGround.car.price : ""; font.bold: true }
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
                    text: qsTr("Знайдено: %1 з %2").arg(showroom.model.count).arg(showroom.totalCount)
                    font.pixelSize: 12
                    Layout.leftMargin: 10
                }
                Text {
                    id: sortInfo
                    text: showroom.sortField < 0
                          ? qsTr("Без сортування")
                          : qsTr("Відсортовано за %1 %2 (метод Шелла)")
                                .arg([qsTr("роком"), qsTr("ціною"), qsTr("пробігом")][showroom.sortField])
                                .arg(showroom.sortAscending ? "↑" : "↓")
                    font.pixelSize: 12
                }
                Text {
                    id: fileInfo
                    text: qsTr("Файл: %1").arg(showroom.currentFile || "—")
                    font.pixelSize: 12
                    elide: Text.ElideMiddle
                    Layout.fillWidth: true
                }
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
