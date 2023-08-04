package ca.yorku.eecs;

import java.util.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.neo4j.driver.v1.*;
import org.neo4j.driver.v1.Record;

public class Neo4j {
	private Driver driver;
	private final String username="neo4j";
	private final String password="12345678";
	private final String URI ="bolt://localhost:7687";
	
	
	
	
	
	
	
	public Neo4j() {
		Config config = Config.builder().withoutEncryption().build();
		this.driver=GraphDatabase.driver(URI, AuthTokens.basic(username,password), config);
	}
	
	
	public boolean addActor(String name,String Id) {
		
		
	        String create = "CREATE (n:Actor {name:$name, actorId: $id})";

	        if(hasActor(Id))
	        	return false;
		
	        
	        
	        try(Session newsession=driver.session()){
	        	 Value param = Values.parameters("name", name, "id", Id);
		            newsession.writeTransaction(tx -> tx.run(create, param));
		            newsession.close();
		            System.out.println("we create actor");
		        	
		            return true;
	        }
	        
		}

		
	
	
	public boolean addMovie(String name,String movieId,String rating) {
		
		
		
		

		
	        String create = "CREATE (a:Movie {name: $name, movieId: $id, rating: $rate})";

	        
	        if(hasMovie(movieId))
	        	return false;

		
		
		
		
		try(Session newone=driver.session()){
		
	            // Node with the given ID does not exist, create a new node
	            Value param = Values.parameters("name", name, "id", movieId, "rate", rating);
	            
	        
	            newone.writeTransaction(tx -> tx.run(create, param));
	            newone.close();
	            System.out.println("we create movies");
	        	
	            return true;
		}
		
		
		
		
	
		
		
		
		
	}
	
	
	public boolean addRelationship(String actorid,String movieid) {
		//System.out.println("At least");
		
		System.out.println(movieid+actorid);
		
		Value params = Values.parameters("id1",actorid,"id2",movieid);
		
		String create="MATCH (a: Actor), (m: Movie) WHERE a.actorId = $id1 AND m.movieId = $id2 CREATE (a)-[r:ACTED_IN]->(m)";
		
		
		boolean exist=exist(actorid,movieid);
				
				
			//System.out.println(exist);
				
				if(!exist) {
					
					try(Session ses = driver.session()){
					System.out.println("I am here");
					ses.writeTransaction(tn -> tn.run(create,params));
					ses.close();
					
					
					
				}
				}
				
				
				return !exist;
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		
		
		
	}
	
	
	public boolean exist(String actorid,String movieid){
		String search=String.format("RETURN EXISTS( (:Actor {actorId: \"%s\"})-[:ACTED_IN]-(:Movie {movieId: \"%s\"}) ) as bool",actorid,movieid);
		
		try (Session session = driver.session()) {
			try(Transaction tx = session.beginTransaction()){
				
				StatementResult result=tx.run(search);
				boolean exist=result.next().get(0).asBoolean();
				return exist;
				
			}
		}
				
	
	
	}
	
