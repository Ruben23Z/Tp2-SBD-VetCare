package dao;

import model.Servicos.Consulta;
import utils.DBConnection;

import java.sql.*;

public class ConsultaDAO {

    public void create(Consulta cns) throws SQLException {

        String sql = """
                    INSERT INTO Consulta
                    (idServico, diagnostico, sintomas, proxConsulta)
                    VALUES (?, ?, ?, ?)
                """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, cns.getIdServico());
            ps.setString(2, cns.getDiagnostico());
            ps.setString(3, cns.getSintomas());
            if (cns.getProxConsulta() != null) {
                ps.setTimestamp(
                        4,
                        Timestamp.valueOf(cns.getProxConsulta())
                );
            } else {
                ps.setTimestamp(4, null);
            }
            ps.executeUpdate();
        }
    }
}
