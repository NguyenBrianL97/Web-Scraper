package com.company;
import java.util.Scanner;
import java.sql.*;

public class Main {
    static class MysqlCon{
        public void readDatabase(int x, int y){
                constant obj = new constant();
                String password=obj.password;
                try{
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con=DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/trnds?useSSL=false","root",password);
                    Statement stmt=con.createStatement();
                    if (x==1) { //display_all
                        ResultSet rs = stmt.executeQuery("select * from team_id");
                        while (rs.next())
                            System.out.println(rs.getString(2) + "  " + rs.getString(1));
                        con.close();
                    }
                    if (x==2) { //RBI
                        ResultSet rs = stmt.executeQuery("select * from rbi_rank where id = "+y);
                        while (rs.next())
                            System.out.println(rs.getString(1)+ " has an RBI stat value of "+ rs.getString(3)+" ranking at "+rs.getString(4));
                        con.close();
                    }
                    if (x==3) { //ERA
                        ResultSet rs = stmt.executeQuery("select * from era_rank where id = "+y);
                        while (rs.next())
                            System.out.println(rs.getString(1)+ " has an ERA stat value of "+ rs.getString(3)+" ranking at "+rs.getString(4));
                        con.close();
                    }
                }catch(Exception e){ System.out.println(e);}
        }
    }

    public static void displayall() {
        MysqlCon connection = new MysqlCon();
        connection.readDatabase(1,0);
    }

    public static void searchrank() {
        int team_ID = 0;
        Scanner in = new Scanner(System.in);

        System.out.println("Please type in a team ID code \n");
        String stringTeam = in.nextLine();
        if (stringTeam.matches("-?\\d+")) {
            team_ID = Integer.parseInt(stringTeam);
        }
        else {
            System.out.println("Invalid input, please try again.\n");
            return;
        }
        System.out.println("Please type in a stat type \n 'RBI' - Runs Batted In \n 'ERA' - Earned Run Average\n");
        String input = in.nextLine();

        if (input.equals("RBI")) {
            MysqlCon connection = new MysqlCon();
            connection.readDatabase(2,team_ID);
        }
        else if (input.equals("ERA")) {
            MysqlCon connection = new MysqlCon();
            connection.readDatabase(3,team_ID);
        }
        else {
            System.out.println("Invalid input, please try again.");
        }
    }

    public static void main(String[] args) {
        while(true) {
            System.out.println("Please type in a command: \n 'display_all' - Display all MLB team names with " +
                    "respective ID code \n 'search_rank' - Display stat value and rank of stat type and selected " +
                    "team\n 'exit' - exit program\n");
            Scanner in = new Scanner(System.in);
            String s = in.nextLine();
            switch (s) {
                case "display_all":
                    displayall();
                    break;
                case "search_rank":
                    searchrank();
                    break;
                case "exit":
                    System.exit(1);
                default:
                    System.out.println("Invalid input, please try again.");
                    break;
            }
        }
    }
}
