package ca.yorku.eecs;

import org.json.JSONObject;
import org.neo4j.driver.v1.*;

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
		
		try (Session session = driver.session()) {
	        String query = "Match (a:Actor) WHERE a.actorId = $id RETURN a";
	        String create = "CREATE (n:Actor {name:$name, actorId: $id})";

	        // Parameters for the Cypher query to check node existence
	        Value params = Values.parameters("id", Id);

	        // Execute the query to check node existence
	        StatementResult node_boolean = session.writeTransaction(tx -> tx.run(query, params));

	        if (node_boolean.hasNext()) {
	        	System.out.println("it is already here");
	        	session.close();
	        	
	            // Node with the given ID already exists
	            return false;
	        } 
		
	        
	        
	        try(Session newsession=driver.session()){
	        	 Value param = Values.parameters("name", name, "id", Id);
		            newsession.writeTransaction(tx -> tx.run(create, param));
		            newsession.close();
		            System.out.println("we create actor");
		        	
		            return true;
	        }
	        
		}

		}
	
	
	public boolean addMovie(String name,String movieId,String rating) {
		
		
		
		

		try (Session session = driver.session()) {
	        String query = "MATCH (n:Movie) WHERE n.movieId = $id RETURN n";
	        String create = "CREATE (a:Movie {name: $name, movieId: $id, rating: $rate})";

	        // Parameters for the Cypher query to check node existence
	        Value params = Values.parameters("id", movieId);

	        // Execute the query to check node existence
	        StatementResult node_boolean = session.writeTransaction(tx -> tx.run(query, params));

	        if (node_boolean.hasNext()) {
	            // Node with the given ID already exists
	        	System.out.println("it is already here");
	        	session.close();
	        	
	            return false;
	        } 

		
		
		
		
		try(Session newone=driver.session()){
		
	            // Node with the given ID does not exist, create a new node
	            Value param = Values.parameters("name", name, "id", movieId, "rate", rating);
	            
	        
	            newone.writeTransaction(tx -> tx.run(create, param));
	            newone.close();
	            System.out.println("we create movies");
	        	
	            return true;
		}
		
		
		
		
	
		
		
		
		
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
}

	
