package dao;

import model.Utilizador.Empresa;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class EmpresaDAO {

    public void inserir(Empresa e) throws Exception {

        String sql = "INSERT INTO Empresa (NIF, capitalSocial) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getNif());
            ps.setInt(2, e.getCapitalSocial());
            ps.executeUpdate();
        }
    }

    public void deleteByNif(String nif) throws Exception {
        String sql = "DELETE FROM Empresa WHERE NIF=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, nif);
            ps.executeUpdate();
        }
    }

}
