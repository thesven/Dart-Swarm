library swarm;

import 'dart:html';
import 'dart:math';
import 'struct/swarm_point.dart';
import 'swarmers/leader.dart';
import 'swarmers/follower.dart';

class SwarmSystem {
  
  CanvasElement canvas;
  Leader swarmLeader;
  List<Follower> followers;
  
  double swarmAmount, leaderTime, leaderSpeed, leaderRotationSpeed, leaderRunTime, swarmTwitch, swarmSpeed, swarmRotationSpeed, swarmerRadius;
  num canvasWidth, canvasHeight;
  
  SwarmSystem(domCanvas){
    
    this.canvas = domCanvas;
    this.canvasWidth = this.canvas.width;
    this.canvasHeight = this.canvas.height;
    
    this.leaderTime = 0.0;
    
    this.swarmAmount = 2500.0;
    
    this.leaderRotationSpeed = 20.0;
    this.leaderSpeed = 10.0;
    this.leaderRunTime = 10.0;
    
    this.swarmerRadius = 2.0;
    this.swarmTwitch = 15.0;
    this.swarmRotationSpeed = 10.0;
    this.swarmSpeed = 20.0;
    
    this.init();
    
  }
  
  void init(){
    
    //create the leader
    swarmLeader = new Leader();
    swarmLeader.position.x = this.canvasWidth * 0.5;
    swarmLeader.position.y = this.canvasHeight * 0.5;
    swarmLeader.rotation = 0.0;
    swarmLeader.rotationSpeed = this.leaderRotationSpeed;
    swarmLeader.speed = this.leaderSpeed;
    swarmLeader.runTime = this.leaderRunTime;
    swarmLeader.goalPosition.x = 0.0;
    swarmLeader.goalPosition.y = 0.0;
    swarmLeader.goalAngle = 0.0;
    swarmLeader.drawColor = "#FF0000";
    swarmLeader.radius = this.swarmerRadius;
    
    //create the followers
    followers = [];
    
    num i = 0;
    num max = this.swarmAmount;
    for(i; i<max; i++){
      
      Follower newFollower = new Follower();
      newFollower.position.x = this.canvasWidth * 0.5;
      newFollower.position.y = this.canvasHeight * 0.5;
      newFollower.rotation = 0.0;
      newFollower.rotationSpeed = this.swarmRotationSpeed;
      newFollower.speed = this.swarmSpeed;
      newFollower.twitch = this.swarmTwitch;
      newFollower.goalPosition.x = 0.0;
      newFollower.goalPosition.y = 0.0;
      newFollower.goalAngle = 0.0;
      newFollower.drawColor = "#0000FF";
      newFollower.radius = this.swarmerRadius;
      this.followers.add(newFollower);
      
    }
    
    start();
    
  }
  
  void start(){
    requestRedraw();
  }
  
  void requestRedraw(){
    window.requestAnimationFrame(moveSwarm);
  }
  
  void moveSwarm(num _){
    
    if(this.leaderTime == 0){
      
      swarmLeader.goalPosition.x = new Random().nextDouble() * this.canvasWidth;
      swarmLeader.goalPosition.y = new Random().nextDouble() * this.canvasHeight;
      leaderTime = swarmLeader.runTime;
      
    }
    
    swarmLeader.goalAngle = atan2(swarmLeader.goalPosition.y - swarmLeader.position.y, swarmLeader.goalPosition.x - swarmLeader.position.x);
    swarmLeader.goalAngle = swarmLeader.goalAngle * 180 / PI;
    swarmLeader.goalAngle = this.angleFix(swarmLeader.goalAngle - swarmLeader.rotation);
    
    if(swarmLeader.goalAngle < 180){
      swarmLeader.rotation += swarmLeader.rotationSpeed;
    } else {
      swarmLeader.rotation -= swarmLeader.rotationSpeed;
    }
    
    swarmLeader.position.x += this.calcCos(swarmLeader.rotation) * swarmLeader.rotationSpeed;
    swarmLeader.position.y += this.calcSin(swarmLeader.rotation) * swarmLeader.rotationSpeed;
    
    this.leaderTime--;
    
    this.drawBackground(this.canvas.context2d);
    swarmLeader.drawSelf(this.canvas.context2d);
    
    num i = 0;
    num max = this.swarmAmount;
    for(i; i<max; i++){
      
      Follower follower = followers[i];
      follower.goalPosition.x = swarmLeader.position.x;
      follower.goalPosition.y = swarmLeader.position.y;
      
      follower.goalAngle = atan2(follower.goalPosition.y - follower.position.y, follower.goalPosition.x - follower.position.x);
      follower.goalAngle = follower.goalAngle * 180 / PI;
      follower.goalAngle = this.angleFix(follower.goalAngle - follower.rotation);
      
      if(follower.goalAngle < 180){
        follower.rotation += follower.rotationSpeed;
      } else {
        follower.rotation -= follower.rotationSpeed;
      }
      
      follower.rotation += (new Random().nextDouble() * follower.twitch) - (follower.twitch * 0.5);
      
      follower.position.x += this.calcCos(follower.rotation) * follower.rotationSpeed;
      follower.position.y += this.calcSin(follower.rotation) * follower.rotationSpeed;
      follower.drawSelf(this.canvas.context2d);
      
    }
    
    this.requestRedraw();
  }
  
  void drawBackground(CanvasRenderingContext2D context) {
    context.fillStyle = "white";
    context.rect(0, 0, this.canvasWidth, this.canvasHeight);
    context.fill();
  }
  
  double calcCos(angle){
    return cos(angle * PI/180);
  }
  
  double calcSin(angle){
    return sin(angle * PI/180);
  }
  
  double angleFix(num angle){
    
    if(angle > 360){
      angle = angle%360;
    }
    while(angle < 0){
      angle += 360;
    }
    return angle;
  }
  
}
