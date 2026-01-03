<%@ page import="model.Paciente.Paciente" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ServicoMedicoAgendamento" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Paciente p = (Paciente) request.getAttribute("animal");
    List<ServicoMedicoAgendamento> historico = (List<ServicoMedicoAgendamento>) request.getAttribute("historico");
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ficha: <%= p.getNome() %> | VetCare</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .page-container {
            max-width: 1100px;
            margin: 0 auto;
        }

        .header-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header-info {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .btn-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            display: inline-block;
            margin-bottom: 10px;
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .pet-name {
            font-size: 32px;
            font-weight: 700;
            color: #2d3748;
            margin: 5px 0;
        }

        .pet-details {
            color: #718096;
            font-size: 15px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .pet-details span {
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-add {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            padding: 14px 28px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
            white-space: nowrap;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.4);
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 35px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
        }

        .section-header h3 {
            color: #2d3748;
            font-size: 22px;
            font-weight: 600;
            margin: 0;
        }

        .section-icon {
            font-size: 28px;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            padding: 18px;
            border-radius: 10px;
            text-align: center;
            border-left: 4px solid #667eea;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #2d3748;
        }

        .stat-label {
            font-size: 12px;
            color: #718096;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 5px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            border-radius: 12px;
        }

        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .empty-state p {
            color: #718096;
            font-size: 16px;
            font-style: italic;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 15px;
        }

        thead tr {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        th {
            padding: 16px;
            text-align: left;
            color: white;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        th:first-child {
            border-radius: 10px 0 0 0;
        }

        th:last-child {
            border-radius: 0 10px 0 0;
        }

        td {
            padding: 18px 16px;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
            color: #2d3748;
        }

        tbody tr {
            transition: all 0.2s ease;
        }

        tbody tr:hover {
            background-color: #f7fafc;
            transform: scale(1.005);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .service-cell {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .service-type {
            font-weight: 600;
            color: #2d3748;
            font-size: 15px;
        }

        .service-description {
            color: #718096;
            font-size: 13px;
        }

        .badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .bg-pendente {
            background: #feebc8;
            color: #7c2d12;
        }

        .bg-ativo {
            background: #c6f6d5;
            color: #22543d;
        }

        .bg-cancelado {
            background: #e2e8f0;
            color: #4a5568;
        }

        .bg-reagendado {
            background: #bee3f8;
            color: #2c5282;
        }

        .action-group {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .action-form {
            display: inline-flex;
            gap: 6px;
            align-items: center;
        }

        .btn-mini {
            padding: 8px 14px;
            border: none;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .btn-red {
            background: linear-gradient(135deg, #fc8181 0%, #f56565 100%);
            box-shadow: 0 2px 8px rgba(245, 101, 101, 0.3);
        }

        .btn-red:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(245, 101, 101, 0.4);
        }

        .btn-blue {
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            box-shadow: 0 2px 8px rgba(66, 153, 225, 0.3);
        }

        .btn-blue:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(66, 153, 225, 0.4);
        }

        .datetime-input {
            padding: 6px 10px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 11px;
            width: 150px;
        }

        .datetime-input:focus {
            outline: none;
            border-color: #667eea;
        }

        .no-action {
            color: #cbd5e0;
            font-size: 13px;
            font-style: italic;
        }

        .timeline-marker {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 8px;
        }

        .marker-future {
            background: #48bb78;
            box-shadow: 0 0 8px rgba(72, 187, 120, 0.5);
        }

        .marker-past {
            background: #a0aec0;
        }

        @media (max-width: 768px) {
            .header-card {
                padding: 20px;
            }

            .pet-name {
                font-size: 24px;
            }

            .container {
                padding: 25px 20px;
            }

            .stats-row {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 12px;
            }

            th, td {
                padding: 12px 10px;
            }

            .action-group {
                flex-direction: column;
                align-items: stretch;
            }

            .datetime-input {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="page-container">
    <div class="header-card">
        <div class="header-info">
            <a href="TutorServlet?action=dashboard" class="btn-back">Voltar ao Painel</a>
            <h1 class="pet-name"><%= p.getNome() %>
            </h1>
            <div class="pet-details">
                <span><strong>Raça:</strong> <%= p.getRaca() %></span>
                <span><strong>Idade:</strong> <%= p.getIdadeFormatada() %></span>
                <span><strong>Escalão:</strong> <%= p.getEscalaoEtario() %></span>
            </div>
        </div>
        <a href="TutorServlet?action=agendar&idPaciente=<%= p.getidPaciente() %>" class="btn-add">
            + Agendar Novo Serviço
        </a>
    </div>

    <div class="container">
        <% if (historico != null && !historico.isEmpty()) { %>

        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-value"><%= historico.size() %>
                </div>
                <div class="stat-label">Total de Serviços</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= historico.stream().filter(s -> s.getDataHoraAgendada() != null && s.getDataHoraAgendada().isAfter(LocalDateTime.now())).count() %>
                </div>
                <div class="stat-label">Próximos</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= historico.stream().filter(s -> "pendente".equalsIgnoreCase(s.getEstado())).count() %>
                </div>
                <div class="stat-label">Pendentes</div>
            </div>
        </div>

        <% } %>

        <div class="section-header">
            <span class="section-icon">📋</span>
            <h3>Histórico e Agendamentos</h3>
        </div>

        <% if (historico == null || historico.isEmpty()) { %>

        <div class="empty-state">
            <div class="empty-state-icon">🐾</div>
            <p>Ainda não existem serviços registados para <%= p.getNome() %>.</p>
        </div>

        <% } else { %>

        <table>
            <thead>
            <tr>
                <th style="width: 20%">Data e Hora</th>
                <th style="width: 35%">Serviço</th>
                <th style="width: 15%">Estado</th>
                <th style="width: 30%">Ações</th>
            </tr>
            </thead>
            <tbody>
            <% for (ServicoMedicoAgendamento s : historico) {
                String st = (s.getEstado() != null) ? s.getEstado().toLowerCase() : "pendente";
                String badgeClass = "bg-" + st;
                boolean isFuturo = s.getDataHoraAgendada() != null && s.getDataHoraAgendada().isAfter(LocalDateTime.now());
            %>
            <tr>
                <td>
                    <span class="timeline-marker <%= isFuturo ? "marker-future" : "marker-past" %>"></span>
                    <%= (s.getDataHoraAgendada() != null) ? s.getDataHoraAgendada().toString().replace("T", " ") : "-" %>
                </td>
                <td>
                    <div class="service-cell">
                        <span class="service-type">
                            <%= s.getTipoServico() != null ? s.getTipoServico() : "Geral" %>
                        </span>
                        <span class="service-description"><%= s.getDescricao() %></span>
                    </div>
                </td>
                <td>
                    <span class="badge <%= badgeClass %>"><%= st %></span>
                </td>
                <td>
                    <% if (isFuturo && !"cancelado".equals(st)) { %>
                    <div class="action-group">
                        <form action="TutorServlet" method="post" class="action-form"
                              onsubmit="return confirm('Tem a certeza que deseja cancelar este agendamento?');">
                            <input type="hidden" name="action" value="cancelar">
                            <input type="hidden" name="idPaciente" value="<%= p.getidPaciente() %>">
                            <input type="hidden" name="idServico" value="<%= s.getIdServico() %>">
                            <button type="submit" class="btn-mini btn-red">Cancelar</button>
                        </form>

                        <form action="TutorServlet" method="post" class="action-form">
                            <input type="hidden" name="action" value="reagendar">
                            <input type="hidden" name="idPaciente" value="<%= p.getidPaciente() %>">
                            <input type="hidden" name="idServico" value="<%= s.getIdServico() %>">
                            <input type="datetime-local" name="novaDataHora" required class="datetime-input">
                            <button type="submit" class="btn-mini btn-blue">Reagendar</button>
                        </form>
                    </div>
                    <% } else { %>
                    <span class="no-action">Sem ações disponíveis</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <% } %>
    </div>
</div>

</body>
</html>