package Handler;
import java.io.*;
import java.net.*;

import java.util.*;

import com.sun.net.httpserver.*;

public class getHandler extends Handler {
	
	public getHandler(HttpHandler next) {
		super(next);
	}

	

	
	
	
	
	
	
	@Override
	public void handleRequest(HttpExchange request) {
		
		
	}









	@Override
	public void handle(HttpExchange request) throws IOException {
		try {
            if (request.getRequestMethod().equals("GET")) {
            	
            	
            	
                handleRequest(request);
                System.out.println("get");
            } else if(this.next!=null)
            	next.handle(request);
            else
            	sendString(request,"not recognized requests",500);
            	
            
            
            
	 }
        catch (Exception e) {
        	e.printStackTrace();
        	sendString(request, "Server error\n", 500);
        }
		
	}
	
	
	
	

}
