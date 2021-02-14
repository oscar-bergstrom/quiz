import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import QtMultimedia 5.9

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

    property url path: "file:///Users/es016672/Projects/intern/aw-quiz"

    property var categories: [
        {
            title:"Covers",
            q1: {
                q: "Vem gjorde orginalet?",
                qm: "covers/sns-shook.mp4",
                a: "ACDC",
                am: "covers/acdc-shook.mp4"
            },
            q2: {
                q: "Vem gjorde orginalet?",
                qm: "covers/hugo-99.mp4",
                a: "Jay Z",
                am: "covers/jay-99.mp4"
            },
            q3: {
                q: "Vem gjorde orginalet?",
                qm: "covers/cash-hurt.mp4",
                a: "Nine Inch Nails",
                am: "covers/nin-hurt.mp4"
            },
            q4: {
                q: "Vem gjorde orginalet?",
                qm: "covers/jules-mad.mp4",
                a: "Tears For Fears",
                am: "covers/tff-mad.mp4"
            },
        },
        {
            title:"Citat från filmer",
            q1: {
                q: "Från vilken film kommer ljudet?",
                qm: "movies/shining.wav",
                a: "The Shining",
                am: "movies/shining.mp4"
            },
            q2: {
                q: "Från vilken film kommer ljudet?",
                qm: "movies/toystory.wav",
                a: "Toy Story",
                am: "movies/toystory.mp4"
            },
            q3: {
                q: "Från vilken film kommer ljudet?",
                qm: "movies/bb.wav",
                a: "Blues Brothers",
                am: "movies/bb.mp4"
            },
            q4: {
                q: "Från vilken film kommer ljudet?",
                qm: "movies/future.wav",
                a: "Back to the future",
                am: "movies/future.mp4"
            },
        },
        {
            title:"Musikvideor",
            q1: {
                q: "Vad heter låten?",
                qm: "musicless/1_take_ml.mp4",
                a: "Aha - Take on me",
                am: "musicless/1_take.mp4"
            },
            q2: {
                q: "Vad heter låten?",
                qm: "musicless/2_dancing_ml.mp4",
                a: "Bowie & Jagger - Dancing in the streets",
                am: "musicless/2_dancing.mp4"
            },
            q3: {
                q: "Vad heter låten?",
                qm: "musicless/3_firestarter_ml.mp4",
                a: "The Prodigy - Firestarter",
                am: "musicless/3_firestarter.mp4"
            },
            q4: {
                q: "Vad heter låten?",
                qm: "musicless/4_chandelier_ml.mp4",
                a: "Sia - Chandelier",
                am: "musicless/4_chandelier.mp4"
            },
        },
        {
            title:"Gissa gruppen",
            q1: {
                q: "Vad heter gruppen?",
                qm: "groups/queen.jpg",
                a: "Queen",
                am: "groups/a_queen.jpg"
            },
            q2: {
                q: "Vad heter gruppen?",
                qm: "groups/spice_girls.jpg",
                a: "Spice Girls",
                am: "groups/a_spice_girls.jpg"
            },
            q3: {
                q: "Vad heter gruppen?",
                qm: "groups/arctic_monkeys.jpg",
                a: "Arctic Monkeys",
                am: "groups/a_arctic_monkeys.jpg"
            },
            q4: {
                q: "Vad heter gruppen?",
                qm: "groups/ratm.png",
                a: "Rage Against The Machine",
                am: "groups/a_ratm.jpg"
            },
        },
        {
            title:"Vilket land?",
            q1: {
                q: "Från vilket land kommer dessa artister?",
                qm: "countries/finland.mp4",
                a: "Finland",
                am: "countries/finland.jpg"
            },
            q2: {
                q: "Från vilket land kommer dessa artister?",
                qm: "countries/ireland.mp4",
                a: "Irland",
                am: "countries/ireland.jpg"
            },
            q3: {
                q: "Från vilket land kommer dessa artister?",
                qm: "countries/canada.mp4",
                a: "Kanada",
                am: "countries/canada.jpg"
            },
            q4: {
                q: "Från vilket land kommer dessa artister?",
                qm: "countries/france.mp4",
                a: "Frankrike",
                am: "countries/france.jpg"
            },
        },
    ]

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

                        switch(getFileType(media)) {
                        case noType:
                            return
                        case imageType:
                            image.source = path + "/" + media
                            image.visible = true
                            return
                        case videoType:
                            mediaplayer.source = path + "/" + media
                            video.visible = true
                            mediaplayer.play()
                            return
                        case audioType:
                            image.source = "qrc:///audio.png"
                            mediaplayer.source = path + "/" + media
                            image.visible = true
                            mediaplayer.play()

                        }
                    }

                    MediaPlayer {
                        id: mediaplayer
                        autoLoad: true
                        autoPlay: false

                        onError: {
                            console.log("E: " + errorString)
                        }
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
                        enabled: mediaplayer.hasAudio || mediaplayer.hasVideo
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

    }
}
