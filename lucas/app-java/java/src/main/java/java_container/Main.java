import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Main {
    public static void main(String[] args) {
        String jdbcUrl = "jdbc:mysql://ls-3692fdf38110da5d66a1151c2da89c229ef91767.c5g9jbippsk1.us-east-2.rds.amazonaws.com";
        String username = "dbmasteruser";
        String password = "-diJD6L+A75!>{.kG(50lfo{W-zXZESK";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection connection = DriverManager.getConnection(jdbcUrl, username, password);

            Statement statement = connection.createStatement();

            // Verificar quantas tabelas existem no banco de dados
            ResultSet resultSet = statement.executeQuery("SHOW TABLES");
            int tableCount = 0;
            while (resultSet.next()) {
                tableCount++;
            }
            resultSet.close();

            // Se não houver tabelas, criar uma nova tabela
            if (tableCount == 0) {
                String createTableSQL = "CREATE TABLE tabela_exemplo (id INT AUTO_INCREMENT PRIMARY KEY, nome VARCHAR(255), idade INT)";
                statement.executeUpdate(createTableSQL);
                System.out.println("Tabela criada!");
            } else {
                System.out.println("Número de tabelas existentes: " + tableCount);
            }

            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
