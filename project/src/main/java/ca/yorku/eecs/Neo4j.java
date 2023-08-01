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
	        String query = "MERGE (n:Actor {actorId: $id}) RETURN n";
	        String create = "CREATE (a:Actor {name: $name, actorId: $id})";

	        // Parameters for the Cypher query to check node existence
	        Value params = Values.parameters("id", Id);

	        // Execute the query to check node existence
	        StatementResult node_boolean = session.writeTransaction(tx -> tx.run(query, params));

	        if (node_boolean.hasNext()) {
	            // Node with the given ID already exists
	            return false;
	        } else {
	            // Node with the given ID does not exist, create a new node
	            Value param = Values.parameters("name", name, "id", Id);
	            session.writeTransaction(tx -> tx.run(create, param));
	            return true;
	        }

		}
	}
}
	
