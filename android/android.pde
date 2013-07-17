import java.net.Socket;
import java.net.InetAddress;

Socket server;
void setup() {
  size(768, 1024); 
  noStroke();
  rectMode(CENTER);
  background(0);
  colorMode(HSB);
}

void draw() {
  stroke(255);
  rect(0,10, 30, 30);
}

void connect() {
  try{
    InetAddress serverAddr = InetAddress.getByName("192.168.2.5");
    server = new Socket(serverAddr, 5204);
  } catch (Exception e){
    println(e);
    throw new RuntimeException(e);
  }
}
void mousePressed() {
  if (server == null) {
    connect();
  }
  try {
    server.getOutputStream().write("1,100,2\n".getBytes());
  } catch (Exception e) {
    println(e);
    throw new RuntimeException(e);
  }
}


