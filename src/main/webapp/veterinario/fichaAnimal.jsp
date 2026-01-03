<%@ page import="model.Paciente.Paciente" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ServicoMedicoAgendamento" %>
<%@ page import="model.Paciente.NoArvore" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Paciente p = (Paciente) request.getAttribute("animal");
    NoArvore arvore = (NoArvore) request.getAttribute("arvore");
    List<ServicoMedicoAgendamento> historico = (List<ServicoMedicoAgendamento>) request.getAttribute("historico");

    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/VeterinarioServlet?action=dashboard");
        return;
    }
%>

<%!
    public String desenharArvore(NoArvore no, String contextPath) {
        if (no == null) return "";

        StringBuilder sb = new StringBuilder();
        sb.append("<li>");

        sb.append("<a href='").append(contextPath).append("/VeterinarioServlet?action=consultarFicha&idPaciente=")
                .append(no.getPaciente().getidPaciente()).append("' class='tree-card'>");

        String foto = (no.getPaciente().getFoto() != null && !no.getPaciente().getFoto().isEmpty())
                ? no.getPaciente().getFoto()
                : "https://via.placeholder.com/50?text=Pet";
        if (!foto.startsWith("http")) foto = contextPath + "/" + foto;

        sb.append("<img src='").append(foto).append("'>");
        sb.append("<span class='role-badge'>").append(no.getTipoParentesco()).append("</span>");
        sb.append("<strong>").append(no.getPaciente().getNome()).append("</strong>");
        sb.append("</a>");

        if (no.getProgenitores() != null && !no.getProgenitores().isEmpty()) {
            sb.append("<ul>");
            for (NoArvore pai : no.getProgenitores()) {
                sb.append(desenharArvore(pai, contextPath));
            }
            sb.append("</ul>");
        }

        sb.append("</li>");
        return sb.toString();
    }
%>

