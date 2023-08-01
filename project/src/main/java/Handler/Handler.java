package Handler;

import java.io.*;
import java.net.*;

import java.util.*;

import org.neo4j.driver.v1.Driver;

import com.sun.net.httpserver.*;

public class Handler implements HttpHandler {

	@Override
	public void handle(HttpExchange request) throws IOException {
		try {
			if (request.getRequestMethod().equals("GET")) {
				String path = obtainPathGet(request);
				handleGet(request, path);
			} else if (request.getRequestMethod().equals("PUT")) {
				String path = obtainPathPut(request);
				handlePut(request, path);
			} else {
				sendString(request, "Unimplemented method\n", 501);
			}

		} catch (Exception e) {
			e.printStackTrace();
			sendString(request, "Server error\n", 500);
		}
	}

	protected void sendString(HttpExchange request, String data, int restCode) throws IOException {
		request.sendResponseHeaders(restCode, data.length());
		OutputStream os = request.getResponseBody();
		os.write(data.getBytes());
		os.close();
	}

	public void handleGet(HttpExchange request, String path) throws IOException {
		
//		GetController obj = new GetController();
//		JSonOBJECT j = 
		
		if (path.equals("/api/v1/getActor")) {
//		    j = obj.getActor(request);
		} else if (path.equals("/api/v1/getMovie")) {
		    
		} else if (path.equals("/api/v1/hasRelationship")) {
		    
		} else if (path.equals("/api/v1/computeBaconNumber")) {
		    
		} else if (path.equals("/api/v1/computeBaconPath")) {
		    
		} else {
			sendString(request, "Endpoint not found\n", 404);
		}


	}

	public void handlePut(HttpExchange request, String path) throws IOException {
		
//		PutController obj = new PutController();
//		JSonOBJECT j = 
		
		if (path.equals("/api/v1/addActor")) {
//			j = obj.addActor(request);
		} else if (path.equals("/api/v1/addMovie")) {
	
		} else if (path.equals("/api/v1/addRelationship")) {
			
		} else {
			sendString(request, "Endpoint not found\n", 404);
		}
	}

	public String obtainPathPut(HttpExchange request) {
		// TODO: implement this method.
		
		return null;
	}

	public String obtainPathGet(HttpExchange request) {
		URI uri = request.getRequestURI();
		return uri.getPath();
	}

}
