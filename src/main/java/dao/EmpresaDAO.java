package dao;

import model.Utilizador.Empresa;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmpresaDAO {

    public void insert(Empresa e) throws SQLException {
        String sql = "INSERT INTO Empresa (NIF, capitalSocial) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getNIF());
            ps.setBigDecimal(2, e.getCapitalSocial());
            ps.executeUpdate();
        }
    }

    public void update(Empresa e) throws SQLException {
        String sql = "UPDATE Empresa SET capitalSocial=? WHERE NIF=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, e.getCapitalSocial());
            ps.setString(2, e.getNIF());
            ps.executeUpdate();
        }
    }

    public void delete(String NIF) throws SQLException {
        String sql = "DELETE FROM Empresa WHERE NIF=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, NIF);
            ps.executeUpdate();
        }
    }

    public Empresa findByNIF(String NIF) throws SQLException {
        String sql = "SELECT * FROM Empresa WHERE NIF=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, NIF);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Empresa e = new Empresa();
                e.setNIF(rs.getString("NIF"));
                e.setCapitalSocial(rs.getBigDecimal("capitalSocial"));
                return e;
            }
        }
        return null;
    }

    public List<Empresa> findAll() throws SQLException {
        List<Empresa> list = new ArrayList<>();
        String sql = "SELECT * FROM Empresa";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                Empresa e = new Empresa();
                e.setNIF(rs.getString("NIF"));
                e.setCapitalSocial(rs.getBigDecimal("capitalSocial"));
                list.add(e);
            }
        }
        return list;
    }
}
