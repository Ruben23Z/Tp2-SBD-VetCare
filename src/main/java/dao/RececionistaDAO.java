package dao;

import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RececionistaDAO {
    public void create(int idUtilizador) throws SQLException {
            Connection c = DBConnection.getConnection();
            try {
                c.setAutoCommit(false);
                String sqlUser = """
                INSERT INTO  Utilizador (iDUtilziador, isRececionista)
                VALUES (?, true)
                """;

                try(PreparedStatement ps = c.prepareStatement(sqlUser)) {
                    ps.setInt(1, idUtilizador);
                    ps.executeUpdate();
                }

                String sqlRececionista = """
                INSERT INTO Rececionista(iDUtilziador)
                VALUES (?)
                """;

                try(PreparedStatement ps = c.prepareStatement(sqlRececionista)) {
                    ps.setInt(1, idUtilizador);
                    ps.executeUpdate();
                }
                c.commit();
            } catch (SQLException e) {
                c.rollback();
                throw e;
            } finally {
                c.close();
            }
        }
    }