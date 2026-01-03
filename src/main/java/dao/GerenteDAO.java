package dao;

import utils.DBConnection;

import java.sql.*;

public class GerenteDAO {
    public void inserir(int idUtilizador) {

        String sql = "INSERT INTO Gerente (iDUtilizador) VALUES (?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet historicoServicos() throws SQLException {
        Connection c = DBConnection.getConnection();
        return c.prepareStatement("SELECT * FROM Historico_Servicos").executeQuery();
    }

    public ResultSet agendaClinica() throws SQLException {
        Connection c = DBConnection.getConnection();
        return c.prepareStatement("SELECT * FROM Agenda_Clinica").executeQuery();
    }

    public ResultSet avaliacoes() throws SQLException {
        Connection c = DBConnection.getConnection();
        return c.prepareStatement("SELECT * FROM Avaliacoes_Detalhadas").executeQuery();
    }

    public void atribuirGerente(int idUtilizador) throws SQLException {

        String sql = "INSERT INTO Gerente (iDUtilizador) VALUES (?)";

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
            ps.executeUpdate();
        }
    }

    public boolean isGerente(int idUtilizador) throws SQLException {

        String sql = "SELECT 1 FROM Gerente WHERE iDUtilizador = ?";

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }
}
