package dao;

import model.Utilizador.Cliente;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    public void insert(Cliente c) throws SQLException {
        String sql1 = "INSERT INTO Utilizador (iDUtilizador, isCliente) VALUES (?, ?)";
        String sql2 = "INSERT INTO Cliente (iDUtilizador, NIF, nome, email, telefone, rua, pais, distrito, concelho, freguesia) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps1 = conn.prepareStatement(sql1);
             PreparedStatement ps2 = conn.prepareStatement(sql2)) {

            ps1.setInt(1, c.getiDUtilizador());
            ps1.setBoolean(2, true);
            ps1.executeUpdate();

            ps2.setInt(1, c.getiDUtilizador());
            ps2.setString(2, c.getNIF());
            ps2.setString(3, c.getNome());
            ps2.setString(4, c.getEmail());
            ps2.setString(5, c.getTelefone());
            ps2.setString(6, c.getRua());
            ps2.setString(7, c.getPais());
            ps2.setString(8, c.getDistrito());
            ps2.setString(9, c.getConcelho());
            ps2.setString(10, c.getFreguesia());
            ps2.executeUpdate();
        }
    }

    public Cliente findById(int iDUtilizador) throws SQLException {
        String sql = "SELECT * FROM Cliente WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, iDUtilizador);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Cliente(
                        rs.getInt("iDUtilizador"),
                        rs.getString("NIF"),
                        rs.getString("nome"),
                        rs.getString("email"),
                        rs.getString("telefone"),
                        rs.getString("rua"),
                        rs.getString("pais"),
                        rs.getString("distrito"),
                        rs.getString("concelho"),
                        rs.getString("freguesia")
                );
            }
        }
        return null;
    }

    public void update(Cliente c) throws SQLException {
        String sql = "UPDATE Cliente SET NIF=?, nome=?, email=?, telefone=?, rua=?, pais=?, distrito=?, concelho=?, freguesia=? WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public void delete(int iDUtilizador) throws SQLException {
        String sql = "DELETE FROM Cliente WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, iDUtilizador);
            ps.executeUpdate();
        }
    }

    public List<Cliente> findAll() throws SQLException {
        List<Cliente> list = new ArrayList<>();
        String sql = "SELECT * FROM Cliente";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                list.add(new Cliente(
                        rs.getInt("iDUtilizador"),
                        rs.getString("NIF"),
                        rs.getString("nome"),
                        rs.getString("email"),
                        rs.getString("telefone"),
                        rs.getString("rua"),
                        rs.getString("pais"),
                        rs.getString("distrito"),
                        rs.getString("concelho"),
                        rs.getString("freguesia")
                ));
            }
        }
        return list;
    }
}
