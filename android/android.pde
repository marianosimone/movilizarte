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

void setup() {
  size(768, 1024); 
  background(0);
  widgetContainer = new APWidgetContainer(this); //create new container for widgets
  textField = new APEditText(20, 20, 200, 70); //create a textfield from x- and y-pos., width and height
  button = new APButton(230, 20, "Connect");
  widgetContainer.addWidget(textField);
  widgetContainer.addWidget(button);
  message = "Waiting to connect...";
  textSize(32);
}

void draw() {
  fill(0);
  rect(0, 0, width, height);
  fill(255);
  text(message, 10, 150, width-20, height-150);  // Text wraps within text box
}

Socket connect(final String address) throws UnknownHostException, IOException {
  InetAddress serverAddr = InetAddress.getByName(address);
  return new Socket(serverAddr, 5204);
}

void mousePressed() {
  if (server != null) {
    try {
      server.getOutputStream().write("1,100,2\n".getBytes());
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
    } else {
      message = "Couldn't disconnect from server: " + exception.getMessage();
    }
  }
}
