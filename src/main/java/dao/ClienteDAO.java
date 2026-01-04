package dao;

import model.Utilizador.Cliente;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    // Inserir todos os campos (completo)
    public void inserir(Cliente c, int idUtilizador) {
        String sql = """
                    INSERT INTO Cliente (iDUtilizador, NIF, nome, email, telefone, rua, pais, distrito, concelho, freguesia)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUtilizador);
            ps.setString(2, c.getNIF());
            ps.setString(3, c.getNome());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getTelefone());
            ps.setString(6, c.getRua());
            ps.setString(7, c.getPais());
            ps.setString(8, c.getDistrito());
            ps.setString(9, c.getConcelho());
            ps.setString(10, c.getFreguesia());

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public void update(Cliente c) throws SQLException {
        String sql = "UPDATE Cliente SET NIF=?, nome=?, email=?, telefone=?, rua=?, pais=?, distrito=?, concelho=?, freguesia=? WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getNIF());
            ps.setString(2, c.getNome());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getTelefone());
            ps.setString(5, c.getRua());
            ps.setString(6, c.getPais());
            ps.setString(7, c.getDistrito());
            ps.setString(8, c.getConcelho());
            ps.setString(9, c.getFreguesia());
            ps.setInt(10, c.getiDUtilizador());
            ps.executeUpdate();
        }



    }

    public Cliente findById(int iDUtilizador) throws SQLException {
        String sql = "SELECT * FROM Cliente WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, iDUtilizador);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Cliente(rs.getInt("iDUtilizador"), rs.getString("NIF"), rs.getString("nome"), rs.getString("email"), rs.getString("telefone"), rs.getString("rua"), rs.getString("pais"), rs.getString("distrito"), rs.getString("concelho"), rs.getString("freguesia"));
            }
        }
        return null;
    }

    public Cliente findByNif(int nif) throws SQLException {
        String sql = "SELECT * FROM Cliente WHERE NIF=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nif);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Cliente(rs.getInt("iDUtilizador"), rs.getString("NIF"), rs.getString("nome"), rs.getString("email"), rs.getString("telefone"), rs.getString("rua"), rs.getString("pais"), rs.getString("distrito"), rs.getString("concelho"), rs.getString("freguesia"));
            }
        }
        return null;
    }

    // Método para obter o NIF através do ID de Login
    public String getNifByIdUtilizador(int idUtilizador) {
        String nif = null;
        String sql = "SELECT NIF FROM Cliente WHERE iDUtilizador = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                nif = rs.getString("NIF");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nif;
    }

    public void delete(int iDUtilizador) throws SQLException {
        String sql = "DELETE FROM Cliente WHERE iDUtilizador=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, iDUtilizador);
            ps.executeUpdate();
        }
    }

    public List<Cliente> findAll() throws SQLException {
        List<Cliente> list = new ArrayList<>();
        String sql = "SELECT * FROM Cliente";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                list.add(new Cliente(rs.getInt("iDUtilizador"), rs.getString("NIF"), rs.getString("nome"), rs.getString("email"), rs.getString("telefone"), rs.getString("rua"), rs.getString("pais"), rs.getString("distrito"), rs.getString("concelho"), rs.getString("freguesia")));
            }
        }
        return list;
    }
    public List<Cliente> listarTodos() {
        List<Cliente> list = new ArrayList<>();
        String sql = "SELECT * FROM Cliente";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Cliente c = new Cliente();
                c.setiDUtilizador(rs.getInt("iDUtilizador"));
                c.setNIF(rs.getString("NIF"));
                c.setNome(rs.getString("nome"));
                c.setEmail(rs.getString("email"));
                c.setTelefone(rs.getString("telefone"));
                c.setRua(rs.getString("rua"));
                c.setPais(rs.getString("pais"));
                c.setDistrito(rs.getString("distrito"));
                c.setConcelho(rs.getString("concelho"));
                c.setFreguesia(rs.getString("freguesia"));
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Criar Cliente com Login (Transação)
    public void criarClienteCompleto(Cliente c, String username, String password) throws SQLException {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psCli = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Início Transação

            // 1. Criar Utilizador
            String sqlUser = "INSERT INTO Utilizador (username, password, isVeterinario, isRececionista, isCliente, isGerente) VALUES (?, ?, 0, 0, 1, 0)";
            psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, username);
            psUser.setString(2, password);
            psUser.executeUpdate();

            rs = psUser.getGeneratedKeys();
            int idGerado = 0;
            if (rs.next()) idGerado = rs.getInt(1);
            else throw new SQLException("Falha ao criar utilizador.");

            // 2. Criar Cliente
            String sqlCli = "INSERT INTO Cliente (iDUtilizador, NIF, nome, email, telefone, rua, pais, distrito, concelho, freguesia) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            psCli = conn.prepareStatement(sqlCli);
            psCli.setInt(1, idGerado);
            psCli.setString(2, c.getNIF());
            psCli.setString(3, c.getNome());
            psCli.setString(4, c.getEmail());
            psCli.setString(5, c.getTelefone());
            psCli.setString(6, c.getRua());
            psCli.setString(7, (c.getPais()!=null ? c.getPais() : "Portugal"));
            psCli.setString(8, c.getDistrito());
            psCli.setString(9, c.getConcelho());
            psCli.setString(10, c.getFreguesia());
            psCli.executeUpdate();

            // 3. Inserir na tabela Particular (assumindo que todos são particulares por padrão)
            PreparedStatement psPart = conn.prepareStatement("INSERT INTO Particular (NIF, prefLinguistica) VALUES (?, 'PT')");
            psPart.setString(1, c.getNIF());
            psPart.executeUpdate();
            psPart.close();

            conn.commit(); // Fim Transação

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (psUser != null) psUser.close();
            if (psCli != null) psCli.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}
