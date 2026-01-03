<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Map<String, Object>> dados = (List<Map<String, Object>>) request.getAttribute("dados"); %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Estatística Vida</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background: #f4f4f9; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px; margin-top: 0; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; color: #666; font-weight: 600; }
        tr:hover { background-color: #f1f1f1; }
        .positive { color: #28a745; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <a href="GerenteServlet?action=dashboard" style="text-decoration:none; color:#666;">← Voltar</a>
    <h2>👵 Animais que superaram a expectativa de vida</h2>

    <% if (dados == null || dados.isEmpty()) { %>
    <p>Não há registos de animais que tenham ultrapassado a esperança média de vida da espécie.</p>
    <% } else { %>
    <table>
        <thead>
        <tr>
            <th>Nome</th>
            <th>Raça</th>
            <th>Idade Atual</th>
            <th>Esperança Média</th>
            <th>Diferença</th>
        </tr>
        </thead>
        <tbody>
        <% for(Map<String, Object> row : dados) { %>
        <tr>
            <td><strong><%= row.get("nome") %></strong></td>
            <td><%= row.get("raca") %></td>
            <td><%= row.get("idade") %> anos</td>
            <td><%= row.get("expectVida") %> anos</td>
            <td class="positive">+<%= row.get("diferenca") %> anos</td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>