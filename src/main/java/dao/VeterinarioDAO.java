package dao;

import model.Utilizador.Veterinario;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VeterinarioDAO {

    public void inserir(Veterinario v, int idUtilizador) {
        String sql = """
                    INSERT INTO Veterinario
                    (iDUtilizador, nLicenca, nome, idade, especialidade)
                    VALUES (?, ?, ?, ?, ?)
                """;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUtilizador);
            ps.setString(2, v.getnLicenca());
            ps.setString(3, v.getNome());
            ps.setInt(4, v.getIdade());
            ps.setString(5, v.getEspecialidade());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // Atualizar veterinário
    public boolean atualizar(Veterinario vet) {
        String sql = "UPDATE Veterinario SET nLicenca = ?, nome = ?, idade = ?, especialidade = ? WHERE iDUtilizador = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vet.getnLicenca());
            ps.setString(2, vet.getNome());
            ps.setInt(3, vet.getIdade());
            ps.setString(4, vet.getEspecialidade());
            ps.setInt(5, vet.getiDUtilizador());
            int linhas = ps.executeUpdate();
            return linhas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public List<Veterinario> listarTodos() {
        List<Veterinario> lista = new ArrayList<>();
        // Query segura
        String sql = "SELECT v.*, u.username FROM Veterinario v JOIN Utilizador u ON v.iDUtilizador = u.iDUtilizador";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Veterinario vet = new Veterinario();
                vet.setiDUtilizador(rs.getInt("iDUtilizador"));
                vet.setnLicenca(rs.getString("nLicenca"));
                vet.setNome(rs.getString("nome"));
                vet.setIdade(rs.getInt("idade"));
                vet.setEspecialidade(rs.getString("especialidade"));
                // Se tiveres campo username no modelo Veterinario:
                // vet.setUsername(rs.getString("username"));
                lista.add(vet);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ver a exceção na consola
        }
        return lista;
    }

    // Buscar por Licença (para edição)
    public Veterinario buscarPorLicenca(String licenca) {
        String sql = "SELECT * FROM Veterinario WHERE nLicenca = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, licenca);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Veterinario v = new Veterinario();
                v.setnLicenca(rs.getString("nLicenca"));
                v.setNome(rs.getString("nome"));
                v.setIdade(rs.getInt("idade"));
                v.setEspecialidade(rs.getString("especialidade"));
                v.setiDUtilizador(rs.getInt("iDUtilizador"));
                return v;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
    // 4.1 CRIAR VETERINÁRIO (Transação: Utilizador + Veterinario)
    public void criarVeterinarioCompleto(Veterinario v, String username, String password) throws SQLException {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psVet = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Iniciar transação

            // 1. Inserir Utilizador
            String sqlUser = "INSERT INTO Utilizador (username, password, isVeterinario, isRececionista, isCliente, isGerente) VALUES (?, ?, 1, 0, 0, 0)";
            psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, username);
            psUser.setString(2, password);
            psUser.executeUpdate();

            rs = psUser.getGeneratedKeys();
            int idGerado = 0;
            if (rs.next()) {
                idGerado = rs.getInt(1);
            } else {
                throw new SQLException("Falha ao criar utilizador para o veterinário.");
            }

            // 2. Inserir Veterinario
            String sqlVet = "INSERT INTO Veterinario (nLicenca, nome, idade, especialidade, iDUtilizador) VALUES (?, ?, ?, ?, ?)";
            psVet = conn.prepareStatement(sqlVet);
            psVet.setString(1, v.getnLicenca());
            psVet.setString(2, v.getNome());
            psVet.setInt(3, v.getIdade());
            psVet.setString(4, v.getEspecialidade());
            psVet.setInt(5, idGerado);
            psVet.executeUpdate();

            conn.commit(); // Confirmar tudo

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (psUser != null) psUser.close();
            if (psVet != null) psVet.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // 4.1 ATUALIZAR VETERINÁRIO
    public void atualizarVeterinario(Veterinario v) throws SQLException {
        String sql = "UPDATE Veterinario SET nome=?, idade=?, especialidade=? WHERE nLicenca=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getNome());
            ps.setInt(2, v.getIdade());
            ps.setString(3, v.getEspecialidade());
            ps.setString(4, v.getnLicenca());
            ps.executeUpdate();
        }
    }
}