	public JSONObject RetrieveActor(String actorId) {
		String querry="MATCH (n:Actor) WHERE n.actorId = $id RETURN n.name";
		
		
		
		Value params = Values.parameters("id", actorId);
		
		try(Session ses=driver.session()){
			StatementResult node = ses.writeTransaction(tx -> tx.run(querry, params));
			
			
			String name=node.next().get(0).asString();
			
			
			JSONArray movies = new JSONArray(findMovie(actorId));
			
		
			JSONObject obj = new JSONObject();
			
			try {
				obj.put("name",name);
				obj.put("actorId",actorId);
				obj.put("movies",movies);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return obj;
		}
		
		
		
		
		
	}
	
	
	
	
	
		
		
	public List<String> findMovie(String actorId){
		
		String search="MATCH (:Actor {actorId: $id})-[:ACTED_IN]->(m:Movie)return m.movieId";
		Value params = Values.parameters("id", actorId);
		List<String>list = new ArrayList<>();
		try(Session ses = driver.session()){
			StatementResult result=ses.writeTransaction(tx -> tx.run(search,params));
			Record record;
			while(result.hasNext()) {
				record=result.next();
				list.add(record.get(0).asString());
			}
			
			/*
			Record[]records=(Record[]) result.stream().toArray();
			for(int i=0;i<records.length;i++)
				System.out.println(records[i]);
			//System.out.println(list);
			 * 
			 */
			//JSONArray arr = new JSONArray(list);
		
		
		return list;
		
	}
		
	}
		
	
	
	public List<String> findActor(String movieId) {
		
		

		String search="MATCH (a:Actor)-[:ACTED_IN]->(m:Movie{movieId: $id})return a.actorId";
		Value params = Values.parameters("id", movieId);
		List<String>list = new ArrayList<>();
		try(Session ses = driver.session()){
			StatementResult result=ses.writeTransaction(tx -> tx.run(search,params));
			Record record;
			while(result.hasNext()) {
				record=result.next();
				list.add(record.get(0).asString());
			}
			
			/*
			Record[]records=(Record[]) result.stream().toArray();
			for(int i=0;i<records.length;i++)
				System.out.println(records[i]);
			//System.out.println(list);
			 * 
			 * 
			 */
			//JSONArray arr = new JSONArray(list);
		
		     return list;
		//return list.toString();
		
	}
		
	}
	
	
	public JSONObject RetrieveMovie(String movieId){
String querry="MATCH (n:Movie) WHERE n.movieId = $id RETURN n.name";
		
		
		
		Value params = Values.parameters("id", movieId);
		
		try(Session ses=driver.session()){
			StatementResult node = ses.writeTransaction(tx -> tx.run(querry, params));
			
			
			String name=node.next().get(0).asString();
			Map<String,String> map = new HashMap<>();
			List<String> movie= new ArrayList<>();
			JSONArray movies = new JSONArray(findActor(movieId));
			
			
			JSONObject obj = new JSONObject(map);
			
			try {
				obj.put("name",name);
				obj.put("movieId",movieId);
				obj.put("actors",movies);
			} catch (JSONException e) {
				
				e.printStackTrace();
			}
			
			
			return obj;
		}
		
		
		
		
		
		
	}
	
	
	
	public boolean hasActor(String actorId) {
		String query = "MATCH (n:Actor) WHERE n.actorId = $id RETURN n";
		
		
		 Value params = Values.parameters("id", actorId);
		try (Session session = driver.session()) {
			
			StatementResult node_boolean = session.writeTransaction(tx -> tx.run(query, params));
			
			return node_boolean.hasNext();
		}
		
		
		
		
	}
	
	public boolean hasMovie(String movieId) {
		 String query = "MATCH (n:Movie) WHERE n.movieId = $id RETURN n";
		 Value params = Values.parameters("id", movieId);
			try (Session session = driver.session()) {
				
				StatementResult node_boolean = session.writeTransaction(tx -> tx.run(query, params));
				
				return node_boolean.hasNext();
			}
			
		
		
		
		
		
	}
	
	public JSONObject getRelationship(String actor, String movie) {
		String actedIn = String.valueOf(exist(actor, movie));
		Map<String, String> relationship = new HashMap<>();
		relationship.put("actorId", actor);
		relationship.put("movieId", movie);
		relationship.put("hasRelationship", actedIn);
		return new JSONObject(relationship);
	}

	public List<String> getArrayParam(String id) {
		if(hasMovie(id))
			return findActor(id);
		else
			return findMovie(id);
	}
	
	public List<String> computeBaconPath(String actor)	{
		HashSet<String> visited = new HashSet<>();
		LinkedList<String> queue = new LinkedList<>();
		HashMap<String, String> parentNodes = new HashMap<>();
		queue.addLast(actor);
		boolean foundBacon = false;
		
		while(!queue.isEmpty() && !foundBacon) {
			String node = queue.removeFirst();
			if(!visited.contains(node)) {
				visited.add(node);
				List<String> connectedNodes = getArrayParam(node);
				for(String s : connectedNodes) {
					queue.addLast(s);
					parentNodes.put(s, node);
					if(s.equals("nm0000102"))
						foundBacon = true;
				}
			}
		}
		
		if(foundBacon) {
			LinkedList<String> path = new LinkedList<>();
			path.addFirst("nm0000102");
			while(!path.getFirst().equals(actor))
				path.addFirst(parentNodes.get(path.getFirst()));
			return path;
		}
		else
			return null;
	}
	
	public int computeBaconNumber(String actor) {
		return computeBaconPath(actor).size() / 2;
	}
}

	
