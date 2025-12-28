package dao;

import model.Utilizador.Utilizador;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilizadorDAO {

    public void insert(Utilizador u) throws SQLException {
        String sql = "INSERT INTO Utilizador (iDUtilizador, isVeterinario, isRececionista, isCliente) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, u.getiDUtilizador());
            ps.setBoolean(2, u.isVeterinario());
            ps.setBoolean(3, u.isRececionista());
            ps.setBoolean(4, u.isCliente());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM Utilizador WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void update(Utilizador u) throws SQLException {
        String sql = "UPDATE Utilizador SET isVeterinario=?, isRececionista=?, isCliente=? WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, u.isVeterinario());
            ps.setBoolean(2, u.isRececionista());
            ps.setBoolean(3, u.isCliente());
            ps.setInt(4, u.getiDUtilizador());
            ps.executeUpdate();
        }
    }

    public Utilizador findById(int id) throws SQLException {
        String sql = "SELECT * FROM Utilizador WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Utilizador(
                        rs.getInt("iDUtilizador"),
                        rs.getBoolean("isVeterinario"),
                        rs.getBoolean("isRececionista"),
                        rs.getBoolean("isCliente")
                );
            }
        }
        return null;
    }

    public List<Utilizador> findAll() throws SQLException {
        List<Utilizador> list = new ArrayList<>();
        String sql = "SELECT * FROM Utilizador";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                list.add(new Utilizador(
                        rs.getInt("iDUtilizador"),
                        rs.getBoolean("isVeterinario"),
                        rs.getBoolean("isRececionista"),
                        rs.getBoolean("isCliente")
                ));
            }
        }
        return list;
    }
}
