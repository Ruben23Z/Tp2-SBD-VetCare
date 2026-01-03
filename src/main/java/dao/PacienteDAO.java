package dao;

import model.Paciente;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PacienteDAO {

    // LISTAR TODOS
    public List<Paciente> listarTodos() {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT * FROM Paciente";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapResultSetToPaciente(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // BUSCAR POR ID
    public Paciente findById(int id) {
        String sql = "SELECT * FROM Paciente WHERE iDPaciente = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPaciente(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // INSERIR
    public void insert(Paciente p) throws SQLException {
        String sql = "INSERT INTO Paciente (nome, dataNascimento, NIF, raca, pesoAtual, sexo, foto, dataObito) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNome());
            ps.setDate(2, java.sql.Date.valueOf(p.getDataNascimento()));
            ps.setString(3, p.getNifDono());
            ps.setString(4, p.getRaca());
            ps.setDouble(5, p.getPesoAtual());
            ps.setString(6, String.valueOf(p.getSexo()));
            ps.setString(7, p.getFoto());

            // Parâmetro 8 (Data de Óbito)
            if (p.getDataObito() != null) {
                ps.setDate(8, java.sql.Date.valueOf(p.getDataObito()));
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }

            ps.executeUpdate();
        }
    }

    // ATUALIZAR
    public void atualizar(Paciente p) throws SQLException {
        String sql = "UPDATE Paciente SET nome=?, dataNascimento=?, NIF=?, raca=?, pesoAtual=?, sexo=?, foto=?, dataObito=? WHERE iDPaciente=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNome());
            ps.setDate(2, java.sql.Date.valueOf(p.getDataNascimento()));
            ps.setString(3, p.getNifDono());
            ps.setString(4, p.getRaca());
            ps.setDouble(5, p.getPesoAtual());
            ps.setString(6, String.valueOf(p.getSexo()));
            ps.setString(7, p.getFoto());

            // Parâmetro 8
            if (p.getDataObito() != null) {
                ps.setDate(8, java.sql.Date.valueOf(p.getDataObito()));
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }

            // Parâmetro 9 (ID para o WHERE)
            ps.setInt(9, p.getidPaciente());

            ps.executeUpdate();
        }
    }

    // ELIMINAR
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM Paciente WHERE iDPaciente = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // BUSCAR POR NOME DO TUTOR (Autocomplete)
    public List<Paciente> buscarPorNomeTutor(String termo) {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT p.* FROM Paciente p JOIN Cliente c ON p.NIF = c.NIF WHERE c.nome LIKE ? LIMIT 10";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + termo + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapResultSetToPaciente(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // OBTER PAIS (Árvore Genealógica)
    public List<Paciente> getPais(int idFilho) {
        List<Paciente> pais = new ArrayList<>();
        String sql = "SELECT p.*, pp.tipoProgenitor FROM Paciente p " + "JOIN Paciente_Paciente pp ON p.iDPaciente = pp.iDPaciente_Progenitor " + "WHERE pp.iDPaciente_Filho = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFilho);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Paciente p = mapResultSetToPaciente(rs);
                // Hack: Guardar tipo (Pai/Mãe) no campo observacoes ou raca temporariamente para a view
                p.setObservacoes(rs.getString("tipoProgenitor"));
                pais.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pais;
    }

    // Método auxiliar para mapear ResultSet
    private Paciente mapResultSetToPaciente(ResultSet rs) throws SQLException {
        Paciente p = new Paciente();
        p.setiDPaciente(rs.getInt("iDPaciente"));
        p.setNome(rs.getString("nome"));

        if (rs.getDate("dataNascimento") != null) {
            p.setDataNascimento(rs.getDate("dataNascimento").toLocalDate());
        }

        // Verifica se a coluna existe antes de ler (boa prática para evitar erros em selects parciais)
        try {
            if (rs.getDate("dataObito") != null) {
                p.setDataObito(rs.getDate("dataObito").toLocalDate());
            }
        } catch (SQLException e) {
            // Coluna não existe no ResultSet, ignora
        }

        p.setNifDono(rs.getString("NIF"));
        p.setRaca(rs.getString("raca"));
        p.setPesoAtual(rs.getDouble("pesoAtual"));

        String sexoStr = rs.getString("sexo");
        if (sexoStr != null && !sexoStr.isEmpty()) p.setSexo(sexoStr.charAt(0));

        p.setFoto(rs.getString("foto"));
        return p;
    }
}