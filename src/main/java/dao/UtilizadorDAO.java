package dao;

import model.Utilizador.Utilizador;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilizadorDAO {

    public int inserir(Utilizador u) throws SQLException {
        String sql = "INSERT INTO Utilizador (username, password, isVeterinario, isRececionista, isCliente, isGerente) " + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement pst = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pst.setString(1, u.getUsername());
            pst.setString(2, u.getPassword());
            pst.setBoolean(3, u.isVeterinario());
            pst.setBoolean(4, u.isRececionista());
            pst.setBoolean(5, u.isCliente());
            pst.setBoolean(6, u.isGerente());
            pst.executeUpdate();
            try (ResultSet rs = pst.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Erro ao gerar ID do utilizador");
                }
            }
        }
    }

    public Utilizador login(String username, String password) {
        Utilizador u = null;
        String sql = "SELECT * FROM Utilizador WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new Utilizador();
                u.setiDUtilizador(rs.getInt("iDUtilizador"));
                System.out.println("DEBUG LOGIN: Utilizador " + u.getUsername() + " tem ID: " + u.getiDUtilizador());
                u.setUsername(rs.getString("username"));
                u.setVeterinario(rs.getBoolean("isVeterinario"));
                u.setRececionista(rs.getBoolean("isRececionista"));
                u.setCliente(rs.getBoolean("isCliente"));
                u.setGerente(rs.getBoolean("isGerente"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM Utilizador WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void atualizar(Utilizador u) throws SQLException {
        String sql = "UPDATE Utilizador SET isVeterinario=?, isRececionista=?, isCliente=? WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, u.isVeterinario());
            ps.setBoolean(2, u.isRececionista());
            ps.setBoolean(3, u.isCliente());
            ps.setInt(4, u.getiDUtilizador());
            ps.executeUpdate();
        }
    }

    public Utilizador findByUsernameAndPassword(String username, String password) {
        Utilizador u = null;
        String sql = "SELECT * FROM Utilizador WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new Utilizador(); // Usa o construtor vazio que criámos
                u.setiDUtilizador(rs.getInt("iDUtilizador"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setVeterinario(rs.getBoolean("isVeterinario"));
                u.setRececionista(rs.getBoolean("isRececionista"));
                u.setCliente(rs.getBoolean("isCliente"));
                u.setGerente(rs.getBoolean("isGerente"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }
}
