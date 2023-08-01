package ca.yorku.eecs;

import java.io.IOException;
import java.net.InetSocketAddress;
import com.sun.net.httpserver.*;



public class App 
{
    static int PORT = 8080;
    public static void main(String[] args) throws IOException
    {
    	
        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", PORT), 0);
        HttpHandler init = new Handler();
        server.createContext("/api/v1/", init::handle);
        
        
        server.start();
        
        System.out.printf("Server started on port %d...\n", PORT);
    }
}
