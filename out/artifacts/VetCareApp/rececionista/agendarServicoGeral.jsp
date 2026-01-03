<%@ page import="java.util.List" %>
<%@ page import="model.Paciente" %>
<%@ page import="model.Utilizador.Veterinario" %>
<%@ page import="model.ServicoMedicoAgendamento" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Paciente> animais = (List<Paciente>) request.getAttribute("listaAnimais");
    List<Veterinario> vets = (List<Veterinario>) request.getAttribute("listaVets");
    List<ServicoMedicoAgendamento> agenda = (List<ServicoMedicoAgendamento>) request.getAttribute("agendaGeral");
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Agendamentos - VetCare</title>
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
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px 30px;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header h2 {
            color: #2d3748;
            font-size: 26px;
            font-weight: 600;
        }

        .btn-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 10px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .content-wrapper {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 25px;
        }

        .box {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .box h3 {
            color: #2d3748;
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 25px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e2e8f0;
        }

        .form-section {
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .label-number {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            text-align: center;
            line-height: 24px;
            margin-right: 8px;
            font-size: 12px;
            font-weight: 700;
        }

        input[type="text"],
        input[type="datetime-local"],
        select {
            width: 100%;
            padding: 10px 14px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
            color: #2d3748;
        }

        input[type="text"]:focus,
        input[type="datetime-local"]:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 18px;
            padding-right: 40px;
        }

        .vet-list {
            background: #f7fafc;
            padding: 10px 12px;
            border-radius: 8px;
            margin-top: 8px;
            border-left: 3px solid #667eea;
            max-height: 120px;
            overflow-y: auto;
            font-size: 12px;
            color: #4a5568;
            line-height: 1.6;
        }

        .vet-item {
            display: block;
            padding: 2px 0;
        }

        .vet-id {
            background: #667eea;
            color: white;
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: 600;
            margin-right: 6px;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.4);
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
            padding: 14px 16px;
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
            padding: 16px;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
            color: #2d3748;
        }

        tbody tr {
            transition: background-color 0.2s ease;
        }

        tbody tr:hover {
            background-color: #f7fafc;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .patient-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .date-time {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 4px;
        }

        .patient-name {
            color: #4a5568;
            font-size: 13px;
        }

        .service-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .service-type {
            color: #667eea;
            font-weight: 600;
            font-size: 13px;
        }

        .service-description {
            color: #2d3748;
            font-size: 13px;
        }

        .service-location {
            color: #a0aec0;
            font-size: 12px;
        }

        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .st-ativo {
            background: #c6f6d5;
            color: #22543d;
        }

        .st-pendente {
            background: #feebc8;
            color: #7c2d12;
        }

        .st-cancelado {
            background: #fed7d7;
            color: #742a2a;
        }

        .st-reagendado {
            background: #bee3f8;
            color: #2c5282;
        }

        .action-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .action-form {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-mini {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .btn-green {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            box-shadow: 0 2px 8px rgba(72, 187, 120, 0.3);
        }

        .btn-green:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(72, 187, 120, 0.4);
        }

        .btn-blue {
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            box-shadow: 0 2px 8px rgba(66, 153, 225, 0.3);
        }

        .btn-blue:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(66, 153, 225, 0.4);
        }

        .btn-red {
            background: linear-gradient(135deg, #fc8181 0%, #f56565 100%);
            box-shadow: 0 2px 8px rgba(245, 101, 101, 0.3);
        }

        .btn-red:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(245, 101, 101, 0.4);
        }

        .date-mini {
            padding: 6px 8px;
            font-size: 11px;
            width: 150px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
        }

        .date-mini:focus {
            outline: none;
            border-color: #667eea;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #718096;
        }

        .empty-state p {
            font-size: 16px;
            margin-bottom: 10px;
        }

        .canceled-text {
            color: #cbd5e0;
            font-size: 13px;
            font-style: italic;
        }

        @media (max-width: 1200px) {
            .content-wrapper {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .header {
                padding: 20px;
            }

            .header h2 {
                font-size: 20px;
            }

            .box {
                padding: 20px;
            }

            .action-form {
                flex-wrap: wrap;
            }

            .date-mini {
                width: 100%;
            }

            table {
                font-size: 12px;
            }

            th, td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>

<div class="page-container">
    <div class="header">
        <h2>Gestão de Agendamentos</h2>
        <a href="${pageContext.request.contextPath}/rececionista/menuRece.jsp" class="btn-back">Voltar ao Menu</a>
    </div>

    <div class="content-wrapper">
        <div class="box">
            <h3>Novo Agendamento</h3>

            <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post">
                <input type="hidden" name="action" value="criar">
                <input type="hidden" name="origem" value="geral">

                <div class="form-section">
                    <div class="form-group">
                        <label>
                            <span class="label-number">1</span>
                            Selecione o Animal
                        </label>
                        <select name="idPaciente" required>
                            <option value="" disabled selected>Escolha o paciente...</option>
                            <% if(animais != null) {
                                for(Paciente p : animais) { %>
                            <option value="<%= p.getidPaciente() %>">
                                <%= p.getNome() %> - NIF: <%= p.getNifDono() %>
                            </option>
                            <% }} %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>
                            <span class="label-number">2</span>
                            Tipo de Serviço
                        </label>
                        <select name="tipoServico" required>
                            <option value="" disabled selected>Selecione o tipo...</option>
                            <option value="Consulta">Consulta</option>
                            <option value="Vacinacao">Vacinação</option>
                            <option value="Desparasitacao">Desparasitação</option>
                            <option value="Exame">Exame</option>
                            <option value="Cirurgia">Cirurgia</option>
                            <option value="TratamentoTerapeutico">Tratamento Terapêutico</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>
                            <span class="label-number">3</span>
                            Descrição do Serviço
                        </label>
                        <input type="text" name="descricao" required placeholder="Ex: Vacina da Raiva, Check-up anual...">
                    </div>

                    <div class="form-group">
                        <label>
                            <span class="label-number">4</span>
                            Data e Hora
                        </label>
                        <input type="datetime-local" name="dataHora" required>
                    </div>

                    <div class="form-group">
                        <label>
                            <span class="label-number">5</span>
                            Identificador do Veterinário
                        </label>
                        <input type="text" name="idVeterinario" required placeholder="Insira o ID do veterinário">

                        <div class="vet-list">
                            <% if(vets != null && !vets.isEmpty()) {
                                for(Veterinario v : vets) { %>
                            <span class="vet-item">
                                <span class="vet-id"><%= v.getiDUtilizador() %></span>
                                <%= v.getNome() %>
                            </span>
                            <% }} else { %>
                            <span class="vet-item">Nenhum veterinário disponível.</span>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>
                            <span class="label-number">6</span>
                            Clínica
                        </label>
                        <select name="localidade" required>
                            <option value="" disabled selected>Selecione a clínica...</option>
                            <option value="Serpa">Serpa</option>
                            <option value="Odivelas">Odivelas</option>
                            <option value="Quinta do Conde">Quinta do Conde</option>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Confirmar Agendamento</button>
            </form>
        </div>

        <div class="box">
            <h3>Agenda Global de Serviços</h3>

            <% if (agenda == null || agenda.isEmpty()) { %>
            <div class="empty-state">
                <p>Não existem agendamentos registados no sistema.</p>
            </div>
            <% } else { %>
            <table>
                <thead>
                <tr>
                    <th style="width: 25%;">Data / Paciente</th>
                    <th style="width: 30%;">Serviço</th>
                    <th style="width: 12%;">Estado</th>
                    <th style="width: 33%;">Ações</th>
                </tr>
                </thead>
                <tbody>
                <% for (ServicoMedicoAgendamento s : agenda) {
                    String st = (s.getEstado() != null) ? s.getEstado().toLowerCase() : "pendente";
                    String badgeClass = "st-" + st;
                    if (!st.equals("ativo") && !st.equals("cancelado") && !st.equals("reagendado")) {
                        badgeClass = "st-pendente";
                    }
                %>
                <tr>
                    <td>
                        <div class="patient-info">
                            <span class="date-time">
                                <%= (s.getDataHoraAgendada() != null) ? s.getDataHoraAgendada().toString().replace("T", " ") : "-" %>
                            </span>
                            <span class="patient-name">
                                <%= s.getNomeAnimal() != null ? s.getNomeAnimal() : "ID: " + s.getIdPaciente() %>
                            </span>
                        </div>
                    </td>
                    <td>
                        <div class="service-info">
                            <span class="service-type"><%= s.getTipoServico() %></span>
                            <span class="service-description"><%= s.getDescricao() %></span>
                            <span class="service-location"><%= s.getLocalidade() %></span>
                        </div>
                    </td>
                    <td>
                        <span class="badge <%= badgeClass %>"><%= s.getEstado() %></span>
                    </td>
                    <td>
                        <div class="action-group">
                            <% if ("pendente".equalsIgnoreCase(st)) { %>
                            <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post" class="action-form">
                                <input type="hidden" name="action" value="ativar">
                                <input type="hidden" name="idServico" value="<%= s.getIdServico() %>">
                                <input type="hidden" name="idPaciente" value="<%= s.getIdPaciente() %>">
                                <input type="hidden" name="origem" value="geral">
                                <button type="submit" class="btn-mini btn-green">Confirmar Presença</button>
                            </form>
                            <% } %>

                            <% if (!"cancelado".equals(st)) { %>
                            <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post" class="action-form">
                                <input type="hidden" name="action" value="reagendar">
                                <input type="hidden" name="idPaciente" value="<%= s.getIdPaciente() %>">
                                <input type="hidden" name="idServico" value="<%= s.getIdServico() %>">
                                <input type="hidden" name="origem" value="geral">
                                <input type="datetime-local" name="novaDataHora" required class="date-mini">
                                <button type="submit" class="btn-mini btn-blue">Reagendar</button>
                            </form>

                            <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post" class="action-form"
                                  onsubmit="return confirm('Tem a certeza que deseja cancelar este agendamento?');">
                                <input type="hidden" name="action" value="cancelar">
                                <input type="hidden" name="idPaciente" value="<%= s.getIdPaciente() %>">
                                <input type="hidden" name="idServico" value="<%= s.getIdServico() %>">
                                <input type="hidden" name="origem" value="geral">
                                <button type="submit" class="btn-mini btn-red">Cancelar</button>
                            </form>
                            <% } else { %>
                            <span class="canceled-text">Cancelado</span>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>