import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import QtMultimedia 5.9

import FileIO 1.0

Window {
    id: page
    visible: true
    width: categories.length * columnWidth + (categories.length - 1) * spacing
    height: titleHeight + 4 * (spacing + questionHeight)
    title: qsTr("Quiz master 3000")

    property int columnWidth: 200
    property int titleHeight: 150
    property int questionHeight: 100
    property int spacing: 10

    property var categories: [
        {
            title:"Category",
            q1: {
                q: "Question 1",
                qm: "",
                a: "",
                am: ""
            },
            q2: {
                q: "Question 2",
                qm: "",
                a: "",
                am: ""
            },
            q3: {
                q: "Question 3",
                qm: "",
                a: "",
                am: ""
            },
            q4: {
                q: "Question 4",
                qm: "",
                a: "",
                am: ""
            },
        }
    ]

    function loadJSONFile() {
        console.log("Loading questions from " + qFile.source)
        console.log("- folder: " + qFile.path)
        var text = qFile.read()
        console.log("loaded " + text.length)


        var jsonObject = JSON.parse(text)
        //console.log("my json: " + JSON.stringify(categories, undefined, 2))

        page.categories = jsonObject
    }

    Rectangle {
        anchors.fill: parent
        color: "black"

        Row {
            //anchors.fill: parent
            spacing: page.spacing

            Repeater {
                model: categories

                Column {
                    id: column
                    width: page.columnWidth
                    spacing: page.spacing
                    property var element: categories[model.index]

                    Rectangle {
                        width: parent.width
                        height: 150
                        color: "darkblue"

                        Text {
                            anchors.centerIn: parent
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: element.title
                            font.bold: true
                            color: "white"
                            width: parent.width - 10
                            font.pointSize: 16
                            wrapMode: Text.Wrap

                        }

                    }

                    Item {}

                    Question {
                        text: "1"
                        onActivated: {
                            popup.ask(element.q1)
                        }
                    }

                    Question {
                        text: "2"
                        onActivated: {
                            popup.ask(element.q2)
                        }
                    }

                    Question {
                        text: "3"
                        onActivated: {
                            popup.ask(element.q3)
                        }
                    }

                    Question {
                        text: "4"
                        onActivated: {
                            popup.ask(element.q4)
                        }
                    }
                }

            }
        }
    }

    FileIO {
        id: qFile
        source: ""
        onError: console.log(msg)
        onSourceChanged: {
            console.log("Source changed to " + source)
            loadJSONFile();
        }
    }

    FileDialog {
        id: openFile
        title: "Choose you questions file"

        onAccepted: {
            console.log("You choose: " + openFile.fileUrl)
            qFile.source = openFile.fileUrl.toString()
        }

        onRejected: {
            console.log("Canceled")
        }
    }

    Popup {
        id: popup
        width: parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent

        property variant question: ({})
        property bool showAnswer: false

        function ask(q) {
            popup.question = q
            popup.showAnswer = false
            player.play(q.qm)
            popup.open()
        }

        onClosed: {
            mediaplayer.stop()
        }

        Rectangle {
            anchors.fill: parent

            ColumnLayout {
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                anchors.fill: parent

                Item {}

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: popup.showAnswer ? popup.question.a : popup.question.q
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter

                    width: parent.width - 10
                    wrapMode: Text.Wrap
                }

                Item {
                    id: player

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    readonly property int noType: 0
                    readonly property int audioType: 1
                    readonly property int videoType: 2
                    readonly property int imageType: 3

                    property int currentType: noType

                    function getFileType(name) {
                        try {
                            var ext = name.toLowerCase().split(".").pop()
                            switch(ext) {
                            case "png":
                            case "jpg":
                            case "gif":
                                return imageType
                            case "wav":
                            case "mp3":
                                return audioType
                            case "avi":
                            case "mp4":
                                return videoType
                            default:
                                return noType
                            }
                        } catch(err) {
                            return noType
                        }
                    }

                    function play(media) {
                        console.log("play: " + media)

                        mediaplayer.stop()
                        image.visible = false
                        video.visible = false

                        currentType = getFileType(media)
                        switch(currentType) {
                        case noType:
                            return
                        case imageType:
                            image.source = qFile.path + "/" + media
                            image.visible = true
                            return
                        case videoType:
                            mediaplayer.source = qFile.path + "/" + media
                            video.visible = true
                            mediaplayer.play()
                            return
                        case audioType:
                            image.source = "qrc:///audio.png"
                            mediaplayer.source = qFile.path + "/" + media
                            image.visible = true
                            mediaplayer.play()

                        }
                    }

                    MediaPlayer {
                        id: mediaplayer
                        autoLoad: true
                        autoPlay: false
                        notifyInterval: 250

                        onError: {
                            console.log("E: " + errorString)
                        }

                        onSourceChanged: console.log("Source changed to: " + source)
                    }

                    VideoOutput {
                        id: video
                        autoOrientation: true
                        anchors.fill: parent
                        source: mediaplayer
                        visible: false
                    }

                    Image {
                        id: image
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        visible: false
                    }
                }

                ProgressBar {
                    id: mediaProgress
                    from: 0
                    to: mediaplayer.duration
                    value: mediaplayer.position
                    Layout.fillWidth: true
                    visible: player.currentType === player.audioType || player.currentType === player.videoType

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var relativePosition = mouseX/width
                            mediaplayer.seek(relativePosition * mediaplayer.duration)
                        }
                    }
                }

                RowLayout {
                    spacing: 5
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignBottom
                    Layout.fillWidth: true

                    Button {
                        text: popup.showAnswer ? "Question" : "Answer"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        onClicked: {
                            popup.showAnswer = !popup.showAnswer
                            if(popup.showAnswer) {
                                player.play(popup.question.am)
                            } else {
                                player.play(popup.question.qm)
                            }
                        }
                    }

                    Item { Layout.fillWidth: true}


                    Row {
                        enabled: mediaProgress.visible
                        spacing: parent.spacing

                        Button {
                            text: "|<-"
                            onPressed: mediaplayer.seek(0)
                        }

                        Button {
                            text: mediaplayer.playbackState === MediaPlayer.PlayingState ? "||" : ">"
                            onPressed: mediaplayer.playbackState === MediaPlayer.PlayingState ? mediaplayer.pause() : mediaplayer.play()
                        }
                    }

                    Item { Layout.fillWidth: true}

                    Button {
                        text: "Close"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        enabled: popup.showAnswer
                        onClicked: {
                            popup.close()
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("On completed")
        //qFile.source = "file:///C:/Users/es016672/Projects/intern/aw-quiz/aw-quiz.json"
        //qFile.source = "file:///home/oscar/projects/quiz/aw-quiz/aw-quiz.json"
        openFile.visible = true

    }
}
