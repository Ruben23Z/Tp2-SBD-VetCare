package dao;

import model.Paciente;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PacienteDAO {

    /* =========================
       INSERT
       ========================= */
    public void inserir(Paciente a, String nifCliente, String raca) throws SQLException {

        String sql = """
                    INSERT INTO Paciente (iDPaciente, nome, dataNascimento, NIF, raca)
                    VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, a.getidPaciente());
            ps.setString(2, a.getNome());
            ps.setDate(3, Date.valueOf(a.getDataNascimento()));
            ps.setString(4, nifCliente);
            ps.setString(5, raca);

            ps.executeUpdate();
        }
    }

    public void insert(Paciente p) {
        // Garantir que a query corresponde às colunas da BD
        String sql = "INSERT INTO Paciente (iDPaciente, nome, dataNascimento, NIF, raca, pesoAtual, sexo, foto) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            // Gerar ID manual (caso não seja auto-increment)
            int proximoId = 1;
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT MAX(iDPaciente) FROM Paciente");
            if (rs.next()) {
                proximoId = rs.getInt(1) + 1;
            }

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, proximoId);
            ps.setString(2, p.getNome());
            // Conversão LocalDate -> SQL Date
            ps.setDate(3, Date.valueOf(p.getDataNascimento()));
            ps.setString(4, p.getNifDono());
            ps.setString(5, p.getRaca());
            ps.setDouble(6, p.getPesoAtual());
            // Conversão char -> String
            ps.setString(7, String.valueOf(p.getSexo()));
            ps.setString(8, p.getFoto());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void atualizar(Paciente p) {
        String sql = "UPDATE Paciente SET nome=?, dataNascimento=?, NIF=?, raca=?, pesoAtual=?, sexo=?, foto=? WHERE iDPaciente=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNome());
            ps.setDate(2, Date.valueOf(p.getDataNascimento()));
            ps.setString(3, p.getNifDono());
            ps.setString(4, p.getRaca());
            ps.setDouble(5, p.getPesoAtual());
            ps.setString(6, String.valueOf(p.getSexo()));
            ps.setString(7, p.getFoto());
            ps.setInt(8, p.getidPaciente());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int idPaciente) throws SQLException {

        String sql = "DELETE FROM Paciente WHERE iDPaciente = ?";

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, idPaciente);
            ps.executeUpdate();
        }
    }

    /* =========================
       FIND BY ID
       ========================= */
    public Paciente findById(int idPaciente) {
        String sql = "SELECT * FROM Paciente WHERE iDPaciente = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, idPaciente);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapearPaciente(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /* =========================
       FIND BY TUTOR (NIF)
       ========================= */
    public List<Paciente> findByTutor(String nif) {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT * FROM Paciente WHERE NIF = ? ORDER BY nome";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, nif);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(mapearPaciente(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // LISTAR TODOS (Para a tabela de gestão)
    public List<Paciente> listarTodos() {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT * FROM Paciente ORDER BY nome";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Paciente p = mapearPaciente(rs);
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    //Método auxiliar para criar o objeto usando o construtor grande da classe Paciente
    private Paciente mapearPaciente(ResultSet rs) throws SQLException {
        // Tratar sexo (BD pode devolver String, Modelo quer char)
        String sexoStr = rs.getString("sexo");
        char sexoChar = (sexoStr != null && !sexoStr.isEmpty()) ? sexoStr.charAt(0) : ' ';

        return new Paciente(rs.getInt("iDPaciente"), rs.getString("nome"), rs.getDate("dataNascimento").toLocalDate(), // SQL Date -> LocalDate
                rs.getDouble("pesoAtual"), sexoChar, rs.getString("raca"), rs.getString("foto"), rs.getString("NIF"));
    }
}
