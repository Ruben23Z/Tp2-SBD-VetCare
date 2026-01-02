package dao;

import model.ServicoMedicoAgendamento;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AgendamentoDAO {

    public List<ServicoMedicoAgendamento> listarPorAnimal(int idPaciente) {
        List<ServicoMedicoAgendamento> lista = new ArrayList<>();
        String sql = "SELECT * FROM ServicoMedicoAgendamento WHERE iDPaciente = ? ORDER BY dataHoraAgendada DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idPaciente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ServicoMedicoAgendamento s = new ServicoMedicoAgendamento(rs.getInt("iDServico"), rs.getString("descricao"), rs.getTimestamp("dataHoraInicio").toLocalDateTime());

                Timestamp ts = rs.getTimestamp("dataHoraAgendada");
                if (ts != null) s.setDataHoraAgendada(ts.toLocalDateTime());

                s.setEstado(rs.getString("estado"));
                s.setLocalidade(rs.getString("localidade"));
                s.setIdPaciente(rs.getInt("iDPaciente"));

                int idUser = rs.getInt("iDUtilizador");
                if (!rs.wasNull()) {
                    s.setIdUtilizador(idUser);
                }

                lista.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public void criar(ServicoMedicoAgendamento s, String tipoServico) throws SQLException {
        Connection conn = null;
        PreparedStatement psMae = null;
        PreparedStatement psFilha = null;
        ResultSet rs = null;

        String sqlMae = "INSERT INTO ServicoMedicoAgendamento " + "(descricao, dataHoraInicio, dataHoraAgendada, estado, iDPaciente, iDUtilizador, localidade, agendatario) " + "VALUES (?, NOW(), ?, 'pendente', ?, ?, ?, 'Rececionista')";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            psMae = conn.prepareStatement(sqlMae, Statement.RETURN_GENERATED_KEYS);
            psMae.setString(1, s.getDescricao());
            psMae.setTimestamp(2, Timestamp.valueOf(s.getDataHoraAgendada()));
            psMae.setInt(3, s.getIdPaciente());

            // Verificação segura de Nulo
            if (s.getIdUtilizador() != null && s.getIdUtilizador() > 0) {
                psMae.setInt(4, s.getIdUtilizador());
            } else {
                psMae.setNull(4, java.sql.Types.INTEGER);
            }

            psMae.setString(5, s.getLocalidade());

            psMae.executeUpdate();

            rs = psMae.getGeneratedKeys();
            int idGerado = 0;
            if (rs.next()) {
                idGerado = rs.getInt(1);
            } else {
                throw new SQLException("Falha ao obter ID do serviço.");
            }

            switch (tipoServico) {
                case "Consulta":
                    psFilha = conn.prepareStatement("INSERT INTO Consulta (iDServico, motivo) VALUES (?, ?)");
                    psFilha.setInt(1, idGerado);
                    psFilha.setString(2, s.getDescricao());
                    break;
                case "Vacinacao":
                    psFilha = conn.prepareStatement("INSERT INTO Vacinacao (iDServico, viaAdministracao) VALUES (?, 'Subcutânea')");
                    psFilha.setInt(1, idGerado);
                    break;
                case "Desparasitacao":
                    psFilha = conn.prepareStatement("INSERT INTO Desparasitacao (iDServico, interna, dose) VALUES (?, 1, 'Dose Padrão')");
                    psFilha.setInt(1, idGerado);
                    break;
                case "Cirurgia":
                    psFilha = conn.prepareStatement("INSERT INTO Cirurgia (iDServico, tipoCirurgia) VALUES (?, 'Geral')");
                    psFilha.setInt(1, idGerado);
                    break;
                case "Exame":
                    psFilha = conn.prepareStatement("INSERT INTO Exame (iDServico, observacaoTecnica, duracao) VALUES (?, 'Agendado', 30)");
                    psFilha.setInt(1, idGerado);
                    break;
                case "TratamentoTerapeutico":
                    psFilha = conn.prepareStatement("INSERT INTO TratamentoTerapeutico (iDServico, tipoTratamento) VALUES (?, 'Fisioterapia')");
                    psFilha.setInt(1, idGerado);
                    break;
            }

            if (psFilha != null) {
                psFilha.executeUpdate();
            }

            conn.commit();

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (psMae != null) psMae.close();
            if (psFilha != null) psFilha.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // CANCELAR: Muda o estado para 'cancelado' e define o custo como 0.00 para cumprir a constraint
    public void cancelar(int idServico) throws SQLException {
        // CORREÇÃO: Adicionado ", custoCancelamento = 0.00"
        String sql = "UPDATE ServicoMedicoAgendamento SET estado = 'cancelado', custoCancelamento = 0.00 WHERE iDServico = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idServico);
            ps.executeUpdate();
        }
    }
    public void reagendar(int idServico, LocalDateTime novaData) throws SQLException {
        String sql = "UPDATE ServicoMedicoAgendamento SET dataHoraAgendada = ?, estado = 'reagendado' WHERE iDServico = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(novaData));
            ps.setInt(2, idServico);
            ps.executeUpdate();
        }
    }
}