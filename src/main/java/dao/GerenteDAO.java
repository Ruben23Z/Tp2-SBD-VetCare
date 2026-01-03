package dao;

import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GerenteDAO {
    public void inserir(int idUtilizador) {

        String sql = "INSERT INTO Gerente (iDUtilizador) VALUES (?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet historicoServicos() throws SQLException {
        Connection c = DBConnection.getConnection();
        return c.prepareStatement("SELECT * FROM Historico_Servicos").executeQuery();
    }

    public ResultSet agendaClinica() throws SQLException {
        Connection c = DBConnection.getConnection();
        return c.prepareStatement("SELECT * FROM Agenda_Clinica").executeQuery();
    }

    public ResultSet avaliacoes() throws SQLException {
        Connection c = DBConnection.getConnection();
        return c.prepareStatement("SELECT * FROM Avaliacoes_Detalhadas").executeQuery();
    }

    public void atribuirGerente(int idUtilizador) throws SQLException {

        String sql = "INSERT INTO Gerente (iDUtilizador) VALUES (?)";

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
            ps.executeUpdate();
        }
    }

    public boolean isGerente(int idUtilizador) throws SQLException {

        String sql = "SELECT 1 FROM Gerente WHERE iDUtilizador = ?";

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, idUtilizador);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    // --- 4.2 ATRIBUIR HORÁRIO COM VALIDAÇÃO ---
    public boolean atribuirHorario(String nLicenca, String localidade, String diaUtil) throws SQLException {
        Connection conn = DBConnection.getConnection();

        // 1. Validar se é fim de semana (SAB/DOM não permitido)
        if ("SAB".equalsIgnoreCase(diaUtil) || "DOM".equalsIgnoreCase(diaUtil)) {
            return false;
        }

        // 2. Obter horário da clínica para esse dia
        String sqlClinica = "SELECT horaAbertura, horaFecho FROM Horario WHERE localidade = ? AND diaUtil = ?";
        Time inicio1 = null, fim1 = null;

        try (PreparedStatement ps = conn.prepareStatement(sqlClinica)) {
            ps.setString(1, localidade);
            ps.setString(2, diaUtil);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                inicio1 = rs.getTime("horaAbertura");
                fim1 = rs.getTime("horaFecho");
            } else {
                return false; // Clínica fechada neste dia
            }
        }

        // 3. Verificar sobreposição (Se o médico já trabalha noutro sítio à mesma hora)
        String sqlCheckVet = "SELECT h.horaAbertura, h.horaFecho " + "FROM Horario_Veterinario hv " + "JOIN Horario h ON hv.localidade = h.localidade AND hv.diaUtil = h.diaUtil " + "WHERE hv.nLicenca = ? AND hv.diaUtil = ?";

        try (PreparedStatement ps = conn.prepareStatement(sqlCheckVet)) {
            ps.setString(1, nLicenca);
            ps.setString(2, diaUtil);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Time inicio2 = rs.getTime("horaAbertura");
                Time fim2 = rs.getTime("horaFecho");

                // Lógica de colisão de horários
                if (inicio1.before(fim2) && fim1.after(inicio2)) {
                    return false; // Sobreposição encontrada!
                }
            }
        }

        // 4. Inserir se tudo estiver livre
        String sqlInsert = "INSERT INTO Horario_Veterinario (nLicenca, localidade, diaUtil) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
            ps.setString(1, nLicenca);
            ps.setString(2, localidade);
            ps.setString(3, diaUtil);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            return false; // Provavelmente chave duplicada
        }
    }

    // --- 4.5 ANIMAIS > EXPECTATIVA DE VIDA ---
    public List<Map<String, Object>> getAnimaisExcederamExpectativa() {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT p.nome, p.idade, r.raca, e.expectVida, (p.idade - e.expectVida) as diferenca " + "FROM Paciente p " + "JOIN Raca r ON p.raca = r.raca " + "JOIN Especie e ON r.nomeCientifico = e.nomeCientifico " + "WHERE p.idade > e.expectVida " + "ORDER BY p.idade DESC";

        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("nome", rs.getString("nome"));
                row.put("idade", rs.getInt("idade"));
                row.put("raca", rs.getString("raca"));
                row.put("expectVida", rs.getDouble("expectVida"));
                row.put("diferenca", rs.getDouble("diferenca"));
                lista.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // --- 4.6 TUTORES COM ANIMAIS OBESOS ---
    public List<Map<String, Object>> getTutoresAnimaisExcessoPeso() {
        List<Map<String, Object>> lista = new ArrayList<>();
        // Regra simples: Peso Atual > Peso Adulto Médio da Raça
        String sql = "SELECT c.nome, COUNT(p.iDPaciente) as qtd " + "FROM Cliente c " + "JOIN Paciente p ON c.NIF = p.NIF " + "JOIN Raca r ON p.raca = r.raca " + "WHERE p.pesoAtual > r.pesoAdulto " + "GROUP BY c.nome " + "ORDER BY c.nome ASC";

        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("nomeTutor", rs.getString("nome"));
                row.put("qtdAnimais", rs.getInt("qtd"));
                lista.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // --- 4.7 TUTORES COM MAIS CANCELAMENTOS (TRIMESTRE) ---
    public List<Map<String, Object>> getTopCancelamentosTrimestre() {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT c.nome, COUNT(s.iDServico) as totalCancelados " + "FROM Cliente c " + "JOIN Paciente p ON c.NIF = p.NIF " + "JOIN ServicoMedicoAgendamento s ON p.iDPaciente = s.iDPaciente " + "WHERE s.estado = 'cancelado' " + "AND s.dataHoraAgendada >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH) " + "GROUP BY c.nome " + "ORDER BY totalCancelados DESC";

        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("nomeTutor", rs.getString("nome"));
                row.put("totalCancelados", rs.getInt("totalCancelados"));
                lista.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // --- 4.8 PREVISÃO DE SERVIÇOS (PRÓXIMA SEMANA) ---
    public List<Map<String, Object>> getPrevisaoSemana() {
        List<Map<String, Object>> lista = new ArrayList<>();
        // Utiliza CASE WHEN para identificar o tipo real do serviço
        String sql = "SELECT " + "CASE " + "    WHEN co.iDServico IS NOT NULL THEN 'Consulta' " + "    WHEN ci.iDServico IS NOT NULL THEN 'Cirurgia' " + "    WHEN v.iDServico IS NOT NULL THEN 'Vacinacao' " + "    WHEN d.iDServico IS NOT NULL THEN 'Desparasitacao' " + "    WHEN t.iDServico IS NOT NULL THEN 'Tratamento' " + "    WHEN e.iDServico IS NOT NULL THEN 'Exame' " + "    ELSE 'Outro' " + "END AS tipo, " + "COUNT(*) as qtd " + "FROM ServicoMedicoAgendamento s " + "LEFT JOIN Consulta co ON s.iDServico = co.iDServico " + "LEFT JOIN Cirurgia ci ON s.iDServico = ci.iDServico " + "LEFT JOIN Vacinacao v ON s.iDServico = v.iDServico " + "LEFT JOIN Desparasitacao d ON s.iDServico = d.iDServico " + "LEFT JOIN TratamentoTerapeutico t ON s.iDServico = t.iDServico " + "LEFT JOIN Exame e ON s.iDServico = e.iDServico " + "WHERE s.dataHoraAgendada BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY) " + "AND s.estado IN ('ativo', 'pendente') " + "GROUP BY tipo";

        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("tipo", rs.getString("tipo"));
                row.put("qtd", rs.getInt("qtd"));
                lista.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
