package dao;

import model.Utilizador.Cliente;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    // Inserir todos os campos (completo)
    public void inserir(Cliente c, int idUtilizador) {
        String sql = """
                    INSERT INTO Cliente (iDUtilizador, NIF, nome, email, telefone, rua, pais, distrito, concelho, freguesia)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUtilizador);
            ps.setString(2, c.getNIF());
            ps.setString(3, c.getNome());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getTelefone());
            ps.setString(6, c.getRua());
            ps.setString(7, c.getPais());
            ps.setString(8, c.getDistrito());
            ps.setString(9, c.getConcelho());
            ps.setString(10, c.getFreguesia());

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public void update(Cliente c) throws SQLException {
        String sql = "UPDATE Cliente SET NIF=?, nome=?, email=?, telefone=?, rua=?, pais=?, distrito=?, concelho=?, freguesia=? WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getNIF());
            ps.setString(2, c.getNome());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getTelefone());
            ps.setString(5, c.getRua());
            ps.setString(6, c.getPais());
            ps.setString(7, c.getDistrito());
            ps.setString(8, c.getConcelho());
            ps.setString(9, c.getFreguesia());
            ps.setInt(10, c.getiDUtilizador());
            ps.executeUpdate();
        }
    }

    public Cliente findById(int iDUtilizador) throws SQLException {
        String sql = "SELECT * FROM Cliente WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, iDUtilizador);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Cliente(rs.getInt("iDUtilizador"), rs.getString("NIF"), rs.getString("nome"), rs.getString("email"), rs.getString("telefone"), rs.getString("rua"), rs.getString("pais"), rs.getString("distrito"), rs.getString("concelho"), rs.getString("freguesia"));
            }
        }
        return null;
    }

    public Cliente findByNif(int nif) throws SQLException {
        String sql = "SELECT * FROM Cliente WHERE NIF=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nif);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Cliente(rs.getInt("iDUtilizador"), rs.getString("NIF"), rs.getString("nome"), rs.getString("email"), rs.getString("telefone"), rs.getString("rua"), rs.getString("pais"), rs.getString("distrito"), rs.getString("concelho"), rs.getString("freguesia"));
            }
        }
        return null;
    }

    // Método para obter o NIF através do ID de Login
    public String getNifByIdUtilizador(int idUtilizador) {
        String nif = null;
        String sql = "SELECT NIF FROM Cliente WHERE iDUtilizador = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                nif = rs.getString("NIF");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nif;
    }

    public void delete(int iDUtilizador) throws SQLException {
        String sql = "DELETE FROM Cliente WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, iDUtilizador);
            ps.executeUpdate();
        }
    }

    public List<Cliente> findAll() throws SQLException {
        List<Cliente> list = new ArrayList<>();
        String sql = "SELECT * FROM Cliente";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                list.add(new Cliente(rs.getInt("iDUtilizador"), rs.getString("NIF"), rs.getString("nome"), rs.getString("email"), rs.getString("telefone"), rs.getString("rua"), rs.getString("pais"), rs.getString("distrito"), rs.getString("concelho"), rs.getString("freguesia")));
            }
        }
        return list;
    }
}
