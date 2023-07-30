package Handler;

import java.io.*;
import java.net.*;

import java.util.*;

import com.sun.net.httpserver.*;


public class Handler implements HttpHandler{
	private HttpHandler next;
	
	public Handler(HttpHandler next) {
		this.next=next;
	}

	
	
	
	
	
	
	
	@Override
	public void handle(HttpExchange exchange) throws IOException {
		
		
	}

}
