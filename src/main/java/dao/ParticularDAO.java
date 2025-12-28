package dao;

import model.Utilizador.Particular;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParticularDAO {

    public void insert(Particular p) throws SQLException {
        String sql = "INSERT INTO Particular (NIF, prefLinguistica) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNIF());
            ps.setString(2, p.getPrefLinguistica());
            ps.executeUpdate();
        }
    }

    public void update(Particular p) throws SQLException {
        String sql = "UPDATE Particular SET prefLinguistica=? WHERE NIF=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getPrefLinguistica());
            ps.setString(2, p.getNIF());
            ps.executeUpdate();
        }
    }

    public void delete(String NIF) throws SQLException {
        String sql = "DELETE FROM Particular WHERE NIF=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, NIF);
            ps.executeUpdate();
        }
    }

    public Particular findByNIF(String NIF) throws SQLException {
        String sql = "SELECT * FROM Particular WHERE NIF=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, NIF);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Particular p = new Particular();
                p.setNIF(rs.getString("NIF"));
                p.setPrefLinguistica(rs.getString("prefLinguistica"));
                return p;
            }
        }
        return null;
    }

    public List<Particular> findAll() throws SQLException {
        List<Particular> list = new ArrayList<>();
        String sql = "SELECT * FROM Particular";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Particular p = new Particular();
                p.setNIF(rs.getString("NIF"));
                p.setPrefLinguistica(rs.getString("prefLinguistica"));
                list.add(p);
            }
        }
        return list;
    }
}
