package dao;

import model.Animal;
import utils.DBConnection;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class AnimalDAO {

    public void create(Animal a, String nifTutor, String raca) throws SQLException {

        String sql = """
            INSERT INTO Paciente
            (iDPaciente, nome, dataNascimento, NIF, raca)
            VALUES (?, ?, ?, ?, ?)
        """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, a.getiDPaciente());
            ps.setString(2, a.getNome());
            ps.setDate(3, Date.valueOf(a.getDataNascimento()));
            ps.setString(4, nifTutor);
            ps.setString(5, raca);

            ps.executeUpdate();
        }
    }

    public List<Animal> findByTutor(String nif) throws SQLException {
        List<Animal> lista = new ArrayList<>();

        String sql = """
            SELECT iDPaciente, nome, dataNascimento
            FROM Paciente
            WHERE NIF = ?
        """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, nif);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(new Animal(
                        rs.getInt("iDPaciente"),
                        rs.getString("nome"),
                        rs.getDate("dataNascimento").toLocalDate()
                ));
            }
        }
        return lista;
    }
}
