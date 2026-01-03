<%@ page import="java.util.List" %>
<%@ page import="model.ServicoMedicoAgendamento" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<ServicoMedicoAgendamento> agenda = (List<ServicoMedicoAgendamento>) request.getAttribute("agenda");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Lista de Chamada</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background: #f4f4f9; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #667eea; color: white; }
        tr:hover { background-color: #f1f1f1; }
        .btn { padding: 8px 12px; background: #4CAF50; color: white; text-decoration: none; border-radius: 4px; }
        .back-link { display: inline-block; margin-bottom: 20px; text-decoration: none; color: #555; font-weight: bold; }
    </style>
</head>
<body>
<a href="VeterinarioServlet?action=dashboard" class="back-link">← Voltar ao Painel</a>
<h1>📋 Lista de Chamada</h1>

<% if (agenda == null || agenda.isEmpty()) { %>
<p>Não tem agendamentos previstos para hoje ou para o futuro.</p>
<% } else { %>
<table>
    <thead>
    <tr>
        <th>Data/Hora</th>
        <th>Serviço</th>
        <th>Local</th>
        <th>Estado</th>
        <th>Ação</th>
    </tr>
    </thead>
    <tbody>
    <% for (ServicoMedicoAgendamento s : agenda) { %>
    <tr>
        <td><%= s.getDataHoraAgendada().toString().replace("T", " ") %></td>
        <td><%= s.getDescricao() %></td>
        <td><%= s.getLocalidade() %></td>
        <td><%= s.getEstado() %></td>
        <td>
            <a href="VeterinarioServlet?action=consultarFicha&idPaciente=<%= s.getIdPaciente() %>" class="btn">Abrir Ficha</a>
        </td>
    </tr>
    <% } %>
    </tbody>
</table>
<% } %>
</body>
</html>