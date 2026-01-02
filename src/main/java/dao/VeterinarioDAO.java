package dao;

import model.Utilizador.Veterinario;
import utils.DBConnection;
import model.Utilizador.Utilizador;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VeterinarioDAO {


    public void inserirMinimo(int id) throws SQLException {
        String sql = "INSERT INTO Veterinario (iDUtilizador, nLicenca) VALUES (?, CONCAT('LIC', ?))";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

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

    // Apagar veterinário
    public boolean apagar(int idUtilizador) {
        String sqlVet = "DELETE FROM Veterinario WHERE iDUtilizador = ?";
        String sqlUtil = "DELETE FROM Utilizador WHERE iDUtilizador = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement psVet = conn.prepareStatement(sqlVet); PreparedStatement psUtil = conn.prepareStatement(sqlUtil)) {

            conn.setAutoCommit(false);

            psVet.setInt(1, idUtilizador);
            psVet.executeUpdate();

            psUtil.setInt(1, idUtilizador);
            psUtil.executeUpdate();

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Buscar veterinário por ID
    public Veterinario buscarPorID(int idUtilizador) {
        String sql = "SELECT u.iDUtilizador, v.nLicenca, v.nome, v.idade, v.especialidade " + "FROM Veterinario v JOIN Utilizador u ON v.iDUtilizador = u.iDUtilizador " + "WHERE u.iDUtilizador = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Veterinario(rs.getInt("iDUtilizador"), rs.getString("nLicenca"), rs.getString("nome"), rs.getInt("idade"), rs.getString("especialidade"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Listar todos os veterinários
    public List<Veterinario> listarTodos() {
        List<Veterinario> lista = new ArrayList<>();

        // JOIN entre Veterinario e Utilizador para ter todos os dados
        String sql = "SELECT v.iDUtilizador, v.nLicenca, v.nome, v.idade, v.especialidade " +
                "FROM Veterinario v " +
                "JOIN Utilizador u ON v.iDUtilizador = u.iDUtilizador";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Cria o objeto Veterinario com os dados da BD
                // Nota: especialidade deve vir exatamente como está na BD ("Cirurgia", "Dermatologia")
                Veterinario vet = new Veterinario(
                        rs.getInt("iDUtilizador"),
                        rs.getString("nLicenca"),
                        rs.getString("nome"),
                        rs.getInt("idade"),
                        rs.getString("especialidade")
                );
                lista.add(vet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Método opcional para buscar por ID se precisares no futuro
    public Veterinario buscarPorId(int id) {
        String sql = "SELECT * FROM Veterinario WHERE iDUtilizador = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Veterinario(
                        rs.getInt("iDUtilizador"),
                        rs.getString("nLicenca"),
                        rs.getString("nome"),
                        rs.getInt("idade"),
                        rs.getString("especialidade")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