<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ficha Clínica: <%= p.getNome() %> | VetCare</title>
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

        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .btn-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            white-space: nowrap;
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .header h1 {
            color: #2d3748;
            font-size: 26px;
            font-weight: 600;
        }

        .btn-action {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.3);
            white-space: nowrap;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.4);
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .card h2 {
            color: #2d3748;
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 3px solid #667eea;
        }

        .info-row {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #4a5568;
            min-width: 140px;
        }

        .info-value {
            color: #2d3748;
            flex: 1;
        }

        .badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin: 0 5px;
        }

        .tag-idade {
            background: #fed7d7;
            color: #742a2a;
        }

        .tag-escalao {
            background: #bee3f8;
            color: #2c5282;
        }

        .status-vivo {
            color: #22543d;
            font-weight: 600;
            background: #c6f6d5;
            padding: 4px 12px;
            border-radius: 12px;
            display: inline-block;
        }

        .status-falecido {
            color: #742a2a;
            font-weight: 600;
            background: #fed7d7;
            padding: 4px 12px;
            border-radius: 12px;
            display: inline-block;
        }

        .tree-container {
            overflow-x: auto;
            padding: 20px 0;
        }

        .tree ul {
            padding-top: 20px;
            position: relative;
            transition: all 0.5s;
            display: flex;
            justify-content: center;
        }

        .tree li {
            float: left;
            text-align: center;
            list-style-type: none;
            position: relative;
            padding: 20px 5px 0 5px;
            transition: all 0.5s;
        }

        .tree li::before,
        .tree li::after {
            content: '';
            position: absolute;
            top: 0;
            right: 50%;
            border-top: 2px solid #cbd5e0;
            width: 50%;
            height: 20px;
        }

        .tree li::after {
            right: auto;
            left: 50%;
            border-left: 2px solid #cbd5e0;
        }

        .tree li:only-child::after,
        .tree li:only-child::before {
            display: none;
        }

        .tree li:only-child {
            padding-top: 0;
        }

        .tree li:first-child::before,
        .tree li:last-child::after {
            border: 0 none;
        }

        .tree li:last-child::before {
            border-right: 2px solid #cbd5e0;
            border-radius: 0 5px 0 0;
        }

        .tree li:first-child::after {
            border-radius: 5px 0 0 0;
        }

        .tree ul ul::before {
            content: '';
            position: absolute;
            top: 0;
            left: 50%;
            border-left: 2px solid #cbd5e0;
            width: 0;
            height: 20px;
        }

        .tree-card {
            border: 2px solid #e2e8f0;
            padding: 15px;
            text-decoration: none;
            color: #2d3748;
            font-size: 13px;
            display: inline-block;
            border-radius: 12px;
            background: white;
            transition: all 0.3s;
            min-width: 120px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .tree-card:hover {
            background: linear-gradient(135deg, #f0f4ff 0%, #e9f0ff 100%);
            border-color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3);
        }

        .tree-card img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 8px;
            border: 2px solid #e2e8f0;
        }

        .role-badge {
            display: block;
            font-size: 10px;
            color: #667eea;
            font-weight: 700;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .tree-card strong {
            display: block;
            color: #2d3748;
            font-size: 14px;
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

        .service-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .btn-edit {
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(66, 153, 225, 0.3);
        }

        .btn-edit:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(66, 153, 225, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #718096;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 1000;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        .modal-content {
            background: white;
            margin: 10% auto;
            padding: 35px;
            width: 90%;
            max-width: 600px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
        }

        .modal-header h3 {
            color: #2d3748;
            font-size: 22px;
            font-weight: 600;
            margin: 0;
        }

        .close {
            font-size: 32px;
            color: #718096;
            cursor: pointer;
            transition: color 0.3s;
            line-height: 1;
        }

        .close:hover {
            color: #2d3748;
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

        textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: all 0.3s ease;
            resize: vertical;
            min-height: 120px;
        }

        textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
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

        @media (max-width: 1024px) {
            .grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .header {
                padding: 20px;
            }

            .header h1 {
                font-size: 20px;
            }

            .card {
                padding: 20px;
            }

            .modal-content {
                width: 95%;
                margin: 5% auto;
                padding: 25px;
            }

            table {
                font-size: 12px;
            }

            th, td {
                padding: 10px;
            }
        }
    </style>

    <script>
        function abrirModal(idServico, textoAtual) {
            document.getElementById('modalIdServico').value = idServico;
            document.getElementById('modalTexto').value = textoAtual;
            document.getElementById('editModal').style.display = 'block';
        }

        function fecharModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        window.onclick = function (event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                fecharModal();
            }
        }
    </script>
</head>
<body>

<div class="page-container">
    <div class="header">
        <div class="header-left">
            <a href="javascript:history.back()" class="btn-back">Voltar</a>
            <h1>Ficha Clínica: <%= p.getNome() %>
            </h1>
        </div>
        <a href="${pageContext.request.contextPath}/AgendamentoServlet?action=gerir&idPaciente=<%= p.getidPaciente() %>"
           class="btn-action">
            Gerir Agendamentos
        </a>
    </div>

    <div class="grid">
        <div class="card">
            <h2>Dados do Paciente</h2>

            <div class="info-row">
                <span class="info-label">Raça:</span>
                <span class="info-value"><%= p.getRaca() %></span>
            </div>

            <div class="info-row">
                <span class="info-label">Data de Nascimento:</span>
                <span class="info-value"><%= p.getDataNascimento() %></span>
            </div>

            <div class="info-row">
                <span class="info-label">Estado:</span>
                <span class="info-value">
                    <% if (p.getDataObito() != null) { %>
                    <span class="status-falecido">Falecido em <%= p.getDataObito() %></span>
                    <% } else { %>
                    <span class="status-vivo">Vivo</span>
                    <% } %>
                </span>
            </div>

            <div class="info-row">
                <span class="info-label">NIF do Tutor:</span>
                <span class="info-value"><%= p.getNifDono() %></span>
            </div>

            <div class="info-row">
                <span class="info-label">Informações Adicionais:</span>
                <span class="info-value">
                    <span class="badge tag-idade">Idade: <%= p.getIdadeFormatada() %></span>
                    <span class="badge tag-escalao">Escalão: <%= p.getEscalaoEtario() %></span>
                </span>
            </div>
        </div>

        <div class="card">
            <h2>Árvore Genealógica</h2>
            <div class="tree-container">
                <div class="tree">
                    <ul>
                        <% if (arvore != null) { %>
                        <%= desenharArvore(arvore, request.getContextPath()) %>
                        <% } else { %>
                        <li class="empty-state">Árvore genealógica não disponível.</li>
                        <% } %>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <h2>Histórico Clínico e Notas</h2>
        <table>
            <thead>
            <tr>
                <th style="width: 18%">Data e Hora</th>
                <th style="width: 15%">Tipo de Serviço</th>
                <th style="width: 47%">Descrição / Notas Clínicas</th>
                <th style="width: 20%">Ações</th>
            </tr>
            </thead>
            <tbody>
            <% if (historico != null && !historico.isEmpty()) {
                for (ServicoMedicoAgendamento s : historico) { %>
            <tr>
                <td>
                    <%= (s.getDataHoraAgendada() != null) ? s.getDataHoraAgendada().toString().replace("T", " ") : "-" %>
                </td>
                <td>
                    <span class="service-badge">
                        <%= s.getTipoServico() != null ? s.getTipoServico() : "Geral" %>
                    </span>
                </td>
                <td><%= s.getDescricao() %>
                </td>
                <td>
                    <button onclick="abrirModal(<%= s.getIdServico() %>, '<%= s.getDescricao() %>')"
                            class="btn-edit">
                        Editar Nota
                    </button>
                </td>
            </tr>
            <% }
            } else { %>
            <tr>
                <td colspan="4" class="empty-state">
                    <p>Sem histórico clínico disponível para este paciente.</p>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<div id="editModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Atualizar Nota Clínica</h3>
            <span class="close" onclick="fecharModal()">&times;</span>
        </div>
        <form action="${pageContext.request.contextPath}/VeterinarioServlet" method="post">
            <input type="hidden" name="action" value="atualizarNotas">
            <input type="hidden" name="idPaciente" value="<%= p.getidPaciente() %>">
            <input type="hidden" id="modalIdServico" name="idServico">

            <div class="form-group">
                <label>Descrição do Serviço / Notas Clínicas:</label>
                <textarea id="modalTexto" name="notas" required
                          placeholder="Insira as notas clínicas detalhadas..."></textarea>
            </div>

            <button type="submit" class="btn-submit">Guardar Alterações</button>
        </form>
    </div>
</div>

</body>
</html>