import QtQuick 2.0

Rectangle {
    id: question
    width: parent.width
    height: 100

    //color: isActivated ? "transparent" : "darkblue"
    color: "darkblue"

    property string text: ""
    property bool isActivated: false
    property color textColor: "#AAAA00"

    signal activated

    Text {
        anchors.centerIn: parent
        text: question.isActivated ? "" : question.text
        color: question.textColor
    }

    MouseArea {
        anchors.fill: question
        onClicked: {
            if(!question.isActivated) {
                question.isActivated = true
                question.activated()
            }
        }
    }
}
