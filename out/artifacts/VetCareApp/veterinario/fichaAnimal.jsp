<%@ page import="model.Paciente" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ServicoMedicoAgendamento" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Recuperar objetos enviados pelo Servlet
    Paciente p = (Paciente) request.getAttribute("animal");
    List<Paciente> pais = (List<Paciente>) request.getAttribute("pais");
    List<ServicoMedicoAgendamento> historico = (List<ServicoMedicoAgendamento>) request.getAttribute("historico");

    // --- CORREÇÃO: PROTEÇÃO CONTRA NULOS ---
    // Se o paciente for nulo (acesso direto ou ID errado), volta ao menu
    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/VeterinarioServlet?action=dashboard");
        return;
    }
    // ----------------------------------------
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Ficha Clínica: <%= p.getNome() %>
    </title>
    <style>
        body {
            padding: 20px;
            font-family: 'Segoe UI', sans-serif;
            background: #f4f4f9;
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        h2 {
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
            color: #444;
            margin-top: 0;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 15px;
            color: white;
            font-size: 13px;
            font-weight: bold;
        }

        .tag-idade {
            background: #ff9800;
        }

        .tag-escalao {
            background: #2196F3;
        }

        .tree-node {
            padding: 10px;
            background: #e3f2fd;
            margin: 5px 0;
            border-radius: 5px;
            border-left: 4px solid #2196F3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        th {
            background: #eee;
        }

        .btn-action {
            text-decoration: none;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            border-radius: 5px;
            font-weight: bold;
            display: inline-block;
        }

        /* Modal de Edição */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background: white;
            margin: 15% auto;
            padding: 20px;
            width: 50%;
            border-radius: 8px;
        }

        textarea {
            width: 100%;
            height: 100px;
            margin: 10px 0;
            padding: 10px;
        }

        .close {
            float: right;
            font-size: 28px;
            cursor: pointer;
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
    </script>
</head>
<body>

<a href="javascript:history.back()" style="text-decoration: none; color: #555; font-weight: bold;">← Voltar</a>
<div style="display:flex; justify-content:space-between; align-items:center; margin: 20px 0;">
    <h1 style="margin:0;">Ficha Clínica: <%= p.getNome() %>
    </h1>

    <a href="${pageContext.request.contextPath}/AgendamentoServlet?action=gerir&idPaciente=<%= p.getidPaciente() %>"
       class="btn-action">
        📅 Gerir Agendamentos
    </a>
</div>

<div class="grid">
    <div class="card">
        <h2>Dados do Paciente</h2>
        <p><strong>Raça:</strong> <%= p.getRaca() %>
        </p>
        <p><strong>Data Nascimento:</strong> <%= p.getDataNascimento() %>
        </p>
        <p><strong>Data Obito:</strong> <%= (p.getDataObito() == null ? "Vivo" : p.getDataObito()) %></p>
        </p>
        <p><strong>NIF Tutor:</strong> <%= p.getNifDono() %>
        </p>
        <p>
            <strong>Idade:</strong> <span class="badge tag-idade"><%= p.getIdadeFormatada() %></span>
            <strong>Escalão:</strong> <span class="badge tag-escalao"><%= p.getEscalaoEtario() %></span>
        </p>
    </div>

    <div class="card">
        <h2>Árvore Genealógica</h2>
        <% if (pais != null && !pais.isEmpty()) { %>
        <% for (Paciente pai : pais) {
            String tipo = (pai.getObservacoes() != null) ? pai.getObservacoes().toUpperCase() : "PROGENITOR";
        %>
        <div class="tree-node">
            <strong><%= tipo %>:</strong>
            <a href="${pageContext.request.contextPath}/VeterinarioServlet?action=consultarFicha&idPaciente=<%= pai.getidPaciente() %>"><%= pai.getNome() %>
            </a>
        </div>
        <% } %>
        <% } else { %>
        <p style="color:#999; font-style: italic;">Sem registo de progenitores.</p>
        <% } %>
    </div>
</div>
<div class="card">
    <h2>Histórico Clínico e Notas</h2>
    <table>
        <thead>
        <tr>
            <th style="width: 15%">Data</th>
            <th style="width: 15%">Tipo</th>
            <th style="width: 50%">Descrição / Notas</th>
            <th style="width: 20%">Ações</th>
        </tr>
        </thead>
        <tbody>
        <% if (historico != null) {
            for (ServicoMedicoAgendamento s : historico) { %>
        <tr>
            <td><%= (s.getDataHoraAgendada() != null) ? s.getDataHoraAgendada().toString().replace("T", " ") : "-" %>
            </td>

            <td><span class="badge" style="background:#667eea"><%= s.getTipoServico() %></span></td>

            <td><%= s.getDescricao() %>
            </td>
            <td>
                <button onclick="abrirModal(<%= s.getIdServico() %>, '<%= s.getDescricao() %>')"
                        style="cursor:pointer; padding:5px 10px;">
                    ✏️ Editar Nota
                </button>
            </td>
        </tr>
        <% }
        } else { %>
        <tr>
            <td colspan="4" style="text-align:center; color:#777;">Sem histórico disponível.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="fecharModal()">&times;</span>
        <h3>Atualizar Nota Clínica</h3>
        <form action="${pageContext.request.contextPath}/VeterinarioServlet" method="post">
            <input type="hidden" name="action" value="atualizarNotas">
            <input type="hidden" name="idPaciente" value="<%= p.getidPaciente() %>">
            <input type="hidden" id="modalIdServico" name="idServico">

            <label>Descrição do Serviço / Notas:</label>
            <textarea id="modalTexto" name="notas" required></textarea>

            <button type="submit" class="btn-action" style="border:none; cursor:pointer;">Guardar Alterações</button>
        </form>
    </div>
</div>

</body>
</html>