package Handler;
import java.io.*;
import java.net.*;

import java.util.*;

import com.sun.net.httpserver.*;
public class postHandler extends Handler {
	private final String database="bolt://localhost:7687";
	private final String username ="neo4j";
	private final String password = "12345678";
	public postHandler(HttpHandler next) {
		super(next);
	}

	
	
	
	
	
	
	
	
	









	@Override
	public void handleRequest(HttpExchange request) {
		
		
	}



















	@Override
	public void handle(HttpExchange request)throws IOException {
		try {
            if (request.getRequestMethod().equals("POST")) {
            	
            	
            	
                handleRequest(request);
                System.out.println("post");
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
