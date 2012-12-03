library swarm;

import '../struct/swarm_point.dart';
import 'dart:html';
import 'dart:math';

class BaseSwarmer {
  
  SwarmPoint position;
  SwarmPoint goalPosition;
  double rotation, rotationSpeed, twitch, speed, goalAngle, radius;
  String drawColor;
  
   BaseSwarmer(){
    position = new SwarmPoint(0.0,0.0);
    goalPosition = new SwarmPoint(0.0,0.0);
  }
  
  void drawSelf(CanvasRenderingContext2D context){
    
    context.beginPath();
    context.arc(position.x, position.y, this.radius, 0, PI * 2, false);
    context.lineWidth = 0.5;
    context.fillStyle = drawColor;
    context.fill();
    context.closePath();
    
  }
  
}
