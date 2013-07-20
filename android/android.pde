import apwidgets.*;

import java.lang.Void;
import java.net.Socket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.io.IOException;
import android.os.AsyncTask;

Socket server;
APWidgetContainer widgetContainer; 
APEditText textField;
APButton button;
String message;
int margin;

void setup() {
  size(displayWidth, displayHeight); 
  margin = displayWidth/18;
  println(displayWidth);
  println(displayHeight);
  background(0);
  widgetContainer = new APWidgetContainer(this); //create new container for widgets
  textField = new APEditText(margin, margin, displayWidth/2, 2*margin); //create a textfield from x- and y-pos., width and height
  button = new APButton(displayWidth/2+2*margin, margin, "Connect");
  widgetContainer.addWidget(textField);
  widgetContainer.addWidget(button);
  message = "Waiting to connect...";
  textSize(margin);
}

void draw() {
  fill(0);
  rect(0, 0, width, height);
  fill(255);
  text(message, margin, margin*3, width-margin, height-margin);  // Text wraps within text box
}

Socket connect(final String address) throws UnknownHostException, IOException {
  InetAddress serverAddr = InetAddress.getByName(address);
  return new Socket(serverAddr, 5204);
}

void mouseDragged() {
  if (server != null) {
    try {
      server.getOutputStream().write((mouseX + "," + mouseY + ",2\n").getBytes());
    } catch (Exception e) {
      println(e);
      throw new RuntimeException(e);
    }
  }
}

//onClickWidget is called when a widget is clicked/touched
void onClickWidget(final APWidget widget){
  if (widget == button) {
    if (server == null) {
      message = "Trying to connect...";
      new ConnectToServerTask().execute(textField.getText());
    } else {
      new DisconnectTask().execute(server);
      server = null;
    }
  }
}

class ConnectToServerTask extends AsyncTask<String, Void, Socket> {
  private Exception exception;

  protected Socket doInBackground(String... address) {
    try {
      println("Going to connect to " + address[0]);
      return connect("192.168.2.5");
      //return connect(address[0]);
    } catch (Exception e) {
      e.printStackTrace();
      this.exception = e;
      return null;
    }
  }

  protected void onPostExecute(Socket socket) {
    if (socket != null) {
      server = socket;
      message = "Connected";
      button.setText("Disconnect");
    }
    if (exception != null) {
      message = "Couldn't connect to server: " + exception.getMessage();
    }
  }
}

class DisconnectTask extends AsyncTask<Socket, Void, Void> {
  private Exception exception;

  protected Void doInBackground(Socket... socket) {
    try {
      message = "Disconnecting";
      socket[0].close();
    } catch (Exception e) {
      this.exception = e;
      e.printStackTrace();
    }
    return null;
  }

  protected void onPostExecute(Void v) {
    if (exception == null) {
      message = "Waiting to connect...";
      button.setText("Connect");
    } else {
      message = "Couldn't disconnect from server: " + exception.getMessage();
    }
  }
}
