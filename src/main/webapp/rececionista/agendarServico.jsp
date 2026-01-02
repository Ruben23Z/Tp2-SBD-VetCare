<%@ page import="java.util.List" %>
<%@ page import="model.Paciente" %>
<%@ page import="model.ServicoMedicoAgendamento" %>
<%@ page import="model.Utilizador.Veterinario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Paciente animal = (Paciente) request.getAttribute("animal");

    if (animal == null) {
        response.sendRedirect(request.getContextPath() + "/AnimalServlet?acao=listar");
        return;
    }

    List<ServicoMedicoAgendamento> lista = (List<ServicoMedicoAgendamento>) request.getAttribute("listaAgendamentos");
    List<Veterinario> vets = (List<Veterinario>) request.getAttribute("listaVets");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendamentos - <%= animal.getNome() %> | VetCare</title>
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

        .header-info h2 {
            color: #2d3748;
            font-size: 26px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .header-info .animal-details {
            color: #718096;
            font-size: 14px;
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .animal-details span {
            display: inline-flex;
            align-items: center;
            gap: 5px;
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

        .alert {
            background: rgba(255, 255, 255, 0.95);
            padding: 16px 24px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-left: 4px solid;
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .alert.success {
            color: #155724;
            background: #d4edda;
            border-left-color: #28a745;
        }

        .alert.error {
            color: #721c24;
            background: #f8d7da;
            border-left-color: #dc3545;
        }

        .alert.info {
            color: #004085;
            background: #d1ecf1;
            border-left-color: #17a2b8;
        }

        .container {
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
            padding: 12px 14px;
            border-radius: 8px;
            margin-top: 8px;
            border-left: 3px solid #667eea;
            max-height: 150px;
            overflow-y: auto;
        }

        .vet-list strong {
            display: block;
            margin-bottom: 8px;
            color: #2d3748;
            font-size: 13px;
        }

        .vet-item {
            display: block;
            padding: 4px 0;
            color: #4a5568;
            font-size: 12px;
            line-height: 1.6;
        }

        .vet-id {
            background: #667eea;
            color: white;
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: 600;
            margin-right: 6px;
        }

        .btn {
            padding: 8px 16px;
            cursor: pointer;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            text-align: center;
            transition: all 0.3s ease;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            margin-top: 25px;
            font-size: 15px;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.4);
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

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .bg-ativo {
            background: #c6f6d5;
            color: #22543d;
        }

        .bg-pendente {
            background: #feebc8;
            color: #7c2d12;
        }

        .bg-cancelado {
            background: #fed7d7;
            color: #742a2a;
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

        .action-group input[type="datetime-local"] {
            width: 160px;
            font-size: 11px;
            padding: 6px 8px;
            margin: 0;
        }

        .action-group .btn {
            padding: 6px 12px;
            font-size: 12px;
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

        .service-description {
            font-weight: 600;
            margin-bottom: 4px;
        }

        .service-location {
            color: #718096;
            font-size: 12px;
        }

        @media (max-width: 1200px) {
            .container {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .header {
                padding: 20px;
            }

            .header-info h2 {
                font-size: 20px;
            }

            .box {
                padding: 20px;
            }

            .action-group {
                flex-direction: column;
                align-items: stretch;
            }

            .action-group input[type="datetime-local"] {
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
        <div class="header-info">
            <h2>Agenda de <%= animal.getNome() %></h2>
            <div class="animal-details">
                <span><strong>Tutor NIF:</strong> <%= animal.getNifDono() %></span>
                <span><strong>Raça:</strong> <%= animal.getRaca() %></span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/AnimalServlet?acao=listar" class="btn-back">Voltar à Lista</a>
    </div>

    <% if ("erroBD".equals(msg)) { %>
    <div class="alert error">Erro na operação. Verifique os dados inseridos.</div>
    <% } %>
    <% if ("sucesso".equals(msg)) { %>
    <div class="alert success">Agendamento criado com sucesso.</div>
    <% } %>
    <% if ("cancelado".equals(msg)) { %>
    <div class="alert error">Serviço cancelado.</div>
    <% } %>
    <% if ("reagendado".equals(msg)) { %>
    <div class="alert info">Serviço reagendado com sucesso.</div>
    <% } %>

    <div class="container">
        <div class="box">
            <h3>Novo Agendamento</h3>

            <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post">
                <input type="hidden" name="action" value="criar">
                <input type="hidden" name="idPaciente" value="<%= animal.getidPaciente() %>">

                <div class="form-group">
                    <label>Tipo de Serviço</label>
                    <select name="tipoServico" required>
                        <option value="" disabled selected>Selecione o serviço...</option>
                        <option value="Consulta">Consulta</option>
                        <option value="Vacinacao">Vacinação</option>
                        <option value="Desparasitacao">Desparasitação</option>
                        <option value="Exame">Exame</option>
                        <option value="Cirurgia">Cirurgia</option>
                        <option value="TratamentoTerapeutico">Tratamento Terapêutico</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Descrição / Motivo</label>
                    <input type="text" name="descricao" required placeholder="Ex: Vacina da Raiva, Check-up anual...">
                </div>

                <div class="form-group">
                    <label>Data e Hora</label>
                    <input type="datetime-local" name="dataHora" required>
                </div>

                <div class="form-group">
                    <label>Identificador do Veterinário</label>
                    <input type="text" name="idVeterinario" placeholder="Insira o ID do veterinário" required>

                    <div class="vet-list">
                        <strong>Veterinários Disponíveis:</strong>
                        <% if (vets != null && !vets.isEmpty()) {
                            for (Veterinario v : vets) { %>
                        <span class="vet-item">
                            <span class="vet-id"><%= v.getiDUtilizador() %></span>
                            <%= v.getNome() %> - <%= v.getEspecialidade() %>
                        </span>
                        <% }
                        } else { %>
                        <span class="vet-item">Nenhum veterinário encontrado.</span>
                        <% } %>
                    </div>
                </div>

                <div class="form-group">
                    <label>Clínica</label>
                    <select name="localidade" required>
                        <option value="" disabled selected>Selecione a clínica...</option>
                        <option value="Serpa">Serpa</option>
                        <option value="Odivelas">Odivelas</option>
                        <option value="Quinta do Conde">Quinta do Conde</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-submit">Confirmar Agendamento</button>
            </form>
        </div>

        <div class="box">
            <h3>Histórico de Serviços</h3>

            <% if (lista == null || lista.isEmpty()) { %>
            <div class="empty-state">
                <p>Este animal ainda não tem serviços agendados.</p>
            </div>
            <% } else { %>
            <table>
                <thead>
                <tr>
                    <th style="width: 20%">Data e Hora</th>
                    <th style="width: 30%">Serviço</th>
                    <th style="width: 15%">Estado</th>
                    <th style="width: 35%">Ações</th>
                </tr>
                </thead>
                <tbody>
                <% for (ServicoMedicoAgendamento s : lista) {
                    String st = (s.getEstado() != null) ? s.getEstado().toLowerCase() : "pendente";
                    String bgClass = "bg-" + st;
                    if (!st.equals("ativo") && !st.equals("cancelado") && !st.equals("reagendado")) {
                        bgClass = "bg-pendente";
                    }
                %>
                <tr>
                    <td>
                        <strong><%= (s.getDataHoraAgendada() != null) ? s.getDataHoraAgendada().toString().replace("T", " ") : "-" %></strong>
                    </td>
                    <td>
                        <div class="service-description"><%= s.getDescricao() %></div>
                        <div class="service-location"><%= s.getLocalidade() %></div>
                    </td>
                    <td>
                        <span class="badge <%= bgClass %>"><%= s.getEstado() %></span>
                    </td>
                    <td>
                        <% if (!"cancelado".equals(st)) { %>
                        <div class="action-group">
                            <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post">
                                <input type="hidden" name="action" value="reagendar">
                                <input type="hidden" name="idPaciente" value="<%= animal.getidPaciente() %>">
                                <input type="hidden" name="idServico" value="<%= s.getIdServico() %>">
                                <input type="datetime-local" name="novaDataHora" required>
                                <button type="submit" class="btn btn-blue">Reagendar</button>
                            </form>

                            <form action="${pageContext.request.contextPath}/AgendamentoServlet" method="post"
                                  onsubmit="return confirm('Tem a certeza que deseja cancelar este agendamento?');">
                                <input type="hidden" name="action" value="cancelar">
                                <input type="hidden" name="idPaciente" value="<%= animal.getidPaciente() %>">
                                <input type="hidden" name="idServico" value="<%= s.getIdServico() %>">
                                <button type="submit" class="btn btn-red">Cancelar</button>
                            </form>
                        </div>
                        <% } else { %>
                        <span style="color: #cbd5e0; font-size: 13px; font-style: italic;">Cancelado</span>
                        <% } %>
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