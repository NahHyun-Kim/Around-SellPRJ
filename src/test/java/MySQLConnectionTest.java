package test.java;

import java.sql.Connection;
import java.sql.DriverManager;

public class MySQLConnectionTest {

    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/hanumoka_spring_template?useSSL=false";
    private static final String USER = "root";
    private static final String PW = "epdlxjqnstjrrhk";


    public void testConnection() throws Exception{

        Class.forName(DRIVER);

        try(Connection con = DriverManager.getConnection(URL, USER, PW)){
            System.out.println(con);
        }catch(Exception e) {
            e.printStackTrace();
        }//try_
    }//testConnection_

}
