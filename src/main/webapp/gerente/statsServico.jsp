<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% List<Map<String, Object>> dados = (List<Map<String, Object>>) request.getAttribute("dados"); %>
<!DOCTYPE html>
<html lang="pt">
<head>
    <title>Previsão Semanal</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background: #f4f4f9; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #2196F3; padding-bottom: 10px; margin-top: 0; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #e3f2fd; color: #0d47a1; }
        .bar-container { width: 100px; background-color: #eee; height: 10px; border-radius: 5px; display: inline-block; margin-left: 10px; }
        .bar { background-color: #2196F3; height: 100%; border-radius: 5px; }
    </style>
</head>
<body>
<div class="container">
    <a href="GerenteServlet?action=dashboard" style="text-decoration:none; color:#666;">← Voltar</a>
    <h2>📈 Agendamentos Previstos (Próxima Semana)</h2>
    <p>Previsão baseada nos agendamentos ativos e pendentes para os próximos 7 dias.</p>

    <% if (dados == null || dados.isEmpty()) { %>
    <p>Sem agendamentos previstos para a próxima semana.</p>
    <% } else {
        // Encontrar o máximo para desenhar as barras proporcionais
        int max = 0;
        for(Map<String, Object> r : dados) {
            int qtd = (Integer) r.get("qtd");
            if(qtd > max) max = qtd;
        }
    %>
    <table>
        <thead>
        <tr>
            <th>Tipo de Serviço</th>
            <th>Quantidade Prevista</th>
        </tr>
        </thead>
        <tbody>
        <% for(Map<String, Object> row : dados) {
            int qtd = (Integer) row.get("qtd");
            int width = (max > 0) ? (qtd * 100) / max : 0;
        %>
        <tr>
            <td><strong><%= row.get("tipo") %></strong></td>
            <td>
                <%= qtd %>
                <div class="bar-container" style="width: 150px;">
                    <div class="bar" style="width: <%= width %>%;"></div>
                </div>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>