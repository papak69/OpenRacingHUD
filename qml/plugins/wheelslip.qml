import QtQuick 2.12

import "../lib"

import QtQuick.Window 2.12

Window {
    flags:  Qt.FramelessWindowHint | Qt.WA_TranslucentBackground |  Qt.WindowStaysOnTopHint
    property int desktopHeight : 2160; // todo use desktop
    property double scaleMultiplier : desktopHeight / 2160;
    property int circleRadius           : 150 * scaleMultiplier;
    property int pluginWidth  : circleRadius * 3;
    property int pluginHeight : circleRadius * 3.5;
    id: window

    visible: true
    width:  pluginWidth
    height: pluginHeight
    color: "#00000000"


    Component.onCompleted: {
        console.log('WheelSlip loaded' )
    }

    // draggable window
    MouseArea {
            anchors.fill: parent
            property point lastMousePos: Qt.point(0, 0)
            onPressed: { lastMousePos = Qt.point(mouseX, mouseY); }
            onMouseXChanged: window.x += (mouseX - lastMousePos.x)
            onMouseYChanged: window.y += (mouseY - lastMousePos.y)
    }

    Telemetry {
        objectName:  "telemetry"
        id: telemetry
    }

    function onUpdate() {
        rearLeft.color = getHueForWheelSlip(telemetry.wheelSlip[2]);
        rearRight.color = getHueForWheelSlip(telemetry.wheelSlip[3]);
        frontLeft.color = getHueForWheelSlip(telemetry.wheelSlip[0]);
        frontRight.color = getHueForWheelSlip(telemetry.wheelSlip[1]);

        rearLeftText.text = telemetry.wheelSlip[2];
        rearRightText.text = telemetry.wheelSlip[3];
        frontLeftText.text = telemetry.wheelSlip[0];
        frontRightText.text = telemetry.wheelSlip[1];

        //console.log('onUpdate() : wheelSlip: ' + telemetry.wheelSlip);
       }

	function scaleLogarithmically(percent : int)
	{
		var multiplier = 10.0;
		var scaled = 100 * (Math.log(1 + (percent * multiplier)) / Math.log(1 + (100 * multiplier)));
		console.log('scaled', percent, ' to ', scaled);
		return scaled;
	}

    function getHueForWheelSlip(percent : int)
    {
        
        var green            = 120.0;
        var color_multiplier = green / 100;

        // TODO This should be enabled for F1 Games
        // quickly gets yellow, red at about 10%
        // percent = scaleLogarithmically(percent)		

        var hue = green - (color_multiplier * percent);
        return Qt.hsva(hue/360, 1, 1, 0.5);
    }

    Rectangle {
         id : frontLeft
         //width: parent.width<parent.height?parent.width:parent.height
         width: circleRadius
         height: circleRadius
         color: Qt.hsva(120/360, 1, 1, 0.5);
         border.color: "black"
         border.width: 1
         opacity: 0.5
         radius: circleRadius // changes rectangle to circle
         Text {
              id : frontLeftText
              color: "black"
              text: "0"
              anchors.centerIn: parent  // text in the middle of the circle
              font.pixelSize: 50*scaleMultiplier
         }
    }
    Rectangle {
         id : frontRight
         width: circleRadius
         height: circleRadius
         x: 2 * circleRadius
         radius: circleRadius
         color: Qt.hsva(120/360, 1, 1, 0.5);
         border.color: "black"
         border.width: 1
         opacity: 0.5
         Text {
             id : frontRightText
              color: "black"
              text: "0"
              anchors.centerIn: parent
              font.pixelSize: circleRadius/3
         }
    }
    Rectangle {
        id : rearLeft
         width: circleRadius
         height: circleRadius
         y: 2.5 * circleRadius
         color: Qt.hsva(120/360, 1, 1, 0.5);
         border.color: "black"
         border.width: 1
         opacity: 0.5
         radius: circleRadius
         Text {
              id : rearLeftText
              color: "black"
              text: "0"
              anchors.centerIn: parent
              font.pixelSize: circleRadius/3
         }
    }

    Rectangle {
         id : rearRight
         width: circleRadius
         height: circleRadius
         x: 2 * circleRadius
         y: 2.5 * circleRadius
         color: Qt.hsva(120/360, 1, 1, 0.5);
         border.color: "black"
         border.width: 1
         opacity: 0.5
         radius: circleRadius
         Text {
              id : rearRightText
              color: "black"
              text: "0"
              anchors.centerIn: parent
              font.pixelSize: circleRadius/3
         }
    }

}
