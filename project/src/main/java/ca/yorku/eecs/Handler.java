package ca.yorku.eecs;

import java.io.*;
import java.net.*;

import java.util.*;

import org.neo4j.driver.v1.Driver;

import com.sun.net.httpserver.*;


import  org.json.*;


public  class Handler implements HttpHandler{
	
	private final String re1="/api/v1/addActor";
	private final String re2="/api/v1/addMovie";
	private final String re3="/api/v1/addRelationship";
	private final String re4="/api/v1/getActor";
	private final String re5="/api/v1/getMovie";
	private final String re6="/api/v1/hasRelationship";
	private final String re7="/api/v1/computeBaconNumber";
	private final String re8="/api/v1/computeBaconPath";
	private final String re9="/api/v1/getRating";
	
	
	
	

	
	
	
	
	
	private void sendString(HttpExchange request, String data, int restCode) throws IOException {
		request.sendResponseHeaders(restCode, data.length());
        OutputStream os = request.getResponseBody();
        os.write(data.getBytes());
        os.close();
	}






	@Override
	public void handle(HttpExchange request) throws IOException{
		try {
            if (request.getRequestMethod().equals("GET")) 
                handleGet(request);
               
             else if(request.getRequestMethod().equals("PUT"))
            	handlePut(request);
            /*else
            	sendString(request, "Unimplemented method\n", 501);
            	*/
        } catch (Exception e) {
        	e.printStackTrace();
        	sendString(request, "Server error\n", 500);
        }
		
		
		
		
		
	}
	
	
	
	public void handleGet(HttpExchange request)throws IOException {
		boolean result =false;
		Neo4j neo4j = new Neo4j();
		String path= request.getRequestURI().getPath();
		//System.out.println(path);
		//System.out.println((request.getRequestURI().getQuery()));
		 Map<String, String> map = Utils.splitQuery(request.getRequestURI().getQuery());
		
		 
		 if(path.equals(re4))
		 {
			 String id = map.get("actorId");
			 if(id==null)
				 result=false;
			 else if(!(neo4j.hasActor(id)))
				 result=notFound(request);
			 else
			 {
			     String res=neo4j.RetrieveActor(id).toString();
			     
			     result=succeed(request,res);
			 }
		 }
		 else if(path.equals(re5)) {
			 
			 
			 String id = map.get("movieId");
			 if(id==null)
				 result=false;
			 else if(!(neo4j.hasMovie(id)))
				 result=notFound(request);
			 else
			 {
			     String res=neo4j.RetrieveMovie(id).toString();
			     
			     result=succeed(request,res);
			 }
			 
		 }
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 if(!(result))
			 edgeCase(request,"formatted error");
		
		
		
		
	}
	
public void handlePut(HttpExchange request)throws IOException{
	
	boolean result = false;
	
	
	
	
	Neo4j neo4j=new Neo4j();
     
      String path = request.getRequestURI().getPath();
    
      
      try {
    	  JSONObject json = new JSONObject( Utils.getBody(request));
    	 
      if(path.equals(re1)) {
    	  if(neo4j.addActor(json.getString("name"),json.getString("actorId")))
        		result=succeed(request,"Actor added");
      
      }
      
      else if(path.equals(re2))
    	  
      {
    	  if(neo4j.addMovie(json.getString("name"),json.getString("movieId"),json.getString("rating")))
    		  result=succeed(request,"Movies added");
      
      }
      
      
      
      else if(path.equals(re3)) {
    	  if(!(neo4j.hasActor(json.getString("actorId"))&&neo4j.hasMovie(json.getString("movieId"))))
    		  result=notFound(request);
    	  
    	  
      else if(neo4j.addRelationship(json.getString("actorId"),json.getString("movieId")))
    		  result=succeed(request,"relationship added");
    	  //System.out.println("unimplemented");
     
      
      }
      
      
      
      else 
    	  sendString(request, "handle put\n", 501);
      
		
	}
      catch(JSONException e)
      {
    	  sendString(request,"cannot understand json",400);
    	  return;
      }
      
    
      if(!result)
           edgeCase(request,"edge cased, not added");
    	  
      }



public boolean succeed(HttpExchange request,String info)throws IOException{
	
		
		sendString(request,info,200);
		return true;
	
	 
}






public void edgeCase(HttpExchange request,String info)throws IOException {
	
		sendString(request,info,400);
	}
	
	
	public boolean notFound(HttpExchange request)throws IOException{
		sendString(request,"Not found what u look for",404);
		return true;
	}
	
	
	
	
	
	
	
	

	

}
