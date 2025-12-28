package dao;

import model.Utilizador.Veterinario;
import utils.DBConnection;
import model.Utilizador.Utilizador;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VeterinarioDAO {

    // Inserir um veterinário
    public boolean inserir(Veterinario vet) {
        String sqlUtilizador = "INSERT INTO Utilizador (iDUtilizador, isVeterinario, isRececionista, isCliente) VALUES (?, ?, ?, ?)";
        String sqlVeterinario = "INSERT INTO Veterinario (iDUtilizador, nLicenca, nome, idade, especialidade) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psUtil = conn.prepareStatement(sqlUtilizador);
             PreparedStatement psVet = conn.prepareStatement(sqlVeterinario)) {

            conn.setAutoCommit(false); // transação

            // Inserir na tabela Utilizador
            psUtil.setInt(1, vet.getiDUtilizador());
            psUtil.setBoolean(2, true);
            psUtil.setBoolean(3, false);
            psUtil.setBoolean(4, false);
            psUtil.executeUpdate();

            // Inserir na tabela Veterinario
            psVet.setInt(1, vet.getiDUtilizador());
            psVet.setString(2, vet.getnLicenca());
            psVet.setString(3, vet.getNome());
            psVet.setInt(4, vet.getIdade());
            psVet.setString(5, vet.getEspecialidade());
            psVet.executeUpdate();

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Atualizar veterinário
    public boolean atualizar(Veterinario vet) {
        String sql = "UPDATE Veterinario SET nLicenca = ?, nome = ?, idade = ?, especialidade = ? WHERE iDUtilizador = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psVet = conn.prepareStatement(sqlVet);
             PreparedStatement psUtil = conn.prepareStatement(sqlUtil)) {

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
        String sql = "SELECT u.iDUtilizador, v.nLicenca, v.nome, v.idade, v.especialidade " +
                "FROM Veterinario v JOIN Utilizador u ON v.iDUtilizador = u.iDUtilizador " +
                "WHERE u.iDUtilizador = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
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

    // Listar todos os veterinários
    public List<Veterinario> listarTodos() {
        List<Veterinario> lista = new ArrayList<>();
        String sql = "SELECT u.iDUtilizador, v.nLicenca, v.nome, v.idade, v.especialidade " +
                "FROM Veterinario v JOIN Utilizador u ON v.iDUtilizador = u.iDUtilizador";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
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
}
