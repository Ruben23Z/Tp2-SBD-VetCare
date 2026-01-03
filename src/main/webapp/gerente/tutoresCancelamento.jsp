<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Map<String, Object>> dados = (List<Map<String, Object>>) request.getAttribute("dados"); %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Estatística Cancelamentos</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background: #f4f4f9; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #f44336; padding-bottom: 10px; margin-top: 0; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #fff5f5; color: #b71c1c; }
        .danger-badge { color: #d32f2f; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <a href="GerenteServlet?action=dashboard" style="text-decoration:none; color:#666;">← Voltar</a>
    <h2>🚫 Tutores com mais cancelamentos (Último Trimestre)</h2>

    <% if (dados == null || dados.isEmpty()) { %>
    <p>Não há registo de cancelamentos nos últimos 3 meses.</p>
    <% } else { %>
    <table>
        <thead>
        <tr>
            <th>Nome do Tutor</th>
            <th style="text-align: right;">Total Cancelados</th>
        </tr>
        </thead>
        <tbody>
        <% for(Map<String, Object> row : dados) { %>
        <tr>
            <td><%= row.get("nomeTutor") %></td>
            <td style="text-align: right;" class="danger-badge"><%= row.get("totalCancelados") %></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>