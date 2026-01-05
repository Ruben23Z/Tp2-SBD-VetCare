package dao;

import model.Paciente.NoArvore;
import model.Paciente.Paciente;
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
        String sql = "INSERT INTO Paciente (nome, dataNascimento, NIF, raca, pesoAtual, sexo, foto, dataObito, transponder) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNome());
            ps.setDate(2, java.sql.Date.valueOf(p.getDataNascimento()));
            ps.setString(3, p.getNifDono());
            ps.setString(4, p.getRaca());
            ps.setDouble(5, p.getPesoAtual());
            ps.setString(6, String.valueOf(p.getSexo()));
            ps.setString(7, p.getFoto());

            if (p.getDataObito() != null) {
                ps.setDate(8, java.sql.Date.valueOf(p.getDataObito()));
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }
            if (p.getTransponder() != null) {
                ps.setString(9, p.getTransponder());
            } else {
                ps.setNull(9, java.sql.Types.VARCHAR);
            }

            ps.executeUpdate();
        }
    }

    // ATUALIZAR
    public void atualizar(Paciente p) throws SQLException {
        String sql = "UPDATE Paciente SET nome=?, dataNascimento=?, NIF=?, raca=?, pesoAtual=?, sexo=?, foto=?, dataObito=?, transponder=? WHERE iDPaciente=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNome());
            ps.setDate(2, java.sql.Date.valueOf(p.getDataNascimento()));
            ps.setString(3, p.getNifDono());
            ps.setString(4, p.getRaca());
            ps.setDouble(5, p.getPesoAtual());
            ps.setString(6, String.valueOf(p.getSexo()));
            ps.setString(7, p.getFoto());

            if (p.getDataObito() != null) {
                ps.setDate(8, java.sql.Date.valueOf(p.getDataObito()));
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }
            if (p.getTransponder() != null) {
                ps.setString(9, p.getTransponder());
            } else {
                ps.setNull(9, java.sql.Types.VARCHAR);
            }

            ps.setInt(10, p.getidPaciente());

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

    public List<Paciente> listarPorNif(String nif) {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT * FROM Paciente WHERE NIF = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nif);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapResultSetToPaciente(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    private Paciente mapResultSetToPaciente(ResultSet rs) throws SQLException {
        Paciente p = new Paciente();
        p.setiDPaciente(rs.getInt("iDPaciente"));
        p.setNome(rs.getString("nome"));

        if (rs.getDate("dataNascimento") != null) {
            p.setDataNascimento(rs.getDate("dataNascimento").toLocalDate());
        }

        try {
            if (rs.getDate("dataObito") != null) {
                p.setDataObito(rs.getDate("dataObito").toLocalDate());
            }
        } catch (SQLException e) {
        }

        p.setNifDono(rs.getString("NIF"));
        p.setRaca(rs.getString("raca"));
        p.setPesoAtual(rs.getDouble("pesoAtual"));

        String sexoStr = rs.getString("sexo");
        if (sexoStr != null && !sexoStr.isEmpty()) p.setSexo(sexoStr.charAt(0));

        p.setFoto(rs.getString("foto"));
        try {
            p.setTransponder(rs.getString("transponder"));
        } catch (SQLException e) {
        }

        return p;
    }

    public NoArvore getArvoreCompleta(int idPaciente) {
        Paciente p = findById(idPaciente);
        if (p == null) return null;
        // O animal principal é a raiz da árvore
        NoArvore noPrincipal = new NoArvore(p, "Paciente");
        // Carrega os pais recursivamente
        carregarAncestrais(noPrincipal, idPaciente, 0);
        return noPrincipal;
    }

    // MÉTODO PRIVADO (RECURSIVO): Procura pais, avós, etc.
    private void carregarAncestrais(NoArvore noFilho, int idFilho, int nivel) {
        // Limite de segurança para não bloquear o servidor (5 gerações)
        if (nivel > 5) return;
        String sql = "SELECT p.*, pp.tipoProgenitor " + "FROM Paciente p " + "JOIN Paciente_Paciente pp ON p.iDPaciente = pp.iDPaciente_Progenitor " + "WHERE pp.iDPaciente_Filho = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFilho);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Mapear o Pai/Mãe
                Paciente pai = mapResultSetToPaciente(rs);
                String tipo = rs.getString("tipoProgenitor");

                NoArvore noPai = new NoArvore(pai, tipo != null ? tipo.toUpperCase() : "PROGENITOR");
                noFilho.adicionarProgenitor(noPai);

                carregarAncestrais(noPai, pai.getidPaciente(), nivel + 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}