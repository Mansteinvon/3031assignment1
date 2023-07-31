package Handler;

import java.io.*;
import java.net.*;

import java.util.*;

import org.neo4j.driver.v1.Driver;

import com.sun.net.httpserver.*;


public abstract class Handler implements HttpHandler{
	protected HttpHandler next;
	protected Driver driver;
	
	public Handler(HttpHandler next) {
		this.next=next;
	}

	
	
	
	
	
	protected void sendString(HttpExchange request, String data, int restCode) 
			throws IOException {
		request.sendResponseHeaders(restCode, data.length());
        OutputStream os = request.getResponseBody();
        os.write(data.getBytes());
        os.close();
	}






	@Override
	public abstract  void handle(HttpExchange request) throws IOException; 
	
	public abstract void handleRequest(HttpExchange request) ;
	
	
	
	
	
	
	
	
	
	
	

}
